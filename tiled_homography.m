function stitched_img = tiled_homography(img1, img2, num_y_patches, num_x_patches)

assert(isequal(size(img1), size(img2)))
patch_size_y = size(img1, 1)/num_y_patches;
patch_size_x = size(img1, 2)/num_x_patches;
assert(floor(patch_size_y)==patch_size_y)
assert(floor(patch_size_x)==patch_size_x)

disp(size(img1))

img1_patches = mat2cell(img1,zeros(num_y_patches,1) + floor(patch_size_y), zeros(num_x_patches,1) + floor(patch_size_x), 3);
% disp(img1_patches)
img2_patches = mat2cell(img2,zeros(num_y_patches,1) + floor(patch_size_y), zeros(num_x_patches,1) + floor(patch_size_x), 3);


impl = 'MATLAB';
ransac_n = 100; % Max number of iterations
ransac_eps = 2; % Acceptable alignment error 

for y_patch_idx = 1:num_y_patches
    for x_patch_idx = 1:num_x_patches

        patch1 = img1_patches{y_patch_idx, x_patch_idx};
        patch2 = img2_patches(max(1, y_patch_idx-1):min(num_y_patches, y_patch_idx+1), max(1, x_patch_idx-1):min(num_x_patches, x_patch_idx+1));
        patch2 = cell2mat(patch2);
        imshow(patch2)
        pause(1)


%         [xs, xd] = genSIFTMatches(img1, img2, impl);
%         [inliers_id, H_3x3] = runRANSAC(xs, xd, ransac_n, ransac_eps);
%         [dest_img_mask, dest_img] = backwardWarpImg(img1, inv(H_3x3), dest_canvas_width_height);
%         stitched_img_mask = stitched_img > 0;
%     
%         stitched_img_mask = sum(stitched_img_mask, 3) ~= 0;
%         blended_result = blendImagePair(stitched_img, stitched_img_mask, dest_img, dest_img_mask, 'overlay');
%         stitched_img = blended_result;

    end
end