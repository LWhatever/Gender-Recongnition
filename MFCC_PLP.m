clear;
% [trainedClassifier, validationAccuracy] = trainClassifier(data);
finf = dir('C:\Users\heat\Desktop\voice_signal\ch_data\tm\*.wav');
dir_name='C:\Users\heat\Desktop\voice_signal\ch_data\tm\';
datacolumns = {'PLP_cep1','PLP_cep2','PLP_cep3','PLP_cep4','PLP_cep5','PLP_cep6',...
               'PLP_cep7','PLP_cep8','PLP_cep9','PLP_cep10','PLP_cep11','PLP_cep12','PLP_cep13',...
               'PLP_deltas1','PLP_deltas2','PLP_deltas3','PLP_deltas4','PLP_deltas5','PLP_deltas6',...
               'PLP_deltas7','PLP_deltas8','PLP_deltas9','PLP_deltas10','PLP_deltas11','PLP_deltas12','PLP_deltas13',...
               'PLP_ddeltas1','PLP_ddeltas2','PLP_ddeltas3','PLP_ddeltas4','PLP_ddeltas5','PLP_ddeltas6',...
               'PLP_ddeltas7','PLP_ddeltas8','PLP_ddeltas9','PLP_ddeltas10','PLP_ddeltas11','PLP_ddeltas12','PLP_ddeltas13'};
n = length(finf);
gender=zeros(1,n);
for k= 1:n
    filename = [dir_name,finf(k).name];        %构造第k个文件的位置（合并文件路径和文件名）
    [d,sr] = audioread(filename);
    %[d,~] = noisegen(d,10);
    % 以下为特征提取部分
    % VAD pre-processing
    [vs,zo] = vadsohn(d,sr);
    d_nozero = d(1:length(vs));
    d_nozero(vs==0) = [];            %去掉silence部分
    
    % Calculate 12th order PLP features without RASTA
    [cep, ~] = rastaplp(d_nozero, sr, 0, 12);
    del = deltas(cep);
    ddel = deltas(deltas(cep,5),5);
    cepDpDD = [cep',del',ddel'];
    Tw = 25;           % analysis frame duration (ms)
    Ts = 10;           % analysis frame shift (ms)
    alpha = 0.97;      % preemphasis coefficient
    R = [ 300 3700 ];  % frequency range to consider
    M = 20;            % number of filterbank channels 
    C = 13;            % number of cepstral coefficients
    L = 22;            % cepstral sine lifter parameter
    hamming = @(N)(0.54-0.46*cos(2*pi*[0:N-1].'/(N-1)));
    
    Test = table(cepDpDD(:,1),cepDpDD(:,2),cepDpDD(:,3),cepDpDD(:,4),cepDpDD(:,5),cepDpDD(:,6),cepDpDD(:,7),...
    cepDpDD(:,8),cepDpDD(:,9),cepDpDD(:,10),cepDpDD(:,11),cepDpDD(:,12),cepDpDD(:,13),...
    cepDpDD(:,14),cepDpDD(:,15),cepDpDD(:,16),cepDpDD(:,17),cepDpDD(:,18),cepDpDD(:,19),cepDpDD(:,20),...
    cepDpDD(:,21),cepDpDD(:,22),cepDpDD(:,23),cepDpDD(:,24),cepDpDD(:,25),cepDpDD(:,26),...
    cepDpDD(:,27),cepDpDD(:,28),cepDpDD(:,29),cepDpDD(:,30),cepDpDD(:,31),cepDpDD(:,32),cepDpDD(:,33),...
    cepDpDD(:,34),cepDpDD(:,35),cepDpDD(:,36),cepDpDD(:,37),cepDpDD(:,38),cepDpDD(:,39),...
    'VariableNames',datacolumns);
    Test=table2array(Test)';
    [~,m]=size(Test);
    output=zeros(1,m);
    
    for i=1:m
        if py.test.nn_test(Test(:,i)')==0
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
sum(gender)



gender=zeros(1,n);
for k= 1:n
    filename = [dir_name,finf(k).name];        %构造第k个文件的位置（合并文件路径和文件名）
    [d,sr] = audioread(filename);
    [d,~] = noisegen(d,30);
    % 以下为特征提取部分
    % VAD pre-processing
    [vs,zo] = vadsohn(d,sr);
    d_nozero = d(1:length(vs));
    d_nozero(vs==0) = [];            %去掉silence部分
    
    % Calculate 12th order PLP features without RASTA
    [cep, ~] = rastaplp(d_nozero, sr, 0, 12);
    del = deltas(cep);
    ddel = deltas(deltas(cep,5),5);
    cepDpDD = [cep',del',ddel'];
    Tw = 25;           % analysis frame duration (ms)
    Ts = 10;           % analysis frame shift (ms)
    alpha = 0.97;      % preemphasis coefficient
    R = [ 300 3700 ];  % frequency range to consider
    M = 20;            % number of filterbank channels 
    C = 13;            % number of cepstral coefficients
    L = 22;            % cepstral sine lifter parameter
    hamming = @(N)(0.54-0.46*cos(2*pi*[0:N-1].'/(N-1)));
    
    Test = table(cepDpDD(:,1),cepDpDD(:,2),cepDpDD(:,3),cepDpDD(:,4),cepDpDD(:,5),cepDpDD(:,6),cepDpDD(:,7),...
    cepDpDD(:,8),cepDpDD(:,9),cepDpDD(:,10),cepDpDD(:,11),cepDpDD(:,12),cepDpDD(:,13),...
    cepDpDD(:,14),cepDpDD(:,15),cepDpDD(:,16),cepDpDD(:,17),cepDpDD(:,18),cepDpDD(:,19),cepDpDD(:,20),...
    cepDpDD(:,21),cepDpDD(:,22),cepDpDD(:,23),cepDpDD(:,24),cepDpDD(:,25),cepDpDD(:,26),...
    cepDpDD(:,27),cepDpDD(:,28),cepDpDD(:,29),cepDpDD(:,30),cepDpDD(:,31),cepDpDD(:,32),cepDpDD(:,33),...
    cepDpDD(:,34),cepDpDD(:,35),cepDpDD(:,36),cepDpDD(:,37),cepDpDD(:,38),cepDpDD(:,39),...
    'VariableNames',datacolumns);
    Test=table2array(Test)';
    [~,m]=size(Test);
    output=zeros(1,m);
    
    for i=1:m
        if py.test.nn_test(Test(:,i)')==0
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
sum(gender)


gender=zeros(1,n);
for k= 1:n
    filename = [dir_name,finf(k).name];        %构造第k个文件的位置（合并文件路径和文件名）
    [d,sr] = audioread(filename);
    [d,~] = noisegen(d,20);
    % 以下为特征提取部分
    % VAD pre-processing
    [vs,zo] = vadsohn(d,sr);
    d_nozero = d(1:length(vs));
    d_nozero(vs==0) = [];            %去掉silence部分
    
    % Calculate 12th order PLP features without RASTA
    [cep, ~] = rastaplp(d_nozero, sr, 0, 12);
    del = deltas(cep);
    ddel = deltas(deltas(cep,5),5);
    cepDpDD = [cep',del',ddel'];
    Tw = 25;           % analysis frame duration (ms)
    Ts = 10;           % analysis frame shift (ms)
    alpha = 0.97;      % preemphasis coefficient
    R = [ 300 3700 ];  % frequency range to consider
    M = 20;            % number of filterbank channels 
    C = 13;            % number of cepstral coefficients
    L = 22;            % cepstral sine lifter parameter
    hamming = @(N)(0.54-0.46*cos(2*pi*[0:N-1].'/(N-1)));
    
    Test = table(cepDpDD(:,1),cepDpDD(:,2),cepDpDD(:,3),cepDpDD(:,4),cepDpDD(:,5),cepDpDD(:,6),cepDpDD(:,7),...
    cepDpDD(:,8),cepDpDD(:,9),cepDpDD(:,10),cepDpDD(:,11),cepDpDD(:,12),cepDpDD(:,13),...
    cepDpDD(:,14),cepDpDD(:,15),cepDpDD(:,16),cepDpDD(:,17),cepDpDD(:,18),cepDpDD(:,19),cepDpDD(:,20),...
    cepDpDD(:,21),cepDpDD(:,22),cepDpDD(:,23),cepDpDD(:,24),cepDpDD(:,25),cepDpDD(:,26),...
    cepDpDD(:,27),cepDpDD(:,28),cepDpDD(:,29),cepDpDD(:,30),cepDpDD(:,31),cepDpDD(:,32),cepDpDD(:,33),...
    cepDpDD(:,34),cepDpDD(:,35),cepDpDD(:,36),cepDpDD(:,37),cepDpDD(:,38),cepDpDD(:,39),...
    'VariableNames',datacolumns);
    Test=table2array(Test)';
    [~,m]=size(Test);
    output=zeros(1,m);
    
    for i=1:m
        if py.test.nn_test(Test(:,i)')==0
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
sum(gender)


gender=zeros(1,n);
for k= 1:n
    filename = [dir_name,finf(k).name];        %构造第k个文件的位置（合并文件路径和文件名）
    [d,sr] = audioread(filename);
    [d,~] = noisegen(d,10);
    % 以下为特征提取部分
    % VAD pre-processing
    [vs,zo] = vadsohn(d,sr);
    d_nozero = d(1:length(vs));
    d_nozero(vs==0) = [];            %去掉silence部分
    
    % Calculate 12th order PLP features without RASTA
    [cep, ~] = rastaplp(d_nozero, sr, 0, 12);
    del = deltas(cep);
    ddel = deltas(deltas(cep,5),5);
    cepDpDD = [cep',del',ddel'];
    Tw = 25;           % analysis frame duration (ms)
    Ts = 10;           % analysis frame shift (ms)
    alpha = 0.97;      % preemphasis coefficient
    R = [ 300 3700 ];  % frequency range to consider
    M = 20;            % number of filterbank channels 
    C = 13;            % number of cepstral coefficients
    L = 22;            % cepstral sine lifter parameter
    hamming = @(N)(0.54-0.46*cos(2*pi*[0:N-1].'/(N-1)));
    
    Test = table(cepDpDD(:,1),cepDpDD(:,2),cepDpDD(:,3),cepDpDD(:,4),cepDpDD(:,5),cepDpDD(:,6),cepDpDD(:,7),...
    cepDpDD(:,8),cepDpDD(:,9),cepDpDD(:,10),cepDpDD(:,11),cepDpDD(:,12),cepDpDD(:,13),...
    cepDpDD(:,14),cepDpDD(:,15),cepDpDD(:,16),cepDpDD(:,17),cepDpDD(:,18),cepDpDD(:,19),cepDpDD(:,20),...
    cepDpDD(:,21),cepDpDD(:,22),cepDpDD(:,23),cepDpDD(:,24),cepDpDD(:,25),cepDpDD(:,26),...
    cepDpDD(:,27),cepDpDD(:,28),cepDpDD(:,29),cepDpDD(:,30),cepDpDD(:,31),cepDpDD(:,32),cepDpDD(:,33),...
    cepDpDD(:,34),cepDpDD(:,35),cepDpDD(:,36),cepDpDD(:,37),cepDpDD(:,38),cepDpDD(:,39),...
    'VariableNames',datacolumns);
    Test=table2array(Test)';
    [~,m]=size(Test);
    output=zeros(1,m);
    
    for i=1:m
        if py.test.nn_test(Test(:,i)')==0
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
sum(gender)






gender=zeros(1,n);
for k= 1:n
    filename = [dir_name,finf(k).name];        %构造第k个文件的位置（合并文件路径和文件名）
    [d,sr] = audioread(filename);
    [d,~] = noisegen(d,0);
    % 以下为特征提取部分
    % VAD pre-processing
    [vs,zo] = vadsohn(d,sr);
    d_nozero = d(1:length(vs));
    d_nozero(vs==0) = [];            %去掉silence部分
    
    % Calculate 12th order PLP features without RASTA
    [cep, ~] = rastaplp(d_nozero, sr, 0, 12);
    del = deltas(cep);
    ddel = deltas(deltas(cep,5),5);
    cepDpDD = [cep',del',ddel'];
    Tw = 25;           % analysis frame duration (ms)
    Ts = 10;           % analysis frame shift (ms)
    alpha = 0.97;      % preemphasis coefficient
    R = [ 300 3700 ];  % frequency range to consider
    M = 20;            % number of filterbank channels 
    C = 13;            % number of cepstral coefficients
    L = 22;            % cepstral sine lifter parameter
    hamming = @(N)(0.54-0.46*cos(2*pi*[0:N-1].'/(N-1)));
    
    Test = table(cepDpDD(:,1),cepDpDD(:,2),cepDpDD(:,3),cepDpDD(:,4),cepDpDD(:,5),cepDpDD(:,6),cepDpDD(:,7),...
    cepDpDD(:,8),cepDpDD(:,9),cepDpDD(:,10),cepDpDD(:,11),cepDpDD(:,12),cepDpDD(:,13),...
    cepDpDD(:,14),cepDpDD(:,15),cepDpDD(:,16),cepDpDD(:,17),cepDpDD(:,18),cepDpDD(:,19),cepDpDD(:,20),...
    cepDpDD(:,21),cepDpDD(:,22),cepDpDD(:,23),cepDpDD(:,24),cepDpDD(:,25),cepDpDD(:,26),...
    cepDpDD(:,27),cepDpDD(:,28),cepDpDD(:,29),cepDpDD(:,30),cepDpDD(:,31),cepDpDD(:,32),cepDpDD(:,33),...
    cepDpDD(:,34),cepDpDD(:,35),cepDpDD(:,36),cepDpDD(:,37),cepDpDD(:,38),cepDpDD(:,39),...
    'VariableNames',datacolumns);
    Test=table2array(Test)';
    [~,m]=size(Test);
    output=zeros(1,m);
    
    for i=1:m
        if py.test.nn_test(Test(:,i)')==0
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
sum(gender)
tts('醒醒，测试完了','Microsoft Huihui Desktop');