function [stitched_img, stitched_img_mask] = tiled_homography(img1, img2, num_y_patches, num_x_patches, padding)

img_1_size = size(img1);
patch_size_y1 = size(img1, 1)/num_y_patches;
patch_size_x1 = size(img1, 2)/num_x_patches;
assert(floor(patch_size_y1)==patch_size_y1)
assert(floor(patch_size_x1)==patch_size_x1)

patch_size_y2 = size(img2, 1)/num_y_patches;
patch_size_x2 = size(img2, 2)/num_x_patches;
assert(floor(patch_size_y2)==patch_size_y2)
assert(floor(patch_size_x2)==patch_size_x2)

impl = 'MATLAB';
ransac_n = 8000; % Max number of iterations
ransac_eps = 5; % Acceptable alignment error 

for y_patch_idx = 1:num_y_patches
    for x_patch_idx = 1:num_x_patches

        patch1 = img1(max(1, 1+(y_patch_idx-1)*patch_size_y1 - padding):min(size(img1, 1), y_patch_idx*patch_size_y1 + padding), max(1, 1+(x_patch_idx-1)*patch_size_x1 - padding):min(size(img1, 2), x_patch_idx*patch_size_x1 + padding));
        patch2 = img2(1+(y_patch_idx-1)*patch_size_y2:y_patch_idx*patch_size_y2, 1+(x_patch_idx-1)*patch_size_x2:x_patch_idx*patch_size_x2);

        [xs, xd] = genSIFTMatches(patch2, patch1, impl);

        if size(xs, 1) >= 4
            [inliers_id, H_3x3] = runRANSAC(xs, xd, ransac_n, ransac_eps);
            dest_canvas_width_height = [size(patch1, 2), size(patch1, 1)];
            [dest_img_mask, dest_img] = backwardWarpImg(patch2, inv(H_3x3), dest_canvas_width_height);  
            
            patch_dest_img = zeros(img_1_size(1), img_1_size(2));
            patch_img_mask = zeros(img_1_size(1), img_1_size(2));
            patch_dest_img(max(1, 1+(y_patch_idx-1)*patch_size_y1 - padding):min(size(img1, 1), y_patch_idx*patch_size_y1 + padding), max(1, 1+(x_patch_idx-1)*patch_size_x1 - padding):min(size(img1, 2), x_patch_idx*patch_size_x1 + padding)) = dest_img(:, :, 1);
            patch_img_mask(max(1, 1+(y_patch_idx-1)*patch_size_y1 - padding):min(size(img1, 1), y_patch_idx*patch_size_y1 + padding), max(1, 1+(x_patch_idx-1)*patch_size_x1 - padding):min(size(img1, 2), x_patch_idx*patch_size_x1 + padding)) = dest_img_mask;

            if y_patch_idx == 1 && x_patch_idx == 1
                blended_result = patch_dest_img;
                blended_mask = patch_img_mask;
            else
                blended_result = cat(3, blended_result, blended_result, blended_result);
                patch_dest_img = cat(3, patch_dest_img, patch_dest_img, patch_dest_img);
                blended_result = blendImagePair(blended_result, blended_mask, patch_dest_img, patch_img_mask, 'overlay');
                %unique(blended_result)
                blended_result = blended_result(:, :, 1);
                blended_mask = blended_mask + patch_img_mask;
            end
        else
            disp("not enough ransac points to compute homography")
        end
    end
end

stitched_img = blended_result;
stitched_img_mask = blended_mask;