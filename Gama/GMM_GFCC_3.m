% [x1,fs] = audioread('arctic_a0002m.wav');
% [x2,fs] = audioread('arctic_a0002f.wav');
% [sp_GC_FT_1,dtm1_1,dtm2_1] =GFCC(x1,fs);
% [sp_GC_FT_2,dtm1_2,dtm2_2] =GFCC(x2,fs);
% sp1=[sp_GC_FT_1';dtm1_1';dtm2_1'];
% data_f_a= table2array(data_f(:,2:91));

% 得到GMM的模型
% filename = 'GC_m_CH_vad_64_0_8k.csv';
% filename1 = 'GC_f_CH_vad_64_0_8k.csv';
filename = 'GC_m_EN_vad_64_0_8k.csv';
filename1 = 'GC_f_EN_vad_64_0_8k.csv';
data_m = csvread(filename,1,0);
data_f = csvread(filename1,1,0);
sp_f=data_f(:,1:39);
sp_m =data_m(:,1:39);

%  GMM_chinese = [];
GMM_English = [];
M =20;
mu_f=[];
sigm_f=[];
c_f=[];
mu_m=[];
sigm_m=[];
c_m=[];
% [GMM_English_M_20.mu_m1,GMM_English_M_20.sigm_m1,GMM_English_M_20.c_m1]=gmm_estimate(sp_m(:,1:20)',M);
% [GMM_English_M_20.mu_f1,GMM_English_M_20.sigm_f1,GMM_English_M_20.c_f1]=gmm_estimate(sp_f(:,1:20)',M);
% [GMM_English_M_20.mu_m2,GMM_English_M_20.sigm_m2,GMM_English_M_20.c_m2]=gmm_estimate(sp_m(:,21:40)',M);
% [GMM_English_M_20.mu_f2,GMM_English_M_20.sigm_f2,GMM_English_M_20.c_f2]=gmm_estimate(sp_f(:,21:40)',M);
% [GMM_English_M_20.mu_m3,GMM_English_M_20.sigm_m3,GMM_English_M_20.c_m3]=gmm_estimate(sp_m(:,41:60)',M);
% [GMM_English_M_20.mu_f3,GMM_English_M_20.sigm_f3,GMM_English_M_20.c_f3]=gmm_estimate(sp_f(:,41:60)',M);

% [GMM_chinese.mu_m1,GMM_chinese.sigm_m1,GMM_chinese.c_m1]=gmm_estimate(sp_m',M);
% [GMM_chinese.mu_f1,GMM_chinese.sigm_f1,GMM_chinese.c_f1]=gmm_estimate(sp_f',M);
% [GMM_chinese.mu_m2,GMM_chinese.sigm_m2,GMM_chinese.c_m2]=gmm_estimate(sp_m(:,14:26)',M);
% [GMM_chinese.mu_f2,GMM_chinese.sigm_f2,GMM_chinese.c_f2]=gmm_estimate(sp_f(:,14:26)',M);
% [GMM_chinese.mu_m3,GMM_chinese.sigm_m3,GMM_chinese.c_m3]=gmm_estimate(sp_m(:,27:39)',M);
% [GMM_chinese.mu_f3,GMM_chinese.sigm_f3,GMM_chinese.c_f3]=gmm_estimate(sp_f(:,27:39)',M);
% save GMM_chinese
% [GMM_English_M_20.mu_m1,GMM_English_M_20.sigm_m1,GMM_English_M_20.c_m1]=gmm_estimate(sp_m(:,1:20)',M);
% [GMM_English_M_20.mu_f1,GMM_English_M_20.sigm_f1,GMM_English_M_20.c_f1]=gmm_estimate(sp_f(:,1:20)',M);
% [GMM_English_M_20.mu_m2,GMM_English_M_20.sigm_m2,GMM_English_M_20.c_m2]=gmm_estimate(sp_m(:,21:40)',M);
% [GMM_English_M_20.mu_f2,GMM_English_M_20.sigm_f2,GMM_English_M_20.c_f2]=gmm_estimate(sp_f(:,21:40)',M);
% [GMM_English_M_20.mu_m3,GMM_English_M_20.sigm_m3,GMM_English_M_20.c_m3]=gmm_estimate(sp_m(:,41:60)',M);
% [GMM_English_M_20.mu_f3,GMM_English_M_20.sigm_f3,GMM_English_M_20.c_f3]=gmm_estimate(sp_f(:,41:60)',M);

[GMM_English.mu_m1,GMM_English.sigm_m1,GMM_English.c_m1]=gmm_estimate(sp_m',M);
[GMM_English.mu_f1,GMM_English.sigm_f1,GMM_English.c_f1]=gmm_estimate(sp_f',M);
% [GMM_English.mu_m2,GMM_English.sigm_m2,GMM_English.c_m2]=gmm_estimate(sp_m(:,14:26)',M);
% [GMM_English.mu_f2,GMM_English.sigm_f2,GMM_English.c_f2]=gmm_estimate(sp_f(:,14:26)',M);
% [GMM_English.mu_m3,GMM_English.sigm_m3,GMM_English.c_m3]=gmm_estimate(sp_m(:,27:39)',M);
% [GMM_English.mu_f3,GMM_English.sigm_f3,GMM_English.c_f3]=gmm_estimate(sp_f(:,27:39)',M);
% save GMM_English

% 
% d1=Y1_f_En>Y1_f_Ch;

%judge_result为0表示识别为girl，否则为boy



