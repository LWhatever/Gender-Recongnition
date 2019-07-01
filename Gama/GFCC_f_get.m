% clc
% clear
% 
finf = dir('D:\MATLAB\EN_train_m\*.wav');  %根据文件夹中的文件格式，选择读取类型，如.jpg、.mat等。
%                                                        其中finf是一个结构体数组，包含的dataset下所有mat文件
%                                                       的名称、修改时间大小、是否文件夹等属性。
% finf = dir('D:\桌面\本科课程\语音信号处理\中文语音库\ch_data\female\*.wav');  %根据文件夹中的文件格式，选择读取类型，如.jpg、.mat等。
%                                                        %其中finf是一个结构体数组，包含的dataset下所有mat文件
%                                                       %的名称、修改时间大小、是否文件夹等属性。
names_sets = []; 
lables_sets = [];
dtm1_FT = [];
dtm2_FT = [];
sp_GC_FT_n = [];

n = length(finf);
for k=1:n    % 中文  male 2:22:n female 1:3:n  英文 301:n
%      filename = ['D:\MATLAB\wav_f\',finf(k).name];        %构造第k个文件的位置（合并文件路径和文件名）
     filename = ['D:\MATLAB\EN_train_m\',finf(k).name];        %构造第k个文件的位置（合并文件路径和文件名）
    [x1,fs] = audioread(filename);
    %特征提取
    %VAD[b,a]=tf(LowPass_fillter);
    x1=x1(:);
    sr =16000;  %重采样率
    x1=resample(x1,sr,fs);
    %静音检测
    [vs,zo] = vadsohn(x1,sr);
    d_nozero = x1(1:length(vs));
    d_nozero(find(vs==0)) = [];
    %滤波
    load filter_LP.mat
    x2=d_nozero;
%     x2=filter(filter_EN.b1,filter_EN.b2,x2);
    x2=filter(filter_EN.b1,filter_EN.b2,x2);
    %预加重
    y1=pre_emphasis(x2);
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
        [gtm,c] = fft2gammatonemx(length(f)*2,sr,gammatone_n,1,50,sr/2,length(f)); %生成gammatone滤波器组
        for j = 1:gammatone_n
            GT_out(j,:) = y_AM'.*gtm(j,:); %经过gammatone滤波器组
        end
        GT_sum = sum(GT_out'); %对每个滤波器组输出的数据求和
        GT_AM = log10(GT_sum);  %求对数
        C_DCT = dct(GT_AM);   %做DCT变换
        result(i,:) = C_DCT;
    end
    GFCC_n =20; %阶数，取前30阶
    sp_GC_FT = result(:,1:GFCC_n);
    %求取一阶差分系数
    dtm1 = [];
    dtm1 = difference(sp_GC_FT,1);
    %求取二阶差分系数
    dtm2 = [];
    dtm2 = difference(dtm1,1);


    %批量提取数据
     [~,col_num] = size(frame_data);
%      names =[];
%     names = repmat(finf(k).name,col_num,1);% 同一语音文件的不同帧用同一个文件名
    lables = zeros(col_num,1);          % 性别标签，0为女，1为男
%     names_sets = [names_sets; names];   % 同一类型特征发在同一个数组里
    lables_sets = [lables_sets; lables];% 每行为一段新的语音的特征
    dtm1_FT = [dtm1_FT; dtm1];
    dtm2_FT = [dtm2_FT; dtm2];
    sp_GC_FT_n = [sp_GC_FT_n; sp_GC_FT];
    datacolumns ={'GC1','GC2','GC3','GC4','GC5','GCC6',...
                             'GC7','GC8','GC9','GC10','GC11','GC12','GC13',...
                             'GC14','GC15','GC16','GC17','GC18','GC19','GC20',...
                             'GC_DT1_1','GC_DT1_2', 'GC_DT1_3','GC_DT1_4','GC_DT1_5','GC_DT1_6','GC_DT1_7',...
                             'GC_DT1_8','GC_DT1_9','GC_DT1_10','GC_DT1_11','GC_DT1_12',...
                             'GC_DT1_13',...
                             'GC_DT1_14','GC_DT1_15','GC_DT1_16','GC_DT1_17','GC_DT1_18','GC_DT1_19','GC_DT1_20',...
                             'GC_DT2_1','GC_DT2_2','GC_DT2_3','GC_DT2_4','GC_DT2_5',...
                             'GC_DT2_6','GC_DT2_7','GC_DT2_8','GC_DT2_9','GC_DT2_10',...
                             'GC_DT2_11','GC_DT2_12','GC_DT2_13','GC_DT2_14','GC_DT2_15','GC_DT2_16','GC_DT2_17','GC_DT2_18','GC_DT2_19','GC_DT2_20',...
                             'label'};
end

data_f = table(sp_GC_FT_n(:,1),sp_GC_FT_n(:,2),sp_GC_FT_n(:,3),sp_GC_FT_n(:,4),sp_GC_FT_n(:,5),sp_GC_FT_n(:,6),...
                        sp_GC_FT_n(:,7),sp_GC_FT_n(:,8),sp_GC_FT_n(:,9),sp_GC_FT_n(:,10),sp_GC_FT_n(:,11),sp_GC_FT_n(:,12),...
                        sp_GC_FT_n(:,13),...
                         sp_GC_FT_n(:,14),sp_GC_FT_n(:,15),sp_GC_FT_n(:,16),sp_GC_FT_n(:,17),sp_GC_FT_n(:,18),sp_GC_FT_n(:,19),sp_GC_FT_n(:,20),...
                        dtm1_FT(:,1),dtm1_FT(:,2),dtm1_FT(:,3),dtm1_FT(:,4),dtm1_FT(:,5),dtm1_FT(:,6),dtm1_FT(:,7),...
                        dtm1_FT(:,8),dtm1_FT(:,9),dtm1_FT(:,10),dtm1_FT(:,11),dtm1_FT(:,12),dtm1_FT(:,13),...
                        dtm1_FT(:,14),dtm1_FT(:,15),dtm1_FT(:,16),dtm1_FT(:,17),dtm1_FT(:,18),dtm1_FT(:,19),dtm1_FT(:,20),...
                        dtm2_FT(:,1),dtm2_FT(:,2),dtm2_FT(:,3),dtm2_FT(:,4),dtm2_FT(:,5),dtm2_FT(:,6),dtm2_FT(:,7),...
                        dtm2_FT(:,8),dtm2_FT(:,9),dtm2_FT(:,10),dtm2_FT(:,11),dtm2_FT(:,12),dtm2_FT(:,13),...
                        dtm2_FT(:,14),dtm2_FT(:,15),dtm2_FT(:,16),dtm2_FT(:,17),dtm2_FT(:,18),dtm2_FT(:,19),dtm2_FT(:,20),...
    lables_sets,'VariableNames',datacolumns);
%将数据写入csv文件中
writetable(data_f,'GC_m_EN_20.csv');


