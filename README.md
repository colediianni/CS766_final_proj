# CS766_final_proj

Project Video: https://drive.google.com/file/d/1FroG0yY732nsWN6fQn58ZwvfSXgo2O6f/view?usp=sharing

As part of a study into the early stages of myocardial infarction healing, images of fixed histological samples of left ventricular tissue were captured using multiple imaging modalities. The types of imaging include traditional brightfield microscopy of the stained slides and polarized light microscopy. The challenge we hope to solve by working on this project is registering the collagen images, from the polarized light microscopy, with the cell images from the brightfield microscopy and the total infarcted region. 

These imaging techniques provide information about the cells, collagen content, and other tissue properties. Correctly combining the images together is important since there is different information collected that is specific to each modality. For example, polarized collagen images provide context for the structural properties of the tissue, and it is important to localize this information in comparison to the location of the cells on the brightfield images using image registration techniques. Registration and co-localization of the image features will allow for more accurate assessment of how the various components change over space and time.
 
There are currently some programs, such as CurveAlign or tools in ImageJ or MATLAB, that are designed to help solve the registration issues. Specifically, MATLAB has several image registration methods, including an automatic image registration method and a control point registration method. ImageJ has tools for tile alignment, image stack alignment and time series alignment. These tools are useful for image alignment in general, but can fail when regarding use-cases such as these where multiple modalities are involved. 

Issue with existing methods:
Existing methods registration programs in MATLAB and ImageJ were tested. ImageJ was unable to match any images, even those that were two slices from the same sample with the same stain. MATLAB’s multimodal image registration method also was unable to properly overlay the images. It was able to correct the global orientation (flipping the moving image) but was not able to resize the image correctly to match the scale, this can be visualized with the extra signal in the lower corners. Given its very long run time troubleshooting and improving the implementation with the various parameters would be highly time consuming. Additionally, optimization would likely be needed for each image type.

As this is a specific use-case, we will design our own codes and benchmark against existing solutions. Our goal will be to design a program that efficiently takes the input of stitched images from each modality at various scales and outputs the processed images registered on top of each other. This will involve computing homographies based on automatically detected SIFT landmarks. Due to the large sizes of the images, we are considering computing the homographies on small patches, which we will then map individually to a localized region of the other image. This has the extended effect of allowing the image to warp differently in different sections of the image. Since the image is a tissue, which can easily bend and stretch when placed on different slides, this feature is expected to produce a more locally consistent mapping of the images.

The current programs are designed to solve similar issues, but they generally work best with other types of microscopy modalites. We may be able to use existing image registration tools as a comparison with our method, but the existing techniques are not specialized to the task we’ve put forth because they do not handle different modalities and scales well. The various challenges of this project from a computing standpoint include the fact that the modalities have different magnification, different color schemes, and are designed to highlight different components of the sample. This means the features shown with each modality may differ. We plan on using the SIFT techniques discussed in class to align the images without respect to the specific color scheme used during measurement. With each imaging modality, it is likely that the image will have rotated or tilted so the images may not correspond perfectly. Additionally, some of the images we need to register may not be from the exact same slide, so there could be potential warping associated with how the tissue is placed on the slide. Furthermore, the images were collected at different magnifications (4x, 10x, 20x) meaning the images have been previously stitched together. This stitching process also produces a very large image that is computational intensive to process. Our plan is to use small patches of images to create faster processing, create more freedom of movement for matching each patch, and to get a better local registration. We will need to process the stitched images so the features are clearly seen, and then, we will need to identify features on each of the slides to help with the registration process. 

Our solution includes steps such as identifying landmarks in the images and using image alignment techniques to fit the images together. For feature identification images were first preprocessed to reduce variation as a result of coloration and image modality.

The computation of this will requires a homography. The outputs of the project include comparisons between the program and manual measurements to quantify how well the registration worked (as described in the project video). We are also able to evaluate our method visually by producing masks of each modality that can be overlaid over the original H&E image in the code output.



![data ](https://user-images.githubusercontent.com/111527077/236087773-1bc0d9da-3a44-412f-90d3-4b3af6c71e40.png)

Figure 1: Example data set of the brightfield and polscope images. 

![image](https://user-images.githubusercontent.com/111527077/236087301-f71dbdbb-6dba-476f-be36-0be329e0546a.png)

Figure 2: Registration attmpt with built in MATLAB tools. 

![patches](https://user-images.githubusercontent.com/111527077/236084728-e19129ec-49ee-4f92-bc92-0e0e4d9394d6.png)

Figure 3: Demonstration of cutting the image into patches. 

![comparison](https://user-images.githubusercontent.com/111527077/236084739-37e9a439-0829-46be-96ce-a29b4aab9278.png)

Figure 4: Comparison of homography results with patches and without patches.

![final](https://user-images.githubusercontent.com/111527077/236084742-686d6de9-4cb7-4ec8-b962-b3a62b5a1f76.png)

Figure 5: Final result of overlaid images.
