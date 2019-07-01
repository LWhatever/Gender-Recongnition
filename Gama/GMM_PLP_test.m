
load GMM_PLPdd_48_cepst.mat  %����Ӣ�ĵ�����GMMģ��
% load GMM_en_PLP_12_39.mat  %�������ĵ�����GMMģ��

finf = dir('E:\SpeechData\New\CH_test_m\*.wav');  %�����ļ����е��ļ���ʽ��ѡ���ȡ���ͣ���.jpg��.mat�ȡ�
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
parfor j=1:n
%     [x3,fs] = audioread('arctic_a0005.wav');
    filename = ['E:\SpeechData\New\CH_test_m\',finf(j).name];        %�����k���ļ���λ�ã��ϲ��ļ�·�����ļ�����
    [X,fs] = audioread(filename);
    %�ز���������
    [x1,NOISE] = noisegen(X,5);
    sr=16000; %��������GMM
    [vs,zo] = vadsohn(x1,fs);
    d_nozero = x1(1:length(vs));
    d_nozero(find(vs==0)) = [];
    [cep, ~] = rastaplp(d_nozero, sr, 0, 12);
%     cep = meanCeprmv(cep);
    del = deltas(cep);
    ddel = deltas(deltas(cep,5),5);
    cepDpDD = [cep',del',ddel'];

    %����Ӣ��GMMģ�ͱȶ�
%     [YM_m1_En,Y_m1_En]=lmultigauss(cep,GMM_English.mu_m1,GMM_English.sigm_m1,GMM_English.c_m1);
%     Y1_m_En(j)=mean(Y_m1_En);
%     [YM_f1_Ch,Y_f1_En]=lmultigauss(cep,GMM_English.mu_f1,GMM_English.sigm_f1,GMM_English.c_f1);
%     Y1_f_En(j)=mean(Y_f1_En);
    %��������GMMģ�ͱȶ�
    [YM_m1_Ch,Y_m1_Ch]=lmultigauss(cepDpDD',GMM_chinese.mu_m1,GMM_chinese.sigm_m1,GMM_chinese.c_m1);
    Y1_m_Ch(j)=mean(Y_m1_Ch);
    [YM_f1_Ch,Y_f1_Ch]=lmultigauss(cepDpDD',GMM_chinese.mu_f1,GMM_chinese.sigm_f1,GMM_chinese.c_f1);
    Y1_f_Ch(j)=mean(Y_f1_Ch);
end
% j_a=Y1_m_En>Y1_f_En;
j_b=Y1_m_Ch>Y1_f_Ch;
% m_En=sum(j_a);
m_Ch=sum(j_b)
m_Ch/n

% 99.49% 无噪音,男 2
% 98.97% 无噪音,女 4
% 99.23%

% 100% 30db,男 0
% 99.23% 30db,女 3
% 99.62%

% 99.49% 20db,男 2
% 96.67% 20db,女 13
% 98.08%

% 98.72% 10db,男 5
% 87.44% 10db,女 49
% 93.08%

% 96.92% 5db,男 12
% 80.77% 5db,女 75
% 88.85%
