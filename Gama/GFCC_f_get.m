% clc
% clear
% 
finf = dir('D:\MATLAB\EN_train_m\*.wav');  %�����ļ����е��ļ���ʽ��ѡ���ȡ���ͣ���.jpg��.mat�ȡ�
%                                                        ����finf��һ���ṹ�����飬������dataset������mat�ļ�
%                                                       �����ơ��޸�ʱ���С���Ƿ��ļ��е����ԡ�
% finf = dir('D:\����\���ƿγ�\�����źŴ���\����������\ch_data\female\*.wav');  %�����ļ����е��ļ���ʽ��ѡ���ȡ���ͣ���.jpg��.mat�ȡ�
%                                                        %����finf��һ���ṹ�����飬������dataset������mat�ļ�
%                                                       %�����ơ��޸�ʱ���С���Ƿ��ļ��е����ԡ�
names_sets = []; 
lables_sets = [];
dtm1_FT = [];
dtm2_FT = [];
sp_GC_FT_n = [];

n = length(finf);
for k=1:n    % ����  male 2:22:n female 1:3:n  Ӣ�� 301:n
%      filename = ['D:\MATLAB\wav_f\',finf(k).name];        %�����k���ļ���λ�ã��ϲ��ļ�·�����ļ�����
     filename = ['D:\MATLAB\EN_train_m\',finf(k).name];        %�����k���ļ���λ�ã��ϲ��ļ�·�����ļ�����
    [x1,fs] = audioread(filename);
    %������ȡ
    %VAD[b,a]=tf(LowPass_fillter);
    x1=x1(:);
    sr =16000;  %�ز�����
    x1=resample(x1,sr,fs);
    %�������
    [vs,zo] = vadsohn(x1,sr);
    d_nozero = x1(1:length(vs));
    d_nozero(find(vs==0)) = [];
    %�˲�
    load filter_LP.mat
    x2=d_nozero;
%     x2=filter(filter_EN.b1,filter_EN.b2,x2);
    x2=filter(filter_EN.b1,filter_EN.b2,x2);
    %Ԥ����
    y1=pre_emphasis(x2);
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
        [gtm,c] = fft2gammatonemx(length(f)*2,sr,gammatone_n,1,50,sr/2,length(f)); %����gammatone�˲�����
        for j = 1:gammatone_n
            GT_out(j,:) = y_AM'.*gtm(j,:); %����gammatone�˲�����
        end
        GT_sum = sum(GT_out'); %��ÿ���˲�����������������
        GT_AM = log10(GT_sum);  %�����
        C_DCT = dct(GT_AM);   %��DCT�任
        result(i,:) = C_DCT;
    end
    GFCC_n =20; %������ȡǰ30��
    sp_GC_FT = result(:,1:GFCC_n);
    %��ȡһ�ײ��ϵ��
    dtm1 = [];
    dtm1 = difference(sp_GC_FT,1);
    %��ȡ���ײ��ϵ��
    dtm2 = [];
    dtm2 = difference(dtm1,1);


    %������ȡ����
     [~,col_num] = size(frame_data);
%      names =[];
%     names = repmat(finf(k).name,col_num,1);% ͬһ�����ļ��Ĳ�ͬ֡��ͬһ���ļ���
    lables = zeros(col_num,1);          % �Ա��ǩ��0ΪŮ��1Ϊ��
%     names_sets = [names_sets; names];   % ͬһ������������ͬһ��������
    lables_sets = [lables_sets; lables];% ÿ��Ϊһ���µ�����������
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
%������д��csv�ļ���
writetable(data_f,'GC_m_EN_20.csv');


