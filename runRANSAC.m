function [inliers_id, H] = runRANSAC(Xs, Xd, ransac_n, eps)

% ransac_n = 5;
% eps = 1;
% Xs = xs;
% Xd = xd;

for index=1:ransac_n
    random = randi([1, length(Xs)],1,10);
    sample_s = Xs(random,:);
    sample_d = Xd(random,:);
    H = computeHomography(sample_s, sample_d);
    test_d = applyHomography(H, Xs);
    dist = sqrt(sum((Xd-test_d).^2,2));
    outlier = length(find(dist>eps));
    inliers_id = (find(dist<eps));
    s(index).inid = inliers_id;
    s(index).H = H;
    s(index).outlier = outlier;
end

min_out = find([s.outlier]==min([s.outlier]));
H = s(min_out).H;
inliers_id = s(min_out).inid;

end
