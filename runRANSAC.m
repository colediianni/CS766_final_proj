function [inliers_id, H] = runRANSAC(Xs, Xd, ransac_n, eps)

best_num_inliers = 0;
H = 0;
inliers_id = 0;
% disp(size(Xs))

for i = 1:ransac_n

    xsize = size(Xs, 1);
    idx = randperm(xsize);
%     disp(idx)
    four_rand_source_points = Xs(idx(1:4), :);
%     disp(four_rand_source_points)
    four_rand_dest_points = Xd(idx(1:4), :);
    H_3x3 = computeHomography(four_rand_source_points, four_rand_dest_points);
%     disp(H_3x3)

    calculated_dest_points = applyHomography(H_3x3, Xs);
    distances = (calculated_dest_points - Xd).^2;
    distances = sqrt(sum(distances, 2));
%     disp(distances)
    num_in_eps = sum(distances <= eps);
    if num_in_eps > best_num_inliers
        best_num_inliers = num_in_eps;
        H = H_3x3;
        inliers_id = distances <= eps;
    end

end

