function [image] = quilt_cut(sample, outsize, patchsize, overlap, k)
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
        
%         imshow(double(~mask).*template)
%         imshow(double(mask).*patch_sample);       
        
        image(start_y:start_y+patchsize-1,start_x:start_x+patchsize-1,:) = seamed_patch;
        imshow(image)
    end
end
end

