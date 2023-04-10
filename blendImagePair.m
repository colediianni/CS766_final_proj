function out_img = blendImagePair(wrapped_imgs, masks, wrapped_imgd, maskd, mode)

% imshow(wrapped_imgs)
% pause(1)
% imshow(masks)
% pause(1)

% disp(size(wrapped_imgs))
% disp(size(wrapped_imgd))
% disp(maskd)

% masked_imgs = wrapped_imgs;
% masked_imgs(~cat(3, masks, masks, masks)) = 0;
% imshow(masked_imgs)

% masked_imgd = wrapped_imgd;
% masked_imgd(~cat(3, maskd, maskd, maskd)) = 0;
% imshow(masked_imgd)

if mode == "blend"
    wrapped_imgs = im2double(wrapped_imgs);
    wrapped_imgd = im2double(wrapped_imgd);
    dist_masks = bwdist(~masks);
    dist_maskd = bwdist(~maskd);
    dist_masks = cat(3, dist_masks, dist_masks, dist_masks);
    dist_maskd = cat(3, dist_maskd, dist_maskd, dist_maskd);
    img1 = wrapped_imgs .* dist_masks ./ (dist_maskd + dist_masks);
    img1(isnan(img1))=0;
%     imshow(img1)
%     pause(1)
    img2 = wrapped_imgd .* dist_maskd ./ (dist_maskd + dist_masks);
    img2(isnan(img2))=0;
%     imshow(img2)
%     pause(1)
%     disp(sum(img1, "all"))
%     disp(sum(img2, "all"))
%     imshow((dist_maskd + dist_masks))
%     pause(1)
%     disp(sum(img1 + img2, "all"))
%     imshow(img1 + img2)
%     pause(1)
    out_img = img1 + img2;
%     imshow(out_img)
%     pause(1)
end

if mode == "overlay"
    out_img = wrapped_imgs;
    out_img(cat(3, maskd, maskd, maskd) ~= 0) = 0;
    out_img = out_img + wrapped_imgd;
%     imshow(out_img)
end



