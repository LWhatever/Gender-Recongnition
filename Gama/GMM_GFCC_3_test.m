 
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
load GMM_ch_GFCC_20_3_64_0.mat
load GMM_en_20_3.mat
finf = dir('D:\MATLAB\CH_test_m\*.wav');  %根据文件夹中的文件格式，选择读取类型，如.jpg、.mat等。
                                                       %其中finf是一个结构体数组，包含的dataset下所有mat文件
n=length(finf)                                                      %的名称、修改时间大小、是否文件夹等属性。
 
for j=1:n
%     [x1,fs] = audioread('D:\MATLAB\CH_test_f\20170001P00060I0009.wav');
    filename = ['D:\MATLAB\CH_test_m\',finf(j).name];        %构造第k个文件的位置（合并文件路径和文件名）
    [X,fs] = audioread(filename);    
    % wav_file=[PathName FileName];
    % [x1,fs]=audioread(wav_file);
   %重采样率设置
   SNR=0;
   [x1,NOISE] = noisegen(X,SNR);
    sr1=16000; %用于英文GMM
x1=x1(:);
[vs,zo] = vadsohn(x1,fs);
d_nozero = x1(1:length(vs));
d_nozero(find(vs==0)) = [];
   if length(d_nozero)>0.025*16000
        [sp_GC_FT_3_Ch,dtm1_3_Ch,dtm2_3_Ch] =GFCC(d_nozero,fs,sr1);
        if isempty(sp_GC_FT_3_Ch)
            continue
        end
   end
    sp_GC_FT=[sp_GC_FT_3_Ch,dtm1_3_Ch,dtm2_3_Ch];
    if sum(sp_GC_FT)~=0

        %进行英文GMM模型比对
        [YM_m1_En,Y_m1_En]=lmultigauss(sp_GC_FT',GMM_English.mu_m1,GMM_English.sigm_m1,GMM_English.c_m1);
%         [YM_m2_En,Y_m2_En]=lmultigauss(dtm1_3_En',GMM_English.mu_m2,GMM_English.sigm_m2,GMM_English.c_m2);
%         [YM_m3_En,Y_m3_En]=lmultigauss(dtm2_3_En',GMM_English.mu_m3,GMM_English.sigm_m3,GMM_English.c_m3);
        Y1_m_En(j)=mean(Y_m1_En);
%         Y2_m_En=mean(Y_m2_En);
%         Y3_m_En=mean(Y_m3_En);
        [YM_f1_Ch,Y_f1_En]=lmultigauss(sp_GC_FT',GMM_English.mu_f1,GMM_English.sigm_f1,GMM_English.c_f1);
%         [YM_f2_En,Y_f2_En]=lmultigauss(dtm1_3_En',GMM_English.mu_f2,GMM_English.sigm_f2,GMM_English.c_f2);
%         [YM_f3_En,Y_f3_En]=lmultigauss(dtm2_3_En',GMM_English.mu_f3,GMM_English.sigm_f3,GMM_English.c_f3);
        Y1_f_En(j)=mean(Y_f1_En);
%         Y2_f_En=mean(Y_f2_En);
%         Y3_f_En=mean(Y_f3_En);

        %进行中文GMM模型比对
        [YM_m1_Ch,Y_m1_Ch]=lmultigauss(sp_GC_FT',GMM_chinese.mu_m1,GMM_chinese.sigm_m1,GMM_chinese.c_m1);
%         [YM_m2_Ch,Y_m2_Ch]=lmultigauss(dtm1_3_Ch',GMM_chinese.mu_m2,GMM_chinese.sigm_m2,GMM_chinese.c_m2);
%         [YM_m3_Ch,Y_m3_Ch]=lmultigauss(dtm2_3_Ch',GMM_chinese.mu_m3,GMM_chinese.sigm_m3,GMM_chinese.c_m3);
        Y1_m_Ch(j)=mean(Y_m1_Ch);
%         Y2_m_Ch=mean(Y_m2_Ch);
%         Y3_m_Ch=mean(Y_m3_Ch);
        [YM_f1_Ch,Y_f1_Ch]=lmultigauss(sp_GC_FT',GMM_chinese.mu_f1,GMM_chinese.sigm_f1,GMM_chinese.c_f1);
%         [YM_f2_Ch,Y_f2_Ch]=lmultigauss(dtm1_3_Ch',GMM_chinese.mu_f2,GMM_chinese.sigm_f2,GMM_chinese.c_f2);
%         [YM_f3_Ch,Y_f3_Ch]=lmultigauss(dtm2_3_Ch',GMM_chinese.mu_f3,GMM_chinese.sigm_f3,GMM_chinese.c_f3);
        Y1_f_Ch(j)=mean(Y_f1_Ch);
%         Y2_f_Ch=mean(Y_f2_Ch);
%         Y3_f_Ch=mean(Y_f3_Ch);


        %将比对结果按GFCC系数的结果以及它的一阶，二阶差分的结果分为三类
%         Y1_all=[Y1_m_En;Y1_m_Ch;Y1_f_En ;Y1_f_Ch];
%         Y2_all=[Y2_m_En;Y2_m_Ch;Y2_f_En ;Y2_f_Ch];
%         Y3_all=[Y3_m_En;Y3_m_Ch;Y3_f_En ;Y3_f_Ch];
        judge(j)=Y1_m_Ch(j)>Y1_f_Ch(j);
        %将结果按中英文GMM模型分为两类
%         lg_En_all=[Y1_m_En;Y2_m_En;Y3_m_En;Y1_f_En;Y2_f_En;Y3_f_En];
%         lg_Ch_all=[Y1_m_Ch;Y2_m_Ch;Y3_m_Ch;Y1_f_Ch;Y2_f_En;Y3_f_Ch];
%         %将结果按性别GMM模型分为两类
%         gender_m_all=[Y1_m_En;Y1_m_Ch;Y2_m_En;Y2_m_Ch;Y3_m_En;Y3_m_Ch];
%         gender_f_all=[Y1_f_En;Y1_f_Ch;Y2_f_En;Y2_f_Ch;Y3_f_En;Y3_f_Ch];
% 
%         %求取GFCC，一阶GFCC，二阶GFCC得出结果的最大值
%         j1=max(Y1_all);
%         j2=max(Y2_all);
%         j3=max(Y3_all);
%         %将上面最大值放在一个矩阵里
%         j_all=[j1;j2;j3];
%         lg=0;
%         gender=0;
% 
%         %用j_all的数据跟lg_En_all和gender_m_all匹配
%         % lg表示在英文库匹配到的数量，gender表示在man库匹配到的数量
%         for i=1:3
%             for m=1:6
%                 if j_all(i,1)==lg_En_all(m,1)
%                     lg= lg+1;
%                 end
%                 if j_all(i,1)==gender_m_all(m,1)
%                    gender=gender+1;
%                 end
%             end
%         end
% 
%     %进行性别和语种区分
%     %lg大于等于2表示说话人说的是英语（注：个人感觉不确定，也有可能是地域影响）
%     %lg小于2表示说话人说的是中文
%     %gender>=2表示说话人是boy
%     %gender<2表示说话人是girl
%     if lg>=2
%         if gender >=2
%             j_lg_geder=3; %英文boy
%         else
%             j_lg_geder=2;%英文girl
%         end
%     else
%         if Y1_m_Ch>Y1_f_Ch
%             j_lg_geder=1;%中文boy  
%         elseif Y2_m_Ch>Y2_f_Ch && Y3_m_Ch>Y3_f_Ch
%             j_lg_geder=1;%中文girl
%         else
%             j_lg_geder=0;%中文boy
%         end
%     end
%      %j_lg_geder的值映射关系
%      %   0        1      3        2
%      %中文girl 中文boy 英文boy 英文girl
%         j_lg_geder_t=[j_lg_geder_t,j_lg_geder];
    end
end
% M_get=sum(abcd)
% M=M_get/390
M=sum(Y1_m_Ch>Y1_f_Ch)

