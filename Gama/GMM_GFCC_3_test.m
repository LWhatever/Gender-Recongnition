 
% finf = dir('D:\MATLAB\wav_m\*.wav');  %�����ļ����е��ļ���ʽ��ѡ���ȡ���ͣ���.jpg��.mat�ȡ�
%                                                        %����finf��һ���ṹ�����飬������dataset������mat�ļ�
%                                                       %�����ơ��޸�ʱ���С���Ƿ��ļ��е����ԡ�
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
finf = dir('D:\MATLAB\CH_test_m\*.wav');  %�����ļ����е��ļ���ʽ��ѡ���ȡ���ͣ���.jpg��.mat�ȡ�
                                                       %����finf��һ���ṹ�����飬������dataset������mat�ļ�
n=length(finf)                                                      %�����ơ��޸�ʱ���С���Ƿ��ļ��е����ԡ�
 
for j=1:n
%     [x1,fs] = audioread('D:\MATLAB\CH_test_f\20170001P00060I0009.wav');
    filename = ['D:\MATLAB\CH_test_m\',finf(j).name];        %�����k���ļ���λ�ã��ϲ��ļ�·�����ļ�����
    [X,fs] = audioread(filename);    
    % wav_file=[PathName FileName];
    % [x1,fs]=audioread(wav_file);
   %�ز���������
   SNR=0;
   [x1,NOISE] = noisegen(X,SNR);
    sr1=16000; %����Ӣ��GMM
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

        %����Ӣ��GMMģ�ͱȶ�
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

        %��������GMMģ�ͱȶ�
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


        %���ȶԽ����GFCCϵ���Ľ���Լ�����һ�ף����ײ�ֵĽ����Ϊ����
%         Y1_all=[Y1_m_En;Y1_m_Ch;Y1_f_En ;Y1_f_Ch];
%         Y2_all=[Y2_m_En;Y2_m_Ch;Y2_f_En ;Y2_f_Ch];
%         Y3_all=[Y3_m_En;Y3_m_Ch;Y3_f_En ;Y3_f_Ch];
        judge(j)=Y1_m_Ch(j)>Y1_f_Ch(j);
        %���������Ӣ��GMMģ�ͷ�Ϊ����
%         lg_En_all=[Y1_m_En;Y2_m_En;Y3_m_En;Y1_f_En;Y2_f_En;Y3_f_En];
%         lg_Ch_all=[Y1_m_Ch;Y2_m_Ch;Y3_m_Ch;Y1_f_Ch;Y2_f_En;Y3_f_Ch];
%         %��������Ա�GMMģ�ͷ�Ϊ����
%         gender_m_all=[Y1_m_En;Y1_m_Ch;Y2_m_En;Y2_m_Ch;Y3_m_En;Y3_m_Ch];
%         gender_f_all=[Y1_f_En;Y1_f_Ch;Y2_f_En;Y2_f_Ch;Y3_f_En;Y3_f_Ch];
% 
%         %��ȡGFCC��һ��GFCC������GFCC�ó���������ֵ
%         j1=max(Y1_all);
%         j2=max(Y2_all);
%         j3=max(Y3_all);
%         %���������ֵ����һ��������
%         j_all=[j1;j2;j3];
%         lg=0;
%         gender=0;
% 
%         %��j_all�����ݸ�lg_En_all��gender_m_allƥ��
%         % lg��ʾ��Ӣ�Ŀ�ƥ�䵽��������gender��ʾ��man��ƥ�䵽������
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
%     %�����Ա����������
%     %lg���ڵ���2��ʾ˵����˵����Ӣ�ע�����˸о���ȷ����Ҳ�п����ǵ���Ӱ�죩
%     %lgС��2��ʾ˵����˵��������
%     %gender>=2��ʾ˵������boy
%     %gender<2��ʾ˵������girl
%     if lg>=2
%         if gender >=2
%             j_lg_geder=3; %Ӣ��boy
%         else
%             j_lg_geder=2;%Ӣ��girl
%         end
%     else
%         if Y1_m_Ch>Y1_f_Ch
%             j_lg_geder=1;%����boy  
%         elseif Y2_m_Ch>Y2_f_Ch && Y3_m_Ch>Y3_f_Ch
%             j_lg_geder=1;%����girl
%         else
%             j_lg_geder=0;%����boy
%         end
%     end
%      %j_lg_geder��ֵӳ���ϵ
%      %   0        1      3        2
%      %����girl ����boy Ӣ��boy Ӣ��girl
%         j_lg_geder_t=[j_lg_geder_t,j_lg_geder];
    end
end
% M_get=sum(abcd)
% M=M_get/390
M=sum(Y1_m_Ch>Y1_f_Ch)

