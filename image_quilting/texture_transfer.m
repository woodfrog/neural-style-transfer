function [result] = texture_transfer(sample, image, patchsize, overlap, k, alpha)
%QUILT_SIMPLE
%   Detailed explanation goes here
result = double(zeros(size(image, 1), size(image, 2), 3));

patch_num_horizontal = int32(floor((size(image, 2)-overlap) / (patchsize-overlap)));
patch_num_vertical = int32(floor((size(image, 1)-overlap) / (patchsize-overlap)));

hsv_image = rgb2hsv(image);
image_luminance = imgaussfilt(hsv_image(:,:,3));

hsv_sample = rgb2hsv(sample);
sample_luminance = imgaussfilt(hsv_sample(:,:,3));


for i = 1:patch_num_vertical
    for j = 1:patch_num_horizontal
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
        template = result(start_y:start_y+patchsize-1,start_x:start_x+patchsize-1,:);
        luminance_template = image_luminance(start_y:start_y+patchsize-1,start_x:start_x+patchsize-1,:);

        ssd_map = ssd_map_transfer(template, luminance_template, sample, sample_luminance, y_bound, x_bound, alpha);
        [patch_sample] = choose_sample(sample, ssd_map, patchsize, k);
        
        mask = logical(ones(patchsize,patchsize));
        
        if  y_bound == 0 && x_bound == 0
            
        elseif y_bound == 0 && x_bound == overlap
            vertical_patch = sum((patch_sample(:,1:overlap,:) - template(:,1:overlap,:)).^2, 3);
            mask(:,1:overlap) = transpose(cut(transpose(vertical_patch)));
        elseif y_bound == overlap && x_bound == 0
            horizontal_patch = sum((patch_sample(1:overlap,:,:) - template(1:overlap,:,:)).^2, 3);
            mask(1:overlap,:) = cut(horizontal_patch);
        else
            horizontal_patch = sum((patch_sample(1:overlap,:,:) - template(1:overlap,:,:)).^2, 3);
            vertical_patch = sum((patch_sample(:,1:overlap,:) - template(:,1:overlap,:)).^2, 3);

            mask1 = logical(ones(patchsize, patchsize));
            mask1(1:overlap, :) = cut(horizontal_patch);

            mask2 = logical(ones(patchsize, patchsize));
            mask2(:,1:overlap) = transpose(cut(transpose(vertical_patch)));
            
            mask = mask1 & mask2;
        end
        
        mask = cat(3, mask, mask, mask);
                
        seamed_patch = double(~mask).*template + double(mask).*patch_sample;

        result(start_y:start_y+patchsize-1,start_x:start_x+patchsize-1,:) = seamed_patch;      
        imshow(result)
    end
end
end

