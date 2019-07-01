finf = dir('E:\SpeechData\boy_new\*.wav');  %根据文件夹中的文件格式，选择读取类型，如.jpg、.mat等。
                                                       %其中finf是一个结构体数组，包含的dataset下所有mat文件
                                                       %的名称、修改时间大小、是否文件夹等属性。

Tw = 25;           % analysis frame duration (ms)
Ts = 10;           % analysis frame shift (ms)
alpha = 0.97;      % preemphasis coefficient
maxfreq = 8000;  % frequency range to consider
M = 20;            % number of filterbank channels 
L = -22;            % cepstral sine lifter parameter
% fbankmake;
% fb = load('filterbank.mat');
% hamming = @(N)(0.54-0.46*cos(2*pi*[0:N-1].'/(N-1)));
% datacolumns = {'MFCC1','MFCC2','MFCC3','MFCC4','MFCC5','MFCC6',...
%                'MFCC7','MFCC8','MFCC9','MFCC10','MFCC11','MFCC12','MFCC13'};
datacolumns1 = {'PLP1','PLP2','PLP3','PLP4','PLP5','PLP6',...
               'PLP7','PLP8','PLP9','PLP10','PLP11','PLP12','PLP13',...
               'PLP1_d','PLP2_d','PLP3_d','PLP4_d','PLP5_d','PLP6_d',...
               'PLP7_d','PLP8_d','PLP9_d','PLP10_d','PLP11_d','PLP12_d','PLP13_d',...
               'PLP1_dd','PLP2_dd','PLP3_dd','PLP4_dd','PLP5_dd','PLP6_dd','PLP7_dd',...
               'PLP8_dd','PLP9_dd','PLP10_dd','PLP11_dd','PLP12_dd','PLP13_dd'};
n = length(finf);
gender=zeros(1,n);
parfor k=1:n
    filename = ['E:\SpeechData\boy_new\',finf(k).name];        %构造第k个文件的位置（合并文件路径和文件名）
    [d,sr] = audioread(filename);
    [d_n,~] = noisegen(d,5);
    % 以下为特征提取部分
    % pre-processing
    [vs,zo] = vadsohn(d_n,sr);         % VAD
    d_nozero = d_n(1:length(vs));
    d_nozero(vs==0) = [];            %去掉silence部分
    if(isempty(d_nozero))
        continue
    end
%     d_nozero = envexpand(d_nozero,fb);                % RASTA
    % Calculate 12th order PLP features without RASTA
    [cep, ~] = rastaplp(d_nozero, sr, 0, 12);
    del = deltas(cep);
    ddel = deltas(deltas(cep,5),5);
    cepDpDD = [cep',del',ddel'];
    [ MFCCs, ~, ~ ] =  melfcc( d_nozero, sr,'lifterexp', L,'nbands', M,'maxfreq', maxfreq, 'sumpower', 0,'fbtype', 'htkmel','dcttype', 3);
    MFCC_d = deltas(MFCCs);
    MFCC_dd = deltas(deltas(MFCCs,5),5);
    MFCCDpDD = [MFCCs',MFCC_d',MFCC_dd'];
    % 特征提取结束
    if(isempty(MFCCs))
        continue
    end
    
%     Test = table(MFCCDpDD(:,1),MFCCDpDD(:,2),MFCCDpDD(:,3),MFCCDpDD(:,4),MFCCDpDD(:,5),MFCCDpDD(:,6),...
%     MFCCDpDD(:,7),MFCCDpDD(:,8),MFCCDpDD(:,9),MFCCDpDD(:,10),MFCCDpDD(:,11),MFCCDpDD(:,12),MFCCDpDD(:,13),...
%     MFCCDpDD(:,14),MFCCDpDD(:,15),MFCCDpDD(:,16),MFCCDpDD(:,17),MFCCDpDD(:,18),MFCCDpDD(:,19),MFCCDpDD(:,20),MFCCDpDD(:,21),...
%     MFCCDpDD(:,22),MFCCDpDD(:,23),MFCCDpDD(:,24),MFCCDpDD(:,25),MFCCDpDD(:,26),MFCCDpDD(:,27),MFCCDpDD(:,28),MFCCDpDD(:,29),...
%     MFCCDpDD(:,30),MFCCDpDD(:,31),MFCCDpDD(:,32),MFCCDpDD(:,33),MFCCDpDD(:,34),MFCCDpDD(:,35),MFCCDpDD(:,36),MFCCDpDD(:,37),...
%     MFCCDpDD(:,38),MFCCDpDD(:,39),...
%     'VariableNames',datacolumns1);
    Test = table(cepDpDD(:,1),cepDpDD(:,2),cepDpDD(:,3),cepDpDD(:,4),cepDpDD(:,5),cepDpDD(:,6),...
    cepDpDD(:,7),cepDpDD(:,8),cepDpDD(:,9),cepDpDD(:,10),cepDpDD(:,11),cepDpDD(:,12),cepDpDD(:,13),...
    cepDpDD(:,14),cepDpDD(:,15),cepDpDD(:,16),cepDpDD(:,17),cepDpDD(:,18),cepDpDD(:,19),cepDpDD(:,20),cepDpDD(:,21),...
    cepDpDD(:,22),cepDpDD(:,23),cepDpDD(:,24),cepDpDD(:,25),cepDpDD(:,26),cepDpDD(:,27),cepDpDD(:,28),cepDpDD(:,29),...
    cepDpDD(:,30),cepDpDD(:,31),cepDpDD(:,32),cepDpDD(:,33),cepDpDD(:,34),cepDpDD(:,35),cepDpDD(:,36),cepDpDD(:,37),...
    cepDpDD(:,38),cepDpDD(:,39),...
    'VariableNames',datacolumns1);
    Test=table2array(Test)';
    [~,m]=size(Test);
    output=zeros(1,m);
    
    for i=1:m
        if py.test.nn_test_plp_kid(Test(:,i)')==0
            output(1,i)=0;
        else
            output(1,i)=1;
        end
    end
    if 2*sum(output)>length(Test)
        gender(1,k)=1;
    else
        gender(1,k)=0;
    end
end
curracy_m = sum(gender)/n

finf = dir('E:\SpeechData\girl_new\*.wav');
n = length(finf);
gender=zeros(1,n);
parfor k=1:n
    filename = ['E:\SpeechData\girl_new\',finf(k).name];        %构造第k个文件的位置（合并文件路径和文件名）
    [d,sr] = audioread(filename);
    [d_n,~] = noisegen(d,5);
    % 以下为特征提取部分
    % pre-processing
    [vs,zo] = vadsohn(d_n,sr);         % VAD
    d_nozero = d_n(1:length(vs));
    d_nozero(vs==0) = [];            %去掉silence部分
    if(isempty(d_nozero))
        continue
    end
%     d_nozero = envexpand(d_nozero,fb);                % RASTA
    % Calculate 12th order PLP features without RASTA
    [cep, ~] = rastaplp(d_nozero, sr, 0, 12);
    del = deltas(cep);
    ddel = deltas(deltas(cep,5),5);
    cepDpDD = [cep',del',ddel'];
    [ MFCCs, ~, ~ ] =  melfcc( d_nozero, sr,'lifterexp', L,'nbands', M,'maxfreq', maxfreq, 'sumpower', 0,'fbtype', 'htkmel','dcttype', 3);
    MFCC_d = deltas(MFCCs);
    MFCC_dd = deltas(deltas(MFCCs,5),5);
    MFCCDpDD = [MFCCs',MFCC_d',MFCC_dd'];
    % 特征提取结束
    if(isempty(MFCCs))
        continue
    end
    
    %     Test = table(MFCCDpDD(:,1),MFCCDpDD(:,2),MFCCDpDD(:,3),MFCCDpDD(:,4),MFCCDpDD(:,5),MFCCDpDD(:,6),...
%     MFCCDpDD(:,7),MFCCDpDD(:,8),MFCCDpDD(:,9),MFCCDpDD(:,10),MFCCDpDD(:,11),MFCCDpDD(:,12),MFCCDpDD(:,13),...
%     MFCCDpDD(:,14),MFCCDpDD(:,15),MFCCDpDD(:,16),MFCCDpDD(:,17),MFCCDpDD(:,18),MFCCDpDD(:,19),MFCCDpDD(:,20),MFCCDpDD(:,21),...
%     MFCCDpDD(:,22),MFCCDpDD(:,23),MFCCDpDD(:,24),MFCCDpDD(:,25),MFCCDpDD(:,26),MFCCDpDD(:,27),MFCCDpDD(:,28),MFCCDpDD(:,29),...
%     MFCCDpDD(:,30),MFCCDpDD(:,31),MFCCDpDD(:,32),MFCCDpDD(:,33),MFCCDpDD(:,34),MFCCDpDD(:,35),MFCCDpDD(:,36),MFCCDpDD(:,37),...
%     MFCCDpDD(:,38),MFCCDpDD(:,39),...
%     'VariableNames',datacolumns1);
    Test = table(cepDpDD(:,1),cepDpDD(:,2),cepDpDD(:,3),cepDpDD(:,4),cepDpDD(:,5),cepDpDD(:,6),...
    cepDpDD(:,7),cepDpDD(:,8),cepDpDD(:,9),cepDpDD(:,10),cepDpDD(:,11),cepDpDD(:,12),cepDpDD(:,13),...
    cepDpDD(:,14),cepDpDD(:,15),cepDpDD(:,16),cepDpDD(:,17),cepDpDD(:,18),cepDpDD(:,19),cepDpDD(:,20),cepDpDD(:,21),...
    cepDpDD(:,22),cepDpDD(:,23),cepDpDD(:,24),cepDpDD(:,25),cepDpDD(:,26),cepDpDD(:,27),cepDpDD(:,28),cepDpDD(:,29),...
    cepDpDD(:,30),cepDpDD(:,31),cepDpDD(:,32),cepDpDD(:,33),cepDpDD(:,34),cepDpDD(:,35),cepDpDD(:,36),cepDpDD(:,37),...
    cepDpDD(:,38),cepDpDD(:,39),...
    'VariableNames',datacolumns1);
    Test=table2array(Test)';
    [~,m]=size(Test);
    output=zeros(1,m);
    
    for i=1:m
        if py.test.nn_test_plp_kid(Test(:,i)')==0
            output(1,i)=0;
        else
            output(1,i)=1;
        end
    end
    if 2*sum(output)>length(Test)
        gender(1,k)=1;
    else
        gender(1,k)=0;
    end
end
curracy_f = 1- sum(gender)/n

tts('Test Complete!','Microsoft Huihui Desktop');