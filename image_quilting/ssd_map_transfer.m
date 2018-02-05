function [ssd_map] = ssd_map_transfer(template, luminance_template, sample, luminance_sample, y_bound, x_bound, alpha)
% apply the filter(the template) on the sample image, to get the ssd map output
%   Detailed explanation goes here

patch_size_tuple = size(template);
patchsize = patch_size_tuple(1);

sample_size = size(sample);
sample_width = sample_size(2);
sample_height = sample_size(1);

ssd_map = double(zeros(sample_height - patchsize + 1, sample_width - patchsize + 1));

% samplesize * samplesizez * patchsize * patchsize
for i = 1:sample_height - patchsize + 1
    for j = 1:sample_width - patchsize + 1
        patch = sample(i:i+patchsize-1, j:j+patchsize-1, :);
        patch(y_bound+1:patchsize, x_bound+1:patchsize, :) = 0;
        patch_luminance = luminance_sample(i:i+patchsize-1, j:j+patchsize-1);
        
        square_diff = (patch - template).^2;
        square_correspondence_diff = (patch_luminance - luminance_template).^2;
        ssd_texture = sum(square_diff(:));
        ssd_correspondence = sum(square_correspondence_diff(:));
        ssd = alpha * ssd_texture + (1 - alpha) * ssd_correspondence;
        ssd_map(i,j) = ssd;
    end
end

end

