function [image] = quilt_random(sample, outsize, patchsize)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
sample_size = size(sample);
sample_width = sample_size(2);
sample_height = sample_size(1);
upper_width = sample_width - patchsize + 1;
upper_height = sample_height - patchsize + 1;

patch_num = int32(floor(outsize / patchsize));

image = double(zeros(outsize, outsize, 3));

for i = 1:patch_num
    for j = 1:patch_num
        start_width = randi([1, upper_width], 1);
        start_height = randi([1, upper_height], 1);
        sample_patch = sample(start_height:start_height+patchsize-1, start_width:start_width+patchsize-1, :);
        image((i-1)*patchsize+1:i*patchsize, (j-1)*patchsize+1:j*patchsize,:) = sample_patch;       
    end
end

imshow(image);
end

