function [mask, result_img] = backwardWarpImg(src_img, resultToSrc_H,...
    dest_canvas_width_height)

result_img = zeros(dest_canvas_width_height(2), dest_canvas_width_height(1), 3) - 1;

src_height = size(src_img, 1);
src_width = size(src_img, 2);
height = dest_canvas_width_height(1);
width = dest_canvas_width_height(2);
% count = 0;

for h = 1:height
    for w = 1:width
        coord = resultToSrc_H * [w; h; 1];
        coord = coord / coord(3);
        if round(coord(1)) > 0 && round(coord(1)) <= src_width && round(coord(2)) > 0 && round(coord(2)) <= src_height 
%             disp(round(coord(2)))
            result_img(h, w, :) = src_img(round(coord(2)), round(coord(1)), :);
%             count = count + 1;
%             disp(coord)
        end

    end
end
mask = sum(result_img, 3) >= 0;

result_img(result_img==-1)=0;
% disp(src_height*src_width)
% disp(count)




