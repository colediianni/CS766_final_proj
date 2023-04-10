function result_img = ...
    showCorrespondence(orig_img, warped_img, src_pts_nx2, dest_pts_nx2)


joinded_img = [orig_img, warped_img];
join_dest_pts = [dest_pts_nx2(:,1)+size(orig_img,2), dest_pts_nx2(:,2)];

f1 = figure();
imshow(joinded_img)
hold on
plot(src_pts_nx2(:,1), src_pts_nx2(:,2),'ro', 'MarkerFaceColor','r')
plot(join_dest_pts(:,1),join_dest_pts(:,2), 'ro','MarkerFaceColor','r');
for n=1:length(src_pts_nx2)
    line([src_pts_nx2(n,1), join_dest_pts(n,1)], [src_pts_nx2(n,2), join_dest_pts(n,2)], 'LineWidth', 2)
end

result_img = saveAnnotatedImg(f1);
end