function [sp_GC_FT,dtm1,dtm2] =GFCC(speech_data,sr)
% [x1,fs] = audioread(filename);
%������ȡ
%VAD

speech_data=speech_data(:);
% sr =16000;  %�ز�����
%Ԥ����
y1=pre_emphasis(speech_data);
%֡��25ms��֡�ظ���10ms
frame_len = round(0.025*sr);
frame_ov = round(0.010*sr);
%��֡
frame_data = framing(y1,frame_len,frame_ov );
gammatone_n = 64;

y_AM=[];
GT_out =[];
GT_sum=[];
GT_AM = [];
C_DCT =[];
result = [];

for i = 1:length(frame_data(1,:))
    [y,f]=signal_fft(frame_data(:,i).*hanning(length(frame_data(:,i))),sr);  %�Ӵ�����fft
    y_AM = (y.*y)/length(y);
    [gtm,~] = fft2gammatonemx(length(f)*2,sr,gammatone_n,1,0,sr/2,length(f)); %����gammatone�˲�����
    for j = 1:gammatone_n
        GT_out(j,:) = y_AM'.*gtm(j,:); %����gammatone�˲�����
    end
    GT_sum = sum(GT_out'); %��ÿ���˲�����������������
    GT_AM = log10(GT_sum);  %�����
    C_DCT = dct(GT_AM);   %��DCT�任
    result(i,:) = C_DCT;
end
GFCC_n =13; %������ȡǰ30��
sp_GC_FT = result(:,1:GFCC_n);
%��ȡһ�ײ��ϵ��
dtm1 = [];
dtm1 = difference(sp_GC_FT,1);
%��ȡ���ײ��ϵ��
dtm2 = [];
dtm2 = difference(dtm1,1);
end