% Clear the workspace and console
clc; clear;

% 读取原始图像数据
fileID = fopen('face_8bit.raw', 'r');
im_raw = fread(fileID, [600 798], 'uint8');
fclose(fileID);

% 初始化RGB图像矩阵
im_rgb = zeros(200,266,3,'uint8');

%提取RGB通道
im_rgb(:,:,1) = im_raw(3:3:end,1:3:end);   %R 7-th
im_rgb(:,:,2) = im_raw(2:3:end,1:3:end);   %G 4-th
im_rgb(:,:,3) = im_raw(1:3:end,2:3:end);   %B 2-th


% 显示RGB图像
imshow(im_rgb);