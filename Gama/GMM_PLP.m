% [x1,fs] = audioread('arctic_a0002m.wav');
% [x2,fs] = audioread('arctic_a0002f.wav');
% [sp_GC_FT_1,dtm1_1,dtm2_1] =GFCC(x1,fs);
% [sp_GC_FT_2,dtm1_2,dtm2_2] =GFCC(x2,fs);
% sp1=[sp_GC_FT_1';dtm1_1';dtm2_1'];
% data_f_a= table2array(data_f(:,2:91));

% % �õ�GMM��ģ��
% filename = 'GC_m_chinese_right.csv';
% filename1 = 'GC_f_chinese_right.csv';
% data_m = csvread(filename,1,0);
% data_f = csvread(filename1,1,0);
% sp_f=data_f(:,1:39);
% sp_m =data_m(:,1:39);
% load PLP_em.mat
% load PLP_ef.mat
load PLP_cm.mat
load PLP_cf.mat
% PLP=table2array(PLP_data(:,1:13));
% PLP_EN_m=table2array(RASTA_PLP_data_em(:,1:39));
% PLP_EN_f=table2array(RASTA_PLP_data_ef(:,1:39));
PLP_CH_m=table2array(RASTA_PLP_data_cm(:,1:39));
PLP_CH_f=table2array(RASTA_PLP_data_cf(:,1:39));

% dPLP=table2array(dPLP_data(:,1:13));
% dPLP_EN_m=dPLP(1:250387,:);
% dPLP_EN_f=dPLP(250388:518643,:);
% dPLP_CH_m=dPLP(518644:767113,:);
% dPLP_CH_f=dPLP(767114:949172,:);
% 
% ddPLP=table2array(ddPLP_data(:,1:13));
% ddPLP_EN_m=ddPLP(1:250387,:);
% ddPLP_EN_f=ddPLP(250388:518643,:);
% ddPLP_CH_m=ddPLP(518644:767113,:);
% ddPLP_CH_f=ddPLP(767114:949172,:);
 GMM_chinese = [];
% GMM_English = [];
M =48;
mu_f=[];
sigm_f=[];
c_f=[];
mu_m=[];
sigm_m=[];
c_m=[];
[GMM_chinese.mu_m1,GMM_chinese.sigm_m1,GMM_chinese.c_m1]=gmm_estimate(PLP_CH_m',M);
[GMM_chinese.mu_f1,GMM_chinese.sigm_f1,GMM_chinese.c_f1]=gmm_estimate(PLP_CH_f',M);
% [GMM_chinese.mu_m2,GMM_chinese.sigm_m2,GMM_chinese.c_m2]=gmm_estimate(dPLP_CH_m',M);
% [GMM_chinese.mu_f2,GMM_chinese.sigm_f2,GMM_chinese.c_f2]=gmm_estimate(dPLP_CH_f',M);
% [GMM_chinese.mu_m3,GMM_chinese.sigm_m3,GMM_chinese.c_m3]=gmm_estimate(ddPLP_CH_m',M);
% [GMM_chinese.mu_f3,GMM_chinese.sigm_f3,GMM_chinese.c_f3]=gmm_estimate(ddPLP_CH_f',M);
% save GMM_chinese
% [GMM_English.mu_m1,GMM_English.sigm_m1,GMM_English.c_m1]=gmm_estimate(PLP_EN_m',M);
% [GMM_English.mu_f1,GMM_English.sigm_f1,GMM_English.c_f1]=gmm_estimate(PLP_EN_f',M);
% [GMM_English.mu_m2,GMM_English.sigm_m2,GMM_English.c_m2]=gmm_estimate(dPLP_EN_m',M);
% [GMM_English.mu_f2,GMM_English.sigm_f2,GMM_English.c_f2]=gmm_estimate(dPLP_EN_f',M);
% [GMM_English.mu_m3,GMM_English.sigm_m3,GMM_English.c_m3]=gmm_estimate(ddPLP_EN_m',M);
% [GMM_English.mu_f3,GMM_English.sigm_f3,GMM_English.c_f3]=gmm_estimate(ddPLP_EN_f',M);
% save GMM_English
% save��'GMM_modules_chinese.mat','mu_m1','sigm_m1','c_m1','mu_f1','sigm_f1','c_f1','mu_m2','sigm_m2','c_m2','mu_f2','sigm_f2','c_f2','mu_m3','sigm_m3','c_m3','mu_f3','sigm_f3','c_f3'��