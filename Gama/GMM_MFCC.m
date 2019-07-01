% [x1,fs] = audioread('arctic_a0002m.wav');
% [x2,fs] = audioread('arctic_a0002f.wav');
% [sp_GC_FT_1,dtm1_1,dtm2_1] =GFCC(x1,fs);
% [sp_GC_FT_2,dtm1_2,dtm2_2] =GFCC(x2,fs);
% sp1=[sp_GC_FT_1';dtm1_1';dtm2_1'];
% data_f_a= table2array(data_f(:,2:91));

% % 得到GMM的模型
% filename = 'GC_m_chinese_right.csv';
% filename1 = 'GC_f_chinese_right.csv';
% data_m = csvread(filename,1,0);
% data_f = csvread(filename1,1,0);
% sp_f=data_f(:,1:39);
% sp_m =data_m(:,1:39);
MFCC=table2array(MFCC_data(:,1:13));
MFCC_EN_m=MFCC(1:186050,:);
MFCC_EN_f=MFCC(186051:381138,:);
MFCC_CH_m=MFCC(381139:518136,:);
MFCC_CH_f=MFCC(518137:664145,:);
% load MFCC_data_f.mat
% load MFCC_data_m.mat
 GMM_chinese = [];
GMM_English = [];
M =48;
mu_f=[];
sigm_f=[];
c_f=[];
mu_m=[];
sigm_m=[];
c_m=[];
[GMM_chinese.mu_m1,GMM_chinese.sigm_m1,GMM_chinese.c_m1]=gmm_estimate(MFCC_CH_m',M);
[GMM_chinese.mu_f1,GMM_chinese.sigm_f1,GMM_chinese.c_f1]=gmm_estimate(MFCC_CH_f',M);
% [GMM_chinese.mu_m2,GMM_chinese.sigm_m2,GMM_chinese.c_m2]=gmm_estimate(sp_m(:,14:26)',M);
% [GMM_chinese.mu_f2,GMM_chinese.sigm_f2,GMM_chinese.c_f2]=gmm_estimate(sp_f(:,14:26)',M);
% [GMM_chinese.mu_m3,GMM_chinese.sigm_m3,GMM_chinese.c_m3]=gmm_estimate(sp_m(:,27:39)',M);
% [GMM_chinese.mu_f3,GMM_chinese.sigm_f3,GMM_chinese.c_f3]=gmm_estimate(sp_f(:,27:39)',M);
% save GMM_chinese
[GMM_English.mu_m1,GMM_English.sigm_m1,GMM_English.c_m1]=gmm_estimate(MFCC_EN_m',M);
[GMM_English.mu_f1,GMM_English.sigm_f1,GMM_English.c_f1]=gmm_estimate(MFCC_EN_f',M);
% [GMM_English.mu_m2,GMM_English.sigm_m2,GMM_English.c_m2]=gmm_estimate(sp_m(:,14:26)',M);
% [GMM_English.mu_f2,GMM_English.sigm_f2,GMM_English.c_f2]=gmm_estimate(sp_f(:,14:26)',M);
% [GMM_English.mu_m3,GMM_English.sigm_m3,GMM_English.c_m3]=gmm_estimate(sp_m(:,27:39)',M);
% [GMM_English.mu_f3,GMM_English.sigm_f3,GMM_English.c_f3]=gmm_estimate(sp_f(:,27:39)',M);
% save GMM_English
% save（'GMM_modules_chinese.mat','mu_m1','sigm_m1','c_m1','mu_f1','sigm_f1','c_f1','mu_m2','sigm_m2','c_m2','mu_f2','sigm_f2','c_f2','mu_m3','sigm_m3','c_m3','mu_f3','sigm_f3','c_f3'）