clc;clear;
% 调用 dcraw 读取 .ARW 并转换为 16-bit TIFF
filepath='.\RAW\'; % RAW文件路径
filename='DSC0%04d.ARW'; % 文件名，此处为索尼相机命名规范，此处使用%04d以方便批量处理
outputfile='DSC0%04d.tiff';
for i=0001:0004
    raw_filename=fullfile(filepath,sprintf(filename,i));
    % 使用 dcraw 转换 RAW 为 16 位 TIFF
    system(['dcraw -4 -v -w -T "', raw_filename, '"']); % -4代表输出线性文件，-v表示显示信息，-w代表使用相机白平衡，-T代表输出16 bit tiff
end
