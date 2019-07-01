

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
load GMM_MFCC_en.mat  %����Ӣ�ĵ�����GMMģ��
load GMM_MFCC_ch.mat  %�������ĵ�����GMMģ��
load filter_EN.mat    %����һ������Ƶ��Ϊ7600Hz���˲�����8000Hzʱ˥��40dB
load filter_Ch.mat    %����һ������Ƶ��Ϊ3800Hz���˲�����4000Hzʱ˥��40dB

wav_file=[PathName FileName];
[x1,fs]=audioread(wav_file);
%�ز���������
sr1=16000; %��������GMM
sr2=8000;  %����Ӣ��GMM 
%����GFCC������ȡ��Ӣ��GMM���������ڲ�����16000Hz����ȡ�ģ���������8000Hz��
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
         %����Ӣ��GMMģ�ͱȶ�
        [~,Y_m1_En]=lmultigauss(MFCCs,GMM_English.mu_m1,GMM_English.sigm_m1,GMM_English.c_m1);
        Y1_m_En=mean(Y_m1_En);
        [~,Y_f1_En]=lmultigauss(MFCCs,GMM_English.mu_f1,GMM_English.sigm_f1,GMM_English.c_f1);
        Y1_f_En=mean(Y_f1_En);
        %��������GMMģ�ͱȶ�
        [~,Y_m1_Ch]=lmultigauss(MFCCs,GMM_chinese.mu_m1,GMM_chinese.sigm_m1,GMM_chinese.c_m1);
        Y1_m_Ch=mean(Y_m1_Ch);
        [~,Y_f1_Ch]=lmultigauss(MFCCs,GMM_chinese.mu_f1,GMM_chinese.sigm_f1,GMM_chinese.c_f1);
        Y1_f_Ch=mean(Y_f1_Ch);
        %���ȶԽ����GFCCϵ���Ľ���Լ�����һ�ף����ײ�ֵĽ����Ϊ����
        Y1_all=[Y1_m_En;Y1_m_Ch;Y1_f_En ;Y1_f_Ch];
        %���������Ӣ��GMMģ�ͷ�Ϊ����
        lg_En_all=[Y1_m_En;Y1_f_En];
        lg_Ch_all=[Y1_m_Ch;Y1_f_Ch];
        %��������Ա�GMMģ�ͷ�Ϊ����
        gender_m_all=[Y1_m_En;Y1_m_Ch];
        gender_f_all=[Y1_f_En;Y1_f_Ch];

        %��ȡGFCC��һ��GFCC������GFCC�ó���������ֵ
        j1=max(Y1_all);
        %���������ֵ����һ��������
        j_all=j1;
        lg=0;
        gender=0;

        %��j_all�����ݸ�lg_En_all��gender_m_allƥ��
        % lg��ʾ��Ӣ�Ŀ�ƥ�䵽��������gender��ʾ��man��ƥ�䵽������
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

        %�����Ա����������
        %lg���ڵ���2��ʾ˵����˵����Ӣ�ע�����˸о���ȷ����Ҳ�п����ǵ���Ӱ�죩
        %lgС��2��ʾ˵����˵��������
        %gender>=2��ʾ˵������boy
        %gender<2��ʾ˵������girl
        if lg==1
            if gender ==1
                j_lg_geder=3 %Ӣ��boy
            else
                j_lg_geder=2 %Ӣ��girl
            end
        else
            if  gender ==1
                j_lg_geder=1 %����boy  
            else
                j_lg_geder=0 %����girl
            end
        end
         %j_lg_geder��ֵӳ���ϵ
         %   0        1      2        3
         %����girl ����boy Ӣ��boy Ӣ��girl
    end
end





