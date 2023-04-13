function sliceoutput(display) 

%display is image stack that we want to scroll through

%{
%making test image stack
hill = imread('C:\Users\Owner\Documents\Wisconsin\Classes\CS 766\hw4_hwilson23\MATLAB (1)\Image1.jpg');
hill = imrotate(hill,-90);
vase = imread('vase1.png'); 
sphere = im2double(imread('sphere0.png')); 
%}

%sizes = [size(hill); size(vase), 1; size(sphere), 1];
sizes = [size(display{1}); size(display{2});size(display{3});size(display{4});size(display{5})];
maxrow = max(sizes(:,1));
maxcol = max(sizes(:,2));
%maxrgb = max(sizes(:,3));

figure(); imshow(display{1})

polscope = imresize(display{1},'Outputsize', [maxrow/2, maxcol]);
HE = imresize(display{2},'Outputsize',[maxrow/2, maxcol]);
TRI = imresize(display{3}, 'Outputsize',[maxrow/2, maxcol]);
PSR_BF = imresize(display{4}, 'Outputsize',[maxrow/2, maxcol]);
PSR_POL = imresize(display{5}, 'Outputsize',[maxrow/2, maxcol]);

%combined = double(polscope.*HE.*TRI.*PSR_BF.*PSR_POL);
%figure(); imshow(sphere)


% four RGB images
A = polscope;
s = size(A);
B = HE;
C = TRI;
D = PSR_BF;
E = PSR_POL;
% colormap
cm = [1 0 0;0.5 1 0;0 1 1;0.5 0 1;1 1 1];
% colorize the images
Ac = imblend(colorpict(s(1:2),cm(1,:)),A,1,'multiply');
Bc = imblend(colorpict(s(1:2),cm(2,:)),B,1,'multiply');
Cc = imblend(colorpict(s(1:2),cm(3,:)),C,1,'multiply');
Dc = imblend(colorpict(s(1:2),cm(4,:)),D,1,'multiply');
Ec = imblend(colorpict(s(1:2),cm(5,:)),E,1,'multiply');
% blend the images
combined = mergedown(cat(4,Ac,Bc,Cc,Dc),1,'screen');
figure(); imshow(combined)
stack = cat(3,polscope,HE,TRI, PSR_BF, PSR_POL);
figure()
sliceViewer(stack);
end
