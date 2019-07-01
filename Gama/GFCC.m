function [sp_GC_FT,dtm1,dtm2] =GFCC(speech_data,sr)
% [x1,fs] = audioread(filename);
%特征提取
%VAD

speech_data=speech_data(:);
% sr =16000;  %重采样率
%预加重
y1=pre_emphasis(speech_data);
%帧长25ms，帧重复率10ms
frame_len = round(0.025*sr);
frame_ov = round(0.010*sr);
%分帧
frame_data = framing(y1,frame_len,frame_ov );
gammatone_n = 64;

y_AM=[];
GT_out =[];
GT_sum=[];
GT_AM = [];
C_DCT =[];
result = [];

for i = 1:length(frame_data(1,:))
    [y,f]=signal_fft(frame_data(:,i).*hanning(length(frame_data(:,i))),sr);  %加窗和做fft
    y_AM = (y.*y)/length(y);
    [gtm,~] = fft2gammatonemx(length(f)*2,sr,gammatone_n,1,0,sr/2,length(f)); %生成gammatone滤波器组
    for j = 1:gammatone_n
        GT_out(j,:) = y_AM'.*gtm(j,:); %经过gammatone滤波器组
    end
    GT_sum = sum(GT_out'); %对每个滤波器组输出的数据求和
    GT_AM = log10(GT_sum);  %求对数
    C_DCT = dct(GT_AM);   %做DCT变换
    result(i,:) = C_DCT;
end
GFCC_n =13; %阶数，取前30阶
sp_GC_FT = result(:,1:GFCC_n);
%求取一阶差分系数
dtm1 = [];
dtm1 = difference(sp_GC_FT,1);
%求取二阶差分系数
dtm2 = [];
dtm2 = difference(dtm1,1);
end