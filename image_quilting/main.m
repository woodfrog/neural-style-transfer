% stone = imread('samples/stones.jpg');
% stone = im2double(stone);

% white = imread('samples/white_small.jpg');
% white = im2double(white);
 
% bricks = imread('samples/bricks_small.jpg');
% bricks = im2double(bricks);

% wall = imread('samples/broken_wall.png');
% wall = im2double(wall);

% result = quilt_simple(stone, 400, 49, 16, 0.1);

% result = quilt_random(bricks, 400, 40);
% result = quilt_simple(bricks, 400, 40, 12, 10);
% result = quilt_cut(wall, 400, 40, 12, 10);

texture = imread('samples/paper.png');
texture = im2double(texture);
image = imread('samples/me2.png');
image = imresize(image, 0.5);
image = im2double(image);

tansfered = texture_transfer(texture, image, 30, 8, 10, 0.3);

