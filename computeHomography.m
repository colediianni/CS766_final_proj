function H_3x3 = computeHomography(src_pts_nx2, dest_pts_nx2)

A = zeros(8, 9);

% disp(src_pts_nx2)
% disp(A(1, :))

for i = 1:4
    A(2*i - 1, :) = [src_pts_nx2(i, 1), src_pts_nx2(i, 2), 1, 0, 0, 0, -1*src_pts_nx2(i, 1)*dest_pts_nx2(i, 1), -1*src_pts_nx2(i, 2)*dest_pts_nx2(i, 1), -1*dest_pts_nx2(i, 1)];
    A(2*i, :) = [0, 0, 0, src_pts_nx2(i, 1), src_pts_nx2(i, 2), 1, -1*src_pts_nx2(i, 1)*dest_pts_nx2(i, 2), -1*src_pts_nx2(i, 2)*dest_pts_nx2(i, 2), -1*dest_pts_nx2(i, 2)];
end
% disp(A)

[V,D] = eig(A' * A);
% disp(D)
% disp(V)
% disp(V(:, 1))
% disp(D(1, 1))
H_3x3 = transpose(reshape(V(:, 1), 3, 3));
% disp(H_3x3)

% disp(A * reshape(V(1, :), 9, 1))