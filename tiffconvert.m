clc;clear;close all;
% 1. 调用 dcraw 读取 .ARW 并转换为 16-bit TIFF
filepath='C:\example\'; % RAW格式文件路径
filename='DSC0%04d.ARW';
outputfile='DSC0%04d.tiff'
for i=1111:2222
    raw_filename = fullfile(filepath,sprintf(filename,i))
    % 使用 dcraw 转换 RAW 为 16 位 TIFF
    system(['dcraw -4 -v -w -T "', raw_filename, '"']); % -w表示使用相机拍摄时白平衡，-T表示以16位tiff输出
end
