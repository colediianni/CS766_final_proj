Project Video: 

https://drive.google.com/file/d/1FroG0yY732nsWN6fQn58ZwvfSXgo2O6f/view?usp=sharing

Motivation

As part of a study into the early stages of myocardial infarction healing, images of fixed histological samples of left ventricular tissue were captured using multiple imaging modalities. The types of imaging include traditional brightfield microscopy of the stained slides and polarized light microscopy (examples in Figure 1). The challenge we attempt to solve in this project is registering the collagen images, from the polarized light microscopy, with the cell images from the brightfield microscopy and the total infarcted region.

![data ](https://user-images.githubusercontent.com/111527077/236087773-1bc0d9da-3a44-412f-90d3-4b3af6c71e40.png)

Figure 1: Example data set of the brightfield and polscope images.

These imaging techniques provide information about the cells, collagen content, and other tissue properties. Correctly overlaying the images allow for the varying information collected with different modalities to be cross referenced. For example, polarized images provide context for the structural properties of the tissue, and it is important to localize this information in comparison to the location of the cells on the brightfield images using image registration techniques. Registration and co-localization of the image features will allow for more accurate assessment of how the various components change over space and time.
There are currently some programs, such as CurveAlign or tools in ImageJ or MATLAB, that are designed to help solve the registration issues. Specifically, MATLAB has several image registration methods, including an automatic image registration method and a control point registration method. ImageJ has tools for tile alignment, image stack alignment and time series alignment. These tools are useful for image alignment in general, but can fail when regarding use-cases such as these where multiple modalities are involved. For example, in Figure 2, MATLAB’s automatic image registration tool was not able to work well with these modalities. Here, the polarized collagen image is in green, with the brightfield image in purple.

![image](https://user-images.githubusercontent.com/111527077/236087301-f71dbdbb-6dba-476f-be36-0be329e0546a.png)

Figure 2: Registration attmpt with built in MATLAB tools. 

Issue with existing methods: Existing methods registration programs in MATLAB and ImageJ were tested. ImageJ was unable to match any images, even those that were two slices from the same sample with the same stain. MATLAB’s multimodal image registration method also was unable to properly overlay the images. It was able to correct the global orientation (flipping the moving image) but was not able to resize the image correctly to match the scale. Given its very long run time, troubleshooting and improving the implementation with the various parameters would be highly time consuming. Additionally, optimization would likely be needed for each image type.

Approach

As this is a specific use-case, we have designed our own code and benchmarked them against existing solutions. Our goal was to design a program that efficiently takes the input of stitched images from each modality at various scales and outputs the processed images registered on top of each other. Deep learning techniques were briefly considered, but determined not to fit the problem at hand given the extremely limited dataset size (only a handful of images) and the lack of a ground truth alignment. Instead, our developed aproach involves computing homographies based on automatically detected SIFT landmarks. Due to the large sizes of the images, the images were downsized. However, we show that the homography matrices computed at the smaller scale can easily be manipulated to apply to the larger images. We compute the homographies on small patches, which are then individually mapped to a localized region of the other image. This has the effect of allowing the image to warp differently in different sections of the image. Since the image is a tissue, which can easily bend and stretch when placed on different slides, this feature produces a more locally consistent mapping of the images.
The current programs are designed to solve similar issues, but they generally work best with other types of microscopy modalites. Again, the existing techniques are not specialized to the task we’ve put forth because they do not handle different modalities and scales well. The various challenges of this project from a computing standpoint include the fact that the modalities have different magnification, different color schemes, and are designed to highlight different components of the sample. This means the features shown with each modality may differ. With each imaging modality, it is likely that the image will have rotated or tilted so the images may not correspond perfectly. Additionally, some of the images we need to register may not be from the exact same slide, so there could be potential warping associated with how the tissue is placed on the slide. Furthermore, the images were collected at different magnifications (4x, 10x, 20x) meaning the images have been previously stitched together. This stitching process also produces a very large image that is computational intensive to process. 

<!-- ![patches](https://user-images.githubusercontent.com/111527077/236084728-e19129ec-49ee-4f92-bc92-0e0e4d9394d6.png) -->
<img src="https://user-images.githubusercontent.com/111527077/236084728-e19129ec-49ee-4f92-bc92-0e0e4d9394d6.png" width=50% height=50%>

Figure 3: Demonstration of cutting the image into patches. 

Implementation and Results 

Our solution includes steps such as identifying landmarks in the images and using image alignment techniques to fit the images together. For feature identification images were first binarized to reduce variation as a result of coloration and image modality. Images could not be matched without preprocessing due to the variation in color and features present. Binarizing the images to the background and foreground to produce distinct patterns that were more consistent between samples. This preprocessing allowed shared features to be identified using SIFT. Finally, the images are broken into patches which allows for improved local registration over a global homography (Figure 3, 4, 5). Homographies are then calculated for each region and then mapped to the other image. 


The final output from our alignment process is an image highlighting green (image A material only), red (image B material only), white (both image material), and black areas (no material from either image). From the images below in Figure 4, we see our patch-based alignment (left) is extremely similar overall to the global homography alignment (right). However, detailed inspection reveals small gaps between the patches. While fluid transitions from one patch to another would have been ideal, this result is unsurprising given each patch had to match SIFT points focused around the center of the patch rather than the center of the image. We also found that using patches allowed the image to better align small details in the image (Figure 5). This is attributed to the different image sections only requiring local image consistency.

![patches left](https://user-images.githubusercontent.com/111527077/236092269-70e37eb0-36ff-4689-a921-622628e5c36d.png)

Figure 4: Registration with patches (left) and no patches (right).

<!-- ![comparison](https://user-images.githubusercontent.com/111527077/236084739-37e9a439-0829-46be-96ce-a29b4aab9278.png) -->
<img src="https://user-images.githubusercontent.com/111527077/236084739-37e9a439-0829-46be-96ce-a29b4aab9278.png" width=50% height=50%>

Figure 5: Comparison of homography results with patches and without patches.

The results of the project include comparisons between the program and manual measurements to quantify how well the registration worked. These measurements have been included in Table 1. Noticeably, the amount of variation in the affine transform accuracy was highly dependent on how close you were to the manually selected landmarks used to compute the transform. This meant the transform had a high accuracy near the landmarks, but was not as good globally as the homography. This drawback is likely applicable to using a gloabl homography matrix as well, only performing well in regions near the most SIFT points. Examples of a measurement (computed using QuPath) and a full affine transform are shown in Figure 6. 

<!-- ![table2](https://user-images.githubusercontent.com/111527077/236090647-f3911b5d-3807-4758-aa15-dc1086e141b8.png) -->
<img src="https://user-images.githubusercontent.com/111527077/236090647-f3911b5d-3807-4758-aa15-dc1086e141b8.png" width=30% height=30%>


Table 1: Measurement of various landmarks in our output image and with the affine transform. 

![measurements](https://user-images.githubusercontent.com/111527077/236090580-482caace-e49d-4212-9c39-1893653bfa1d.png)

Figure 6: Examples of measurements of affine transform for comparison.


We are also able to evaluate our method visually by producing masks of each modality that can be overlaid over the original H&E image in the code output. As we can see, using the patches increased the accuracy of the homography (Figure 5). Our overall output is shown as an example image in Figure 7, with the two modalities overlaid on top of one another using MATLAB’s imshowpair function. 

![final](https://user-images.githubusercontent.com/111527077/236084742-686d6de9-4cb7-4ec8-b962-b3a62b5a1f76.png)

Figure 7: Final result of overlaid images.

One advantage of using this method is we can resize the images to calculate the homographies and then apply a transformation to apply this calculated homography to the original sized image. While we were not able to fully implement this we were able to determine the methodology to rescale our homography, here (equation 1) h is the homography matrix and s1 and s2 are our scaling factors that were used to shrink the original images.

<!-- ![homography](https://user-images.githubusercontent.com/111527077/236091471-494f24e3-20a2-4a06-8ae1-ff377c51fb68.png) -->
<img src="https://user-images.githubusercontent.com/111527077/236091471-494f24e3-20a2-4a06-8ae1-ff377c51fb68.png" width=30% height=30%>

Equation 1: Homography computation. 

Limitations and Problems Encountered

With our program, we found that the images needed landmarks in all quadrants in order to work properly. Otherwise, the homography would warp severly and not be a correct output image. If the images were not properly binarized with good thresholds, there were also issues with the amount of data left in the images. 
An additional limitation included the size of the images themselves, which slowed down run time. The number of patches also affected run time, which led to a more coarse alignment than was ideal, as demonstrated by some of the gaps between the patches. 

In future works, we hope to test the rescaling of the homography matrices on test images. We are also interested in implementing techniques similar to optical flow’s image pyramids to apply homographies in a coarse-to-fine manner. This would allow our method to capture both coarse and fine grain shifts and better align the images at each scale. 

Please note, the biological images were too large to upload to github. A placeholder folder has been uploaded, but please contact the authors for access to the biological dataset. 


References:

1. Dan Mueller, Dirk Vossen, Bas Hulsken. (2011). Real-time deformable registration of multi-modal whole slides for digital pathology. Computerized Medical Imaging and Graphics. ISSN 0895-6111, Volume 35, Issues 7–8, Pages 542-556, https://doi.org/10.1016/j.compmedimag.2011.06.006.

2. Jeremy L Muhlich, Yu-An Chen, Clarence Yapp, Douglas Russell, Sandro Santagata, Peter K Sorger, Stitching and registering highly multiplexed whole-slide images of tissues and tumors using ASHLAR, Bioinformatics, Volume 38, Issue 19, 1 October 2022, Pages 4613–4621, https://doi.org/10.1093/bioinformatics/btac544

3. Krishna, V. et al. (2021). GloFlow: Whole Slide Image Stitching from Video Using Optical Flow and Global Image Alignment. In: , et al. Medical Image Computing and Computer Assisted Intervention – MICCAI 2021. MICCAI 2021. Lecture Notes in Computer Science(), vol 12908. Springer, Cham. https://doi.org/10.1007/978-3-030-87237-3_50

4. MATLAB, imregister, https://www.mathworks.com/help/images/ref/imregister.html

5. Lowe, D. G. (2004). Distinctive Image Features from Scale-Invariant Keypoints. International Journal of Computer Vision, 60(2), 91–110. doi:10.1023/b:visi.0000029664.99615.94

6. Bankhead, P. et al. QuPath: Open source software for digital pathology image analysis. Scientific Reports (2017). https://doi.org/10.1038/s41598-017-17204-5

8. Bankhead,P. “QuPath Extension Align,” https://github.com/qupath/qupath-extension-align
