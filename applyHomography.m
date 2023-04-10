function dest_pts_nx2 = applyHomography(H_3x3, src_pts_nx2)

dest_pts_nx2_temp = zeros(size(src_pts_nx2));

for n=1:length(src_pts_nx2)
    dest_n = H_3x3*[src_pts_nx2(n,:)';1];
    dest_pts_nx2_temp(n, :) = dest_n(1:2)'/dest_n(3);
end

dest_pts_nx2 = dest_pts_nx2_temp;

end