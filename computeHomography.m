function H_3x3 = computeHomography(src_pts_nx2, dest_pts_nx2)


% orig_img = imread('portrait.png'); 
% warped_img = imread('portrait_transformed.png');
% 
% imshow(orig_img)
% [xs, ys] = ginput(4);
% 
% imshow(warped_img)
% [xd, yd] = ginput(4);

% Choose 4 corresponding points (use ginput)
% src_pts_nx2  = [xs1 ys1; xs2 ys2; xs3 ys3; xs4 ys4];
% dest_pts_nx2 = [xd1 yd1; xd2 yd2; xd3 yd3; xd4 yd4];
% 
% src_pts_nx2 = [xs, ys];
% dest_pts_nx2 = [xd, yd];

A = zeros(2*length(dest_pts_nx2), 9);

for n = 1:length(dest_pts_nx2)
    row1 = [src_pts_nx2(n,:), 1, 0, 0, 0, -src_pts_nx2(n,1)*dest_pts_nx2(n,1), -dest_pts_nx2(n, 1)*src_pts_nx2(n,2), -dest_pts_nx2(n,1)];
    row2 = [0, 0, 0, src_pts_nx2(n,:), 1, -src_pts_nx2(n,1)*dest_pts_nx2(n,2), -dest_pts_nx2(n, 2)*src_pts_nx2(n,2), -dest_pts_nx2(n,2)];
    A(2*n-1, :) = row1;
    A(2*n, :)= row2;
end

[V,D] = eig(A'*A);

c = find(sum(D)==min(sum(D)));

h = V(:,c);

H_3x3 = reshape(h, 3, 3)';

end
