function [patch_sample] = choose_sample(sample,ssd_map,patchsize,k)
%CHOOSE_SAMPLE Summary of this function goes here
%   Detailed explanation goes here

% minc = min(ssd_map(:));
% 
% minc = max(minc,0.2);
% 
% [y, x] = find(ssd_map < minc+tol*minc, 10);

[min_values, indices] = mink(ssd_map(:), k);

rand_idx = randi([1 k],1);

x = floor( (indices(rand_idx)-1) / size(ssd_map, 1)) + 1;
y = indices(rand_idx) - (x-1) * size(ssd_map, 1);

patch_sample = sample(y:y+patchsize-1, x:x+patchsize-1, :);

end

