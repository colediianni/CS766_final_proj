%function sliceoutput(display) 

%display is image stack that we want to scroll through

%making test image stack
hill = imread('C:\Users\Owner\Documents\Wisconsin\Classes\CS 766\hw4_hwilson23\MATLAB (1)\Image1.jpg');
hill = imrotate(hill,-90);
vase = imread('vase1.png'); 
sphere = im2double(imread('sphere0.png')); 


sizes = [size(hill); size(vase), 1; size(sphere), 1];
maxrow = max(sizes(:,1));
maxcol = max(sizes(:,2));
maxrgb = max(sizes(:,3));

hill = imresize(hill,'Outputsize', [maxrow/2, maxcol]);
vase = imresize(vase,'Outputsize',[maxrow/2, maxcol]);
sphere = imresize(sphere, 'Outputsize',[maxrow/2, maxcol]);

combined = double(im2gray(hill)).*double(vase).*im2gray(sphere);
figure(); imshow(sphere)
stack = cat(3,combined,hill,im2gray(sphere),vase);
figure()
sliceViewer(stack);

