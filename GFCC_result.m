function result=GFCC_result(x1,fs,GMM_chinese)
%�ز���������
 %��������GMM

sr1=16000;
if fs~=16000
    x1=resample(x1,sr1,fs);
end

%����GFCC������ȡ��Ӣ��GMM���������ڲ�����16000Hz����ȡ��


if length(x1)>0.025*16000
    [sp_GC_FT_3_Ch,dtm1_3_Ch,dtm2_3_Ch] =GFCC(x1,sr1);
    %��������GMMģ�ͱȶ�
    [YM_m1_Ch,Y_m1_Ch]=lmultigauss(sp_GC_FT_3_Ch',GMM_chinese.mu_m1,GMM_chinese.sigm_m1,GMM_chinese.c_m1);
    [YM_m2_Ch,Y_m2_Ch]=lmultigauss(dtm1_3_Ch',GMM_chinese.mu_m2,GMM_chinese.sigm_m2,GMM_chinese.c_m2);
    [YM_m3_Ch,Y_m3_Ch]=lmultigauss(dtm2_3_Ch',GMM_chinese.mu_m3,GMM_chinese.sigm_m3,GMM_chinese.c_m3);
    Y1_m_Ch=mean(Y_m1_Ch);
    Y2_m_Ch=mean(Y_m2_Ch);
    Y3_m_Ch=mean(Y_m3_Ch);
    [YM_f1_Ch,Y_f1_Ch]=lmultigauss(sp_GC_FT_3_Ch',GMM_chinese.mu_f1,GMM_chinese.sigm_f1,GMM_chinese.c_f1);
    [YM_f2_Ch,Y_f2_Ch]=lmultigauss(dtm1_3_Ch',GMM_chinese.mu_f2,GMM_chinese.sigm_f2,GMM_chinese.c_f2);
    [YM_f3_Ch,Y_f3_Ch]=lmultigauss(dtm2_3_Ch',GMM_chinese.mu_f3,GMM_chinese.sigm_f3,GMM_chinese.c_f3);
    Y1_f_Ch=mean(Y_f1_Ch);
    Y2_f_Ch=mean(Y_f2_Ch);
    Y3_f_Ch=mean(Y_f3_Ch);


    %���ȶԽ����GFCCϵ���Ľ���Լ�����һ�ף����ײ�ֵĽ����Ϊ����
    Y1_all=[Y1_m_Ch;Y1_f_Ch];
    Y2_all=[Y2_m_Ch;Y2_f_Ch];
    Y3_all=[Y3_m_Ch;Y3_f_Ch];
    %��������Ա�GMMģ�ͷ�Ϊ����
    gender_m_all=[Y1_m_Ch;Y2_m_Ch;Y3_m_Ch];
    gender_f_all=[Y1_f_Ch;Y2_f_Ch;Y3_f_Ch];

    %��ȡGFCC��һ��GFCC������GFCC�ó���������ֵ
    j1=max(Y1_all);
    j2=max(Y2_all);
    j3=max(Y3_all);
    %���������ֵ����һ��������
    j_all=[j1;j2;j3];
    gender=0;
    %��j_all�����ݸ�gender_m_allƥ��
    % gender��ʾ��man��ƥ�䵽������
    for i=1:3
        for j=1:3
            if j_all(i,1)==gender_m_all(j,1)
               gender=gender+1;
            end
        end
    end

    %�����Ա�����
    %gender>=2��ʾ˵������boy
    %gender<2��ʾ˵������girl
    if (Y1_m_Ch>Y1_f_Ch)||(gender >=2)
        result=1; %boy
    else
        result=0; %girl
    end
 %j_lg_geder��ֵӳ���ϵ
 %   0        1     
 %����girl ����boy 
    else
        errordlg('ERROR! no speech in this file');
        return;
    end
end
