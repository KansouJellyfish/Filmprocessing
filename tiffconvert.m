clc;clear;close all;
% 1. 调用 dcraw 读取 .ARW 并转换为 16-bit TIFF
filepath = 'E:\图片\2025\2025-02-27\';
filename = 'DSC0%04d.ARW';
outputfile = 'DSC0%04d.tiff'
for i=6995:7022
    raw_filename = fullfile(filepath,sprintf(filename,i))
    % 使用 dcraw 转换 RAW 为 16 位 TIFF
    system(['dcraw -4 -v -w -T "', raw_filename, '"']);
end
