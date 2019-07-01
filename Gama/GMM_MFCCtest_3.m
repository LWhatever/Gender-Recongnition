
load GMM_en_MFCC_20_3.mat  %����Ӣ�ĵ�����GMMģ��
load GMM_ch_MFCC_20_3.mat  %�������ĵ�����GMMģ��
load filter_LP.mat 
finf = dir('D:\MATLAB\CH_test_m\*.wav');  %�����ļ����е��ļ���ʽ��ѡ���ȡ���ͣ���.jpg��.mat�ȡ�
                                                       %����finf��һ���ṹ�����飬������dataset������mat�ļ�
                                                      %�����ơ��޸�ʱ���С���Ƿ��ļ��е����ԡ�
n = length(finf);


YM_m1=[];
Y_m1=[];
YM_m2=[];
Y_m2=[];
YM_m3=[];
Y_m3=[];
Y1_m=[];
Y2_m=[];
Y3_m=[];

YM_f1=[];
Y_f1=[];
YM_f2=[];
Y_f2=[];
YM_f3=[];
Y_f3=[];
Y1_f=[];
Y2_f=[];
Y3_f=[];
MFCC_data_f=[];
MFCC_data_m=[];
for j=1:n
%     [x3,fs] = audioread('arctic_a0005.wav');
    filename = ['D:\MATLAB\CH_test_m\',finf(j).name];        %�����k���ļ���λ�ã��ϲ��ļ�·�����ļ�����
    [x1,fs] = audioread(filename);
     SNR=0;
    [Y,NOISE] = noisegen(x1,SNR);
    %�ز���������
    sr1=fs; 
    %����GFCC������ȡ��Ӣ��GMM���������ڲ�����16000Hz����ȡ�ģ���������8000Hz��
%     Tw = 25;           % analysis frame duration (ms)
%     Ts = 10;           % analysis frame shift (ms)
%     alpha = 0.97;      % preemphasis coefficient
%     R = [ 300 3700 ];  % frequency range to consider
    maxfreq = 8000;      % frequency range to consider
    M = 20;            % number of filterbank channels 
%     C = 13;            % number of cepstral coefficients
%     L = 22;            % cepstral sine lifter parameter
% 	Y=filter(filter_EN.b1,filter_EN.b2,Y);
    [vs,zo] = vadsohn(Y,fs);
    d_nozero = Y(1:length(vs));
    d_nozero(find(vs==0)) = [];
%     hamming = @(N)(0.54-0.46*cos(2*pi*[0:N-1].'/(N-1)));
   if length(d_nozero)>0.025*16000
        [ MFCCs, ~, ~ ] =  melfcc( d_nozero, sr1,'lifterexp', -22,'nbands', M,'maxfreq', maxfreq, 'sumpower', 0,'fbtype', 'htkmel','dcttype', 3);
         if isempty(MFCCs)
            continue
         end
    
%     [ MFCCs, FBEs, frames ] =  mfcc( d_nozero, sr1, Tw, Ts, alpha, hamming, R, M, C, L );
%     MFCC_data_f=[MFCC_data_f,MFCCs];
    MFCC_d = deltas(MFCCs);
    MFCC_dd = deltas(deltas(MFCCs,5),5);
    MFCCDpDD = [MFCCs',MFCC_d',MFCC_dd'];
   end
%          MFCC_data_m=[MFCC_data_m,MFCCs];
%    end
   
%     %����Ӣ��GMMģ�ͱȶ�
    [YM_m1_En,Y_m1_En]=lmultigauss(MFCCDpDD',GMM_English.mu_m1,GMM_English.sigm_m1,GMM_English.c_m1);
    Y1_m_En(j)=mean(Y_m1_En);
    [YM_f1_Ch,Y_f1_En]=lmultigauss(MFCCDpDD',GMM_English.mu_f1,GMM_English.sigm_f1,GMM_English.c_f1);
    Y1_f_En(j)=mean(Y_f1_En);
%     %��������GMMģ�ͱȶ�
    [YM_m1_Ch,Y_m1_Ch]=lmultigauss(MFCCDpDD',GMM_chinese.mu_m1,GMM_chinese.sigm_m1,GMM_chinese.c_m1);
    Y1_m_Ch(j)=mean(Y_m1_Ch);
    [YM_f1_Ch,Y_f1_Ch]=lmultigauss(MFCCDpDD',GMM_chinese.mu_f1,GMM_chinese.sigm_f1,GMM_chinese.c_f1);
    Y1_f_Ch(j)=mean(Y_f1_Ch);
end
j_a=Y1_m_En>Y1_f_En;
j_b=Y1_m_Ch>Y1_f_Ch;
m_En=sum(j_a)
m_Ch=sum(j_b)



