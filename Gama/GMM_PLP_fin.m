load GMM_PLPdd_48.mat  %����Ӣ�ĵ�����GMMģ��
[FileName,PathName] = uigetfile('*.wav','Select the .wav file');
if PathName == 0
    errordlg('ERROR! No file selected!');
    return;
end  
wav_file=[PathName FileName];
[x1,fs]=audioread(wav_file);

% fs = 16000;
% recObj = audiorecorder(fs, 16, 1);
% fprintf('Press any key to start %g seconds of recording...\n',4);
% pause;
% recordblocking(recObj, 4);
% fprintf('Finished recording.\n');
% play(recObj);
% x1 = getaudiodata(recObj);

sr1=16000; %��������GMM
if fs~=16000
    x1=resample(x1,sr1,fs);
end
sound(x1,sr1);

sr=16000; %��������GMM
[vs,zo] = vadsohn(x1,sr1);
d_nozero = x1(1:length(vs));
d_nozero(find(vs==0)) = [];
[cep, ~] = rastaplp(d_nozero, sr, 0, 12);
del = deltas(cep);
ddel = deltas(deltas(cep,5),5);
cepDpDD = [cep',del',ddel'];

[YM_m1_Ch,Y_m1_Ch]=lmultigauss(cepDpDD',GMM_chinese.mu_m1,GMM_chinese.sigm_m1,GMM_chinese.c_m1);
Y1_m_Ch=mean(Y_m1_Ch);
[YM_f1_Ch,Y_f1_Ch]=lmultigauss(cepDpDD',GMM_chinese.mu_f1,GMM_chinese.sigm_f1,GMM_chinese.c_f1);
Y1_f_Ch=mean(Y_f1_Ch);
if Y1_m_Ch>Y1_f_Ch
    gender=1
else
    gender=0
end
% 99.49% 无噪�?,�? 2
% 98.97% 无噪�?,�? 4
% 99.23%

% 100% 30db,�? 0
% 99.23% 30db,�? 3
% 99.62%

% 99.49% 20db,�? 2
% 96.67% 20db,�? 13
% 98.08%

% 98.72% 10db,�? 5
% 87.44% 10db,�? 49
% 93.08%

% 96.92% 5db,�? 12
% 80.77% 5db,�? 75
% 88.85%
