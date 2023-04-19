function [im1, im2] = colorsegment(img1, img2)

numColors = 2;
L = imsegkmeans(img1,numColors);
im1 = labeloverlay(img1,L);
figure(); imshow(im1)
title("Labeled Image RGB  1")

L = imsegkmeans(img2,numColors);
im2 = labeloverlay(img2,L);
figure(); imshow(im2)
title("Labeled Image RGB 2")

end