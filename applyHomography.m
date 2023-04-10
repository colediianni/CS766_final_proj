function dest_pts_nx2 = applyHomography(H_3x3, src_pts_nx2)

% disp(size(src_pts_nx2))
NewCol = ones(size(src_pts_nx2, 1),1);
% disp(size(NewCol))
%Add new column
points = [src_pts_nx2 NewCol];
% disp(size(points))
% disp(points)

dest_pts = transpose(H_3x3 * transpose(points));

% disp(size(dest_pts))
% disp(dest_pts)

dest_pts = dest_pts ./ dest_pts(:, 3);

% disp(size(dest_pts))
% disp(dest_pts)

dest_pts_nx2 = dest_pts(:, 1:2);