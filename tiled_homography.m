function stitched_img = tiled_homography(img1, img2, num_y_patches, num_x_patches)

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


% impl = 'MATLAB';
% [xs, xd] = genSIFTMatches(img1, img2, impl);
% 
% figure()
% imshow(img1)
% hold on
% plot(xs(:,1), xs(:,2), 'ro', 'MarkerFaceColor','r')
%  
% figure()
% imshow(img2)
% hold on
% plot(xd(:,1), xd(:,2), 'ro', 'MarkerFaceColor','r')
% 
% 
% % disp(size(xs))
% ransac_n = 3000;
% ransac_eps = 10;
% [inliers_id, H_3x3] = runRANSAC(xs, xd, ransac_n, ransac_eps);
% % disp(size(inliers_id))

% figure()
% imshow(img1)
% pause(2)
% figure()
% imshow(img2)
% pause(2)

% assert(isequal(size(img1), size(img2)))

if floor(size(img1, 1) / 2) ~= size(img1, 1) / 2
    img1 = img1(1:size(img1, 1)-1, :);
end
if floor(size(img1, 2) / 2) ~= size(img1, 2) / 2
    img1 = img1(:, 1:size(img1, 2)-1);
end
patch_size_y1 = size(img1, 1)/num_y_patches;
patch_size_x1 = size(img1, 2)/num_x_patches;
assert(floor(patch_size_y1)==patch_size_y1)
assert(floor(patch_size_x1)==patch_size_x1)

if floor(size(img2, 1) / 2) ~= size(img2, 1) / 2
    img2 = img2(1:size(img2, 1)-1, :);
end
if floor(size(img2, 2) / 2) ~= size(img2, 2) / 2
    img2 = img2(:, 1:size(img2, 2)-1);
end
patch_size_y2 = size(img2, 1)/num_y_patches;
patch_size_x2 = size(img2, 2)/num_x_patches;
assert(floor(patch_size_y2)==patch_size_y2)
assert(floor(patch_size_x2)==patch_size_x2)
% disp(size(img1, 1))
% disp(size(img1, 2))

% img1_patches = mat2cell(img1,zeros(num_y_patches,1) + floor(patch_size_y1), zeros(num_x_patches,1) + floor(patch_size_x1));
% disp(img1_patches)
% img2_patches = mat2cell(img2,zeros(num_y_patches,1) + floor(patch_size_y2), zeros(num_x_patches,1) + floor(patch_size_x2));

% stop

padding = 100;

impl = 'MATLAB';
ransac_n = 3000; % Max number of iterations
ransac_eps = 10; % Acceptable alignment error 

for y_patch_idx = 1:num_y_patches
    for x_patch_idx = 1:num_x_patches

%         patch1 = img1_patches{y_patch_idx, x_patch_idx};
%         patch2 = img2_patches(min(1, y_patch_idx-1):min(num_y_patches, y_patch_idx+1), min(1, x_patch_idx-1):min(num_x_patches, x_patch_idx+1));
        patch1 = img1(max(1, 1+(y_patch_idx-1)*patch_size_y1 - padding):min(size(img1, 1), y_patch_idx*patch_size_y1 + padding), max(1, 1+(x_patch_idx-1)*patch_size_x1 - padding):min(size(img1, 2), x_patch_idx*patch_size_x1 + padding));
%         patch2 = cell2mat(patch2);
%         disp(size(patch1))
%         imshow(patch1)
%         pause(0.5)

        patch2 = img2(1+(y_patch_idx-1)*patch_size_y2:y_patch_idx*patch_size_y2, 1+(x_patch_idx-1)*patch_size_x2:x_patch_idx*patch_size_x2);
%         disp(size(patch2))

        [xs, xd] = genSIFTMatches(patch2, patch1, impl);

%         figure()
%         imshow(patch1)
%         hold on
%         plot(xs(:,1), xs(:,2), 'ro', 'MarkerFaceColor','r')
%         
%         figure()
%         imshow(patch2)
%         hold on
%         plot(xd(:,1), xd(:,2), 'ro', 'MarkerFaceColor','r')

        disp(size(xs))
        disp(size(xd))
        if size(xs, 1) >= 4
            [inliers_id, H_3x3] = runRANSAC(xs, xd, ransac_n, ransac_eps);
            disp(size(inliers_id))
            dest_canvas_width_height = [size(patch1, 2), size(patch1, 1)];
            [dest_img_mask, dest_img] = backwardWarpImg(patch2, inv(H_3x3), dest_canvas_width_height);
%             imshow(dest_img_mask)
%             pause(1)
            figure()
            imshow(dest_img)
%         
%             stitched_img_mask = zeros(dest_canvas_width_height(2), dest_canvas_width_height(1));
%             disp(size(stitched_img_mask))
%             disp(size(dest_img_mask))
%             blended_result = blendImagePair(patch2, stitched_img_mask, dest_img, dest_img_mask, 'overlay');
% %             stitched_img = blended_result;
        else
            disp("not enough ransac points to compute homography")
            % TODO put image1 into the center patch of image 2
            % TODO consider averageing the homographies of surrounding patches
        end
    end
end