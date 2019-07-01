

[FileName,PathName] = uigetfile('*.wav','Select the .wav file');
if PathName == 0
    errordlg('ERROR! No file selected!');
    return;
end  
% YM_m1=[];
% Y_m1=[];
% YM_m2=[];
% Y_m2=[];
% YM_m3=[];
% Y_m3=[];
% Y1_m=[];
% Y2_m=[];
% Y3_m=[];
% 
% YM_f1=[];
% Y_f1=[];
% YM_f2=[];
% Y_f2=[];
% YM_f3=[];
% Y_f3=[];
% Y1_f=[];
% Y2_f=[];
% Y3_f=[];
load GMM_MFCC_en.mat  %加载英文的两个GMM模型
load GMM_MFCC_ch.mat  %加载中文的两个GMM模型
load filter_EN.mat    %加载一个截至频率为7600Hz的滤波器，8000Hz时衰减40dB
load filter_Ch.mat    %加载一个截至频率为3800Hz的滤波器，4000Hz时衰减40dB

wav_file=[PathName FileName];
[x1,fs]=audioread(wav_file);
%重采样率设置
sr1=16000; %用于中文GMM
sr2=8000;  %用于英文GMM 
%进行GFCC特征提取，英文GMM的数据是在采样率16000Hz下提取的，中文是在8000Hz下
% [sp_GC_FT_3_En,dtm1_3_En,dtm2_3_En] =GFCC(x1,fs,sr1,filter_EN.b1,filter_EN.b2);
% [sp_GC_FT_3_Ch,dtm1_3_Ch,dtm2_3_Ch] =GFCC(x1,fs,sr2,filter_Ch.b1,filter_Ch.b2);

Tw = 25;           % analysis frame duration (ms)
Ts = 10;           % analysis frame shift (ms)
alpha = 0.97;      % preemphasis coefficient
R = [ 300 3700 ];  % frequency range to consider
M = 20;            % number of filterbank channels 
C = 13;            % number of cepstral coefficients
L = 22;            % cepstral sine lifter parameter
[vs,zo] = vadsohn(x1,fs);
d_nozero = x1(1:length(vs));
d_nozero(find(vs==0)) = [];
hamming = @(N)(0.54-0.46*cos(2*pi*[0:N-1].'/(N-1)));
if length(d_nozero)>0.025*8000
    [ MFCCs, FBEs, frames ] =  mfcc( d_nozero, sr1, Tw, Ts, alpha, hamming, R, M, C, L );
     if isempty(MFCCs)
        errordlg('ERROR! This recoed can not be tested');
     else
         %进行英文GMM模型比对
        [~,Y_m1_En]=lmultigauss(MFCCs,GMM_English.mu_m1,GMM_English.sigm_m1,GMM_English.c_m1);
        Y1_m_En=mean(Y_m1_En);
        [~,Y_f1_En]=lmultigauss(MFCCs,GMM_English.mu_f1,GMM_English.sigm_f1,GMM_English.c_f1);
        Y1_f_En=mean(Y_f1_En);
        %进行中文GMM模型比对
        [~,Y_m1_Ch]=lmultigauss(MFCCs,GMM_chinese.mu_m1,GMM_chinese.sigm_m1,GMM_chinese.c_m1);
        Y1_m_Ch=mean(Y_m1_Ch);
        [~,Y_f1_Ch]=lmultigauss(MFCCs,GMM_chinese.mu_f1,GMM_chinese.sigm_f1,GMM_chinese.c_f1);
        Y1_f_Ch=mean(Y_f1_Ch);
        %将比对结果按GFCC系数的结果以及它的一阶，二阶差分的结果分为三类
        Y1_all=[Y1_m_En;Y1_m_Ch;Y1_f_En ;Y1_f_Ch];
        %将结果按中英文GMM模型分为两类
        lg_En_all=[Y1_m_En;Y1_f_En];
        lg_Ch_all=[Y1_m_Ch;Y1_f_Ch];
        %将结果按性别GMM模型分为两类
        gender_m_all=[Y1_m_En;Y1_m_Ch];
        gender_f_all=[Y1_f_En;Y1_f_Ch];

        %求取GFCC，一阶GFCC，二阶GFCC得出结果的最大值
        j1=max(Y1_all);
        %将上面最大值放在一个矩阵里
        j_all=j1;
        lg=0;
        gender=0;

        %用j_all的数据跟lg_En_all和gender_m_all匹配
        % lg表示在英文库匹配到的数量，gender表示在man库匹配到的数量
        for i=1:1
            for j=1:2
                if j_all==lg_En_all(j,1)
                    lg= lg+1;
                end
                if j_all==gender_m_all(j,1)
                   gender=gender+1;
                end
            end
        end

        %进行性别和语种区分
        %lg大于等于2表示说话人说的是英语（注：个人感觉不确定，也有可能是地域影响）
        %lg小于2表示说话人说的是中文
        %gender>=2表示说话人是boy
        %gender<2表示说话人是girl
        if lg==1
            if gender ==1
                j_lg_geder=3 %英文boy
            else
                j_lg_geder=2 %英文girl
            end
        else
            if  gender ==1
                j_lg_geder=1 %中文boy  
            else
                j_lg_geder=0 %中文girl
            end
        end
         %j_lg_geder的值映射关系
         %   0        1      2        3
         %中文girl 中文boy 英文boy 英文girl
    end
end





