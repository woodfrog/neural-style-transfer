function [ssd_map] = ssd_patch(template,sample, y_bound, x_bound)
% apply the filter(the template) on the sample image, to get the ssd map output
%   Detailed explanation goes here

patch_size_tuple = size(template);
patchsize = patch_size_tuple(1);

sample_width = size(sample, 2);
sample_height = size(sample, 1);

ssd_map = zeros(sample_height - patchsize + 1, sample_width - patchsize + 1);

gray_template = rgb2gray(template);

for i = 1:sample_height - patchsize + 1
    for j = 1:sample_width - patchsize + 1
        patch = sample(i:i+patchsize-1, j:j+patchsize-1, :);
        patch(y_bound+1:patchsize, x_bound+1:patchsize, :) = 0;
        gray_patch = rgb2gray(patch);
        square_diff = (gray_patch - gray_template).^2;        
        ssd = sum(square_diff(:));
        ssd_map(i,j) = ssd;
    end
end

end

