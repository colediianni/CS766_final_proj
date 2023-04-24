function run_final()

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

if floor(size(img1, 1) / 2) ~= size(img1, 1) / 2
    img1 = img1(1:size(img1, 1)-1, :);
end
if floor(size(img1, 2) / 2) ~= size(img1, 2) / 2
    img1 = img1(:, 1:size(img1, 2)-1);
end
assert(floor(patch_size_y1)==patch_size_y1)
assert(floor(patch_size_x1)==patch_size_x1)

if floor(size(img2, 1) / 2) ~= size(img2, 1) / 2
    img2 = img2(1:size(img2, 1)-1, :);
end
if floor(size(img2, 2) / 2) ~= size(img2, 2) / 2
    img2 = img2(:, 1:size(img2, 2)-1);
end
assert(floor(patch_size_y2)==patch_size_y2)
assert(floor(patch_size_x2)==patch_size_x2)



[stitched_img, stitched_img_mask] = tiled_homography(img1, img2, 2, 2);
unique(stitched_img)

%sliceoutput({stitched_img, img1})
figure();imshowpair(stitched_img,img1)
figure(); imshow(img1-stitched_img)
disp('value')
[row,col] = size(img1);
sum(abs(img1-stitched_img),'all')/(row*col)

impl = 'MATLAB';
ransac_n = 4000; % Max number of iterations
ransac_eps = 5;
[xs, xd] = genSIFTMatches(img2,img1, impl);
[inliers_id, H_3x3] = runRANSAC(xs, xd, ransac_n, ransac_eps);
dest_canvas_width_height = [size(img1, 2), size(img1, 1)];
[dest_img_mask, dest_img] = backwardWarpImg(img2, inv(H_3x3), dest_canvas_width_height);
unique(dest_img)


%sliceoutput({stitched_img, img1})
figure();imshowpair(dest_img,img1)
figure(); imshow(img1-dest_img)
disp('value')
[row,col] = size(img1);
sum(abs(img1-dest_img),'all')/(row*col)

end

