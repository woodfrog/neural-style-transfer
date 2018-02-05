function [image] = quilt_simple(sample, outsize, patchsize, overlap, k)
%QUILT_SIMPLE
%   Detailed explanation goes here
image = double(zeros(outsize, outsize, 3));
patch_num = int32(floor((outsize-overlap) / (patchsize-overlap)));

for i = 1:patch_num
    for j = 1:patch_num
        % decide the start in x and y axis
        if i == 1 && j == 1
            start_y = 1;
            start_x = 1;
            y_bound = 0;
            x_bound = 0;
        elseif i == 1
            start_y = 1;
            start_x = (j-1)*(patchsize-overlap)+1;
            y_bound = 0;
            x_bound = overlap;
        elseif j == 1
            start_y = (i-1)*(patchsize-overlap)+1;
            start_x = 1;
            y_bound = overlap;
            x_bound = 0;
        else
            start_y = (i-1)*(patchsize-overlap)+1;
            start_x = (j-1)*(patchsize-overlap)+1;
            y_bound = overlap;
            x_bound = overlap;
        end
        template = image(start_y:start_y+patchsize-1,start_x:start_x+patchsize-1,:);
        ssd_map = ssd_patch(template, sample, y_bound, x_bound);
        patch_sample = choose_sample(sample, ssd_map, patchsize, k);
%         subplot(1,2,1); imshow(patch_sample);
%         subplot(1,2,2); imshow(template);
%         size(image(start_y:start_y+patchsize-1,start_x:start_x+patchsize-1,:))
%         size(patch_sample)
        image(start_y:start_y+patchsize-1,start_x:start_x+patchsize-1,:) = patch_sample;      
        imshow(image)
    end
end

end

