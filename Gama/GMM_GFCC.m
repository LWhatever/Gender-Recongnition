 
% finf = dir('D:\MATLAB\wav_m\*.wav');  %根据文件夹中的文件格式，选择读取类型，如.jpg、.mat等。
%                                                        %其中finf是一个结构体数组，包含的dataset下所有mat文件
%                                                       %的名称、修改时间大小、是否文件夹等属性。
% recObj = audiorecorder(16000, 16, 1);
% fprintf('Press any key to start %g seconds of recording...\n',4);
% pause;
% recordblocking(recObj, 4);
% fprintf('Finished recording.\n');
% play(recObj);
% d = getaudiodata(recObj);
% FS = 16000;
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% sound(d,FS);

% [FileName,PathName] = uigetfile('*.wav','Select the .wav file');
% if PathName == 0
%     errordlg('ERROR! No file selected!');
%     return;
% end  
abcd=[];
YM_m1=[];
Y_m1=[];
YM_m2=[];
Y_m2=[];
YM_m3=[];
Y_m3=[];
Y1_m=[];
Y2_m=[];
Y3_m=[];
Y1_m_En=[];
Y1_f_En=[];
Y1_m_Ch=[];
Y1_f_Ch=[];
YM_f1=[];
Y_f1=[];
YM_f2=[];
Y_f2=[];
YM_f3=[];
Y_f3=[];
Y1_f=[];
Y2_f=[];
Y3_f=[];
j_lg_geder_t=[];

flag=[];
load GMM_en_GFCC_64_1_48_0_8k.mat
load GMM_ch_GFCC_64_1_48_0_8k.mat
load filter_LP.mat
finf = dir('D:\MATLAB\CH_test_f\*.wav');  %根据文件夹中的文件格式，选择读取类型，如.jpg、.mat等。
                                                       %其中finf是一个结构体数组，包含的dataset下所有mat文件
n=length(finf)                                                      %的名称、修改时间大小、是否文件夹等属性。
 
for j=1:n
%     [x1,fs] = audioread('D:\MATLAB\CH_test_f\20170001P00060I0009.wav');
    filename = ['D:\MATLAB\CH_test_f\',finf(j).name];        %构造第k个文件的位置（合并文件路径和文件名）
    [X,fs] = audioread(filename);  
%     plot(x1);
    % wav_file=[PathName FileName];
    % [x1,fs]=audioread(wav_file);
   %重采样率设置
   SNR=0;
   [x1,NOISE] = noisegen(X,SNR);
    sr1=fs;
    [vs,zo] = vadsohn(x1,sr1);
    d_nozero = x1(1:length(vs));
    d_nozero(find(vs==0)) = [];
    signal=d_nozero;
%     signal=x1;
     %用于英文GMM
%     sr2=8000;  %用于中文GMM 
    %进行GFCC特征提取，英文GMM的数据是在采样率16000Hz下提取的，中文是在8000Hz下
%     [sp_GC_FT_3_En,dtm1_3_En,dtm2_3_En] =GFCC(x1,fs,sr1,filter_EN.b1,filter_EN.b2);
%     [sp_GC_FT_3_Ch,dtm1_3_Ch,dtm2_3_Ch] =GFCC(signal,fs,sr1);
       if length(signal)>0.025*16000
            [sp_GC_FT_3_Ch,dtm1_3_Ch,dtm2_3_Ch] =GFCC(signal,fs,sr1);
            if isempty(sp_GC_FT_3_Ch)
                continue
            end
       else
           flag=[flag,j]
       end
    if sum(sp_GC_FT_3_Ch)~=0

        %进行英文GMM模型比对
        [YM_m1_En,Y_m1_En]=lmultigauss(sp_GC_FT_3_Ch',GMM_English.mu_m1,GMM_English.sigm_m1,GMM_English.c_m1);
%         [YM_m2_En,Y_m2_En]=lmultigauss(dtm1_3_En',GMM_English.mu_m2,GMM_English.sigm_m2,GMM_English.c_m2);
%         [YM_m3_En,Y_m3_En]=lmultigauss(dtm2_3_En',GMM_English.mu_m3,GMM_English.sigm_m3,GMM_English.c_m3);
        Y1_m_En(j)=mean(Y_m1_En);
%         Y2_m_En=mean(Y_m2_En);
%         Y3_m_En=mean(Y_m3_En);
        [YM_f1_Ch,Y_f1_En]=lmultigauss(sp_GC_FT_3_Ch',GMM_English.mu_f1,GMM_English.sigm_f1,GMM_English.c_f1);
%         [YM_f2_En,Y_f2_En]=lmultigauss(dtm1_3_En',GMM_English.mu_f2,GMM_English.sigm_f2,GMM_English.c_f2);
%         [YM_f3_En,Y_f3_En]=lmultigauss(dtm2_3_En',GMM_English.mu_f3,GMM_English.sigm_f3,GMM_English.c_f3);
        Y1_f_En(j)=mean(Y_f1_En);
%         Y2_f_En=mean(Y_f2_En);
%         Y3_f_En=mean(Y_f3_En);

        %进行中文GMM模型比对
        [YM_m1_Ch,Y_m1_Ch]=lmultigauss(sp_GC_FT_3_Ch',GMM_chinese.mu_m1,GMM_chinese.sigm_m1,GMM_chinese.c_m1);
%         [YM_m2_Ch,Y_m2_Ch]=lmultigauss(dtm1_3_Ch',GMM_chinese.mu_m2,GMM_chinese.sigm_m2,GMM_chinese.c_m2);
%         [YM_m3_Ch,Y_m3_Ch]=lmultigauss(dtm2_3_Ch',GMM_chinese.mu_m3,GMM_chinese.sigm_m3,GMM_chinese.c_m3);
        Y1_m_Ch(j)=mean(Y_m1_Ch);
%         Y2_m_Ch=mean(Y_m2_Ch);
%         Y3_m_Ch=mean(Y_m3_Ch);
        [YM_f1_Ch,Y_f1_Ch]=lmultigauss(sp_GC_FT_3_Ch',GMM_chinese.mu_f1,GMM_chinese.sigm_f1,GMM_chinese.c_f1);
%         [YM_f2_Ch,Y_f2_Ch]=lmultigauss(dtm1_3_Ch',GMM_chinese.mu_f2,GMM_chinese.sigm_f2,GMM_chinese.c_f2);
%         [YM_f3_Ch,Y_f3_Ch]=lmultigauss(dtm2_3_Ch',GMM_chinese.mu_f3,GMM_chinese.sigm_f3,GMM_chinese.c_f3);
        Y1_f_Ch(j)=mean(Y_f1_Ch);
%         Y2_f_Ch=mean(Y_f2_Ch);
%         Y3_f_Ch=mean(Y_f3_Ch);


        %将比对结果按GFCC系数的结果以及它的一阶，二阶差分的结果分为三类
        judge(j)=Y1_m_Ch(j)>Y1_f_Ch(j);

    end
end
 sum(judge)   

