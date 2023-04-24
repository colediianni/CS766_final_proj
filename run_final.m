function done = run_final()

% img1 = imread(fullfile('images', 'Day 3', 'NMI-D3-92222-001-20x.ome.tif'));
% img1 = imread(fullfile('images', 'Day 5', 'NMID5_Tri_02_10x.ome.tif (RGB).tif'));
img1 = imread(fullfile('images', 'Day 1 R', 'MIR_D1_HE.tif'));
img1 = imresize(img1,0.08);
% img2 = imread(fullfile('images', 'Day 3', 'stitched_Day3_HE_slide1.tif'));
% img2 = imread(fullfile('images', 'Day 5', 'NMI-D5-92222-001-20x.ome.tif'));
img2 = imread(fullfile('images', 'Day 1 R', 'NMIRD1-11323-002-10x.ome.tif'));
img2 = flip(img2, 1);
img2 = imresize(img2,0.1);
img1 = imbinarize(img1, 0.09);
img2 = 1 - imbinarize(rgb2gray(img2), 0.45);
img2 = img2(250:850, 400:1250);


[stitched_img, stitched_img_mask] = tiled_homography(img1, img2, 2, 2);

sliceoutput({stitched_img, img1, img1, img1, img1})



done = 1;
