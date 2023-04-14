%% load images
fds = fileDatastore('*.tif', 'ReadFcn', @importdata);

fullFileNames = fds.Files;

numFiles = length(fullFileNames);

for i=1:length(fullFileNames)
    image{i} = imread(fullFileNames{i});
end
%% check left right orientations are same

figure(1)
montage(image)

x = 6; 
image{x}=flip(image{x},2);

figure(2)
montage(image)


%% Segment images

%y=round(size(polscope,1)/1000);
%x=round(size(polscope,2)/1000);
% y = 2;
% x = 2;
% segim = imagesegments(polscope, y, x);

%% run sift

%polscope = imbinarize(image{6},0.1);
polscope = rgb2gray(image{2});
%BF = 1-imbinarize(rgb2gray(image{2}),0.6);
BF = rgb2gray(image{3});
montage({polscope, BF})
%%

Pol_2 = imresize(polscope, 0.25);
BF_2 = imresize(BF, 0.5);

%%
[xs, xd] = genSIFTMatches(im2single(Pol_2), im2single(BF_2));

% figure()
% imshow(Pol_2)
% hold on
% plot(xs(:,1), xs(:,2), 'ro', 'MarkerFaceColor','r')
% 
% figure()
% imshow(BF_2)
% hold on
% plot(xd(:,1), xd(:,2), 'ro', 'MarkerFaceColor','r')

%BF_3 = padarray(BF_2, (size(Pol_2, 1, 2)-size(BF_2, 1, 2)), 0, 'post');
Pol_3 = padarray(Pol_2, (size(BF_2, 1, 2)-size(Pol_2, 1, 2)), 0, 'post');
% figure()
showCorrespondence( im2single(Pol_3), im2single(BF_2), xs, xd);
%

ransac_n = 100000; % Max number of iterations
ransac_eps = 10; %Acceptable alignment error 

[inliers_id, H_3x3] = runRANSAC(xs, xd, ransac_n, ransac_eps);

% figure()
% imshow(Pol_2)
% hold on
% plot(xs(inliers_id,1), xs(inliers_id,2), 'ro', 'MarkerFaceColor','r')
% 
% figure()
% imshow(BF_2)
% hold on
% plot(xd(inliers_id,1), xd(inliers_id,2), 'ro', 'MarkerFaceColor','r')
% 
% figure()
showCorrespondence(im2single(Pol_3), im2single(BF_2), xs(inliers_id,:), xd(inliers_id, :));
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


%% apply homology

 
[mask, result_img]=backwardWarpImg(Pol_2, inv(H_3x3), size(BF_2,2,1));

figure()
imshow(result_img)