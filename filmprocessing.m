clc;clear;close all;
% 导入，计算黑点、白点
filepath='E:\图片\filmprocessing\RAW\';
filename='DSC0%04d.tiff';
outputfile='DSC0%04d.tiff';
chara=readtable('.\characteristicCurves\fujipremium400');
Rb=im2double(imread(fullfile(filepath,'black.tiff'))); % 黑点（数码底）
Rw=im2double(imread(fullfile(filepath,'white.tiff'))); % 白点（数码底）
R0=im2double(imread(fullfile(filepath,'flat.tiff'))); % EV=0
Rbavg=squeeze(mean(Rb,[1 2])); % 求平均，沿第一维和第二维计算均值，去掉大小为1的维度，使结果变成1*3
Rwavg=squeeze(mean(Rw,[1 2]));
R0avg=squeeze(mean(R0,[1 2]));
mkdir(filepath,'converted');

% 开始逐张处理图像
for n=0001:0004
    R=im2double(imread(fullfile(filepath,sprintf(filename,n)))); % 待处理图像
    for i=1:3 % RGB三个通道分别处理
        % 计算透过率T
        T(:,:,i)=(R(:,:,i)-Rbavg(i))/(Rwavg(i)-Rbavg(i));
        T=min(max(T,0),1);
        
        % 根据比尔-朗博定律，将通光率转换为吸光度A
        A(:,:,i)=-log10(T(:,:,i));

        % logH=-1.5代表18%灰卡在正常曝光下的值，令k=该点对应的密度D0/吸光度A0，使吸光度与密度可以换算
        T0(i)=(R0avg(i)-Rbavg(i))/(Rwavg(i)-Rbavg(i)); % 计算标准曝光的透过率
        A0(i)=-log10(T0(i));
        x=chara{:,(i-1)*2+1};% 特性曲线
        y=chara{:,i*2};
        validIdx = isfinite(x) & isfinite(y); % 删除NaN
        x = x(validIdx);
        y = y(validIdx);
        D0(i)=interp1(x,y,-1.3,'linear'); % 插值得到正常曝光时的密度D值
        k(i)=D0(i)/A0(i);
   
        % 得到密度D
        D(:,:,i)=A(:,:,i)*k(i);
        
        %查找特性曲线得到曝光度
        H(:,:,i)=interp1(y,x,D(:,:,i),'linear','extrap');
    end
    
    % 以胶卷的黑点、白点值进行归一化
    Hb=-3;
    Hw=0;
    H=(H-Hb)/(Hw-Hb);
    H=max(H,0);
    H=min(H,1);

% % 绘制直方图用    
%     % 分离 R、G、B 通道
%     RR = R(:,:,1);
%     RG = R(:,:,2);
%     RB = R(:,:,3);
%     % 绘制直方图
%     figure;hold on;
%     histogram(RR(:), 256, 'FaceColor', 'r', 'EdgeColor', 'none'); % 红色通道
%     histogram(RG(:), 256, 'FaceColor', 'g', 'EdgeColor', 'none'); % 绿色通道
%     histogram(RB(:), 256, 'FaceColor', 'b', 'EdgeColor', 'none'); % 蓝色通道
%     hold off;

    % 输出转换为log的图像
    outputname='R-DSC0%04d.tiff';
    imwrite(H, fullfile(filepath,'converted',sprintf(outputname,n)));
    fprintf(outputname,n);fprintf(' done\n');
end
