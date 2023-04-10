%% load images
%polscope = flip(imread('stitched_Day1_HE_slide1.tif'),2);
% HE = imread('HE_01.ome.tif');
TRI = imread('NMID1_Tri_02_10x.ome_crop.tif (RGB).tif');
% PSR_BF = imread('PSR 4x region crop.ome.tif (RGB).tif');
% PSR_POL = imread('PSR Pol large image 10x.ome.tif');


%% check left right orientations are same

figure(1)
montage({polscope, HE, TRI, PSR_BF, PSR_POL})

HE = flip(HE);
TRI = flip(TRI);
PSR_BF = flip(PSR_BF, 2);
PSR_POL = flip(PSR_POL, 2);

figure(2)
montage({polscope, HE, TRI, PSR_BF, PSR_POL})

%% select points

% figure(3)
% imshow(polscope)
% [x_ps, y_ps] = ginput(4);
% hold on
% scatter(x_ps, y_ps, 'filled')
% figure(4)
% imshow(HE)
% [x_HE, y_HE] = ginput(4);
% figure(5)
% imshow(TRI)
% [x_TRI, y_TRI] = ginput(4);
% figure(6)
% imshow(PSR_BF)
% [x_BF, y_BF] = ginput(4);
% figure(7)
% imshow(PSR_POL)
% [x_pol, y_pol] = ginput(4);

%% compute homology

% scr_pts = cat(3, [x_HE, y_HE], [x_TRI, y_TRI], [x_BF, y_BF]);
% 
% for n = 1:3
%     H(:,:,n) = computeHomography([x_ps, y_ps],scr_pts(:,:,n));
% end
% 
% [mask, result_img]=backwardWarpImg(polscope, inv(H(:,:,2)), size(TRI,2,1));
% 
% figure(8)
% imshow(uint16(result_img(:,:,1)))

%% Segment images

%y=round(size(polscope,1)/1000);
%x=round(size(polscope,2)/1000);
y = 2;
x = 2;
segim = imagesegments(polscope, y, x);

%% run sift
%image = imread()
%polscope = imbinarize(polscope,0.1);
TRI = 1-imbinarize(rgb2gray(TRI),0.6);
%%

Pol_2 = imresize(polscope, 0.25);
%Pol_2 = 1-bwareaopen(1-bwareaopen(Pol_2, 100),100);
TRI_2 = imresize(TRI, 0.5);
%TRI_2 = 1-bwareaopen(1-bwareaopen(TRI_2, 10),10);
% figure()
% montage({Pol_2, TRI_2})
%%
[xs, xd] = genSIFTMatches(im2single(Pol_2), im2single(TRI_2));

figure()
imshow(Pol_2)
hold on
plot(xs(:,1), xs(:,2), 'ro', 'MarkerFaceColor','r')

figure()
imshow(TRI_2)
hold on
plot(xd(:,1), xd(:,2), 'ro', 'MarkerFaceColor','r')
%%
%TRI_3 = padarray(TRI_2, (size(Pol_2, 1, 2)-size(TRI_2, 1, 2)), 0, 'post');
Pol_3 = padarray(Pol_2, (size(TRI_2, 1, 2)-size(Pol_2, 1, 2)), 0, 'post');
figure()
showCorrespondence( im2single(Pol_3), im2single(TRI_2), xs, xd);
%%

ransac_n = 3000; % Max number of iterations
ransac_eps = 100; %Acceptable alignment error 

[inliers_id, H_3x3] = runRANSAC(xs, xd, ransac_n, ransac_eps);

figure()
imshow(Pol_2)
hold on
plot(xs(inliers_id,1), xs(inliers_id,2), 'ro', 'MarkerFaceColor','r')

figure()
imshow(TRI_2)
hold on
plot(xd(inliers_id,1), xd(inliers_id,2), 'ro', 'MarkerFaceColor','r')

figure()
showCorrespondence(im2single(Pol_2), im2single(rgb2gray(TRI_3)), xs(inliers_id,:), xd(inliers_id, :));
% 
% figure()
% imshow(HE)
% hold on
% plot(xs(inliers_id, 1), xs(inliers_id, 2), 'ro', 'MarkerFaceColor','r')
% 
% figure()
% imshow(TRI)
% hold on
% plot(xd(inliers_id, 1), xd(inliers_id, 2), 'ro', 'MarkerFaceColor','r')