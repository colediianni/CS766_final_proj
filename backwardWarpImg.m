function [mask, result_img] = backwardWarpImg(src_img, resultToSrc_H,...
    dest_canvas_width_height)

out_img = zeros(dest_canvas_width_height(2), dest_canvas_width_height(1), 3);
mask = zeros(dest_canvas_width_height(2), dest_canvas_width_height(1),1);
for n=1:dest_canvas_width_height(2)
    for m = 1:dest_canvas_width_height(1)
        dest_point = resultToSrc_H*[m; n; 1];
        dest_point_r = round(dest_point(1:2)/dest_point(3));
        if dest_point_r(1)>=1 && dest_point_r(1)<=size(src_img,2)&& dest_point_r(2)>=1 && dest_point_r(2)<=size(src_img,1)
            out_img(n, m,:) = src_img(dest_point_r(2), dest_point_r(1),:);
            mask(n,m,:) = 1;
        else

        end
    end
end

result_img = out_img;

end