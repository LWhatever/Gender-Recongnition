% batch processing
% MFCCs、PLP features
finf = dir('E:\SpeechData\New\EN_train_m\*.wav');           % get the files information

lables_sets = [];
MFCCs_sets = [];
cepDpDD_sets = [];
% analysis frame duration 25ms
% analysis frame shift 10ms
maxfreq = 8000;     % frequency range to consider
M = 20;             % number of filterbank channels 
L = -22;            % cepstral sine lifter parameter

fbankmake;          % make RASTA filter bank
fb = load('filterbank.mat');
% hamming = @(N)(0.54-0.46*cos(2*pi*[0:N-1].'/(N-1)));
n = length(finf);
% poolobj = parpool('local',2);
parfor k=1:n
    filename = ['E:\SpeechData\New\EN_train_m\',finf(k).name];        %构造第k个文件的位置（合并文件路径和文件名）
    [d,sr] = audioread(filename);
%     [d,~] = noisegen(d,0);
    % 以下为特征提取部分
    % VAD pre-processing
    [vs,zo] = vadsohn(d,sr);
    d_nozero = d(1:length(vs));
    d_nozero(vs==0) = [];            %去掉silence部分
    if(isempty(d_nozero))
        continue
    end
%     d_nozero = envexpand(d_nozero,fb);
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
    % 将每一帧特征都放在一个特征矩阵里
    [~,col_num] = size(cep);
%     names = repmat(finf(k).name,col_num,1);% 同一语音文件的不同帧用同一个文件名
    lables = repmat('en_m',col_num,1);          % 性别标签
    lables_sets = [lables_sets; lables];% 每行为一段新的语音的特征
    cepDpDD_sets = [cepDpDD_sets; cepDpDD];
    MFCCs_sets = [MFCCs_sets; MFCCDpDD];
end
% datacolumns = {'filename','MFCC1','MFCC2','MFCC3','MFCC4','MFCC5','MFCC6',...
%                    'MFCC7','MFCC8','MFCC9','MFCC10','MFCC11','MFCC12','MFCC13',...
%                    'PLP_cep1','PLP_cep2','PLP_cep3','PLP_cep4','PLP_cep5','PLP_cep6',...
%                    'PLP_cep7','PLP_cep8','PLP_cep9','PLP_cep10','PLP_cep11','PLP_cep12','PLP_cep13',...
%                    'PLP_deltas1','PLP_deltas2','PLP_deltas3','PLP_deltas4','PLP_deltas5','PLP_deltas6',...
%                    'PLP_deltas7','PLP_deltas8','PLP_deltas9','PLP_deltas10','PLP_deltas11','PLP_deltas12','PLP_deltas13',...
%                    'PLP_ddeltas1','PLP_ddeltas2','PLP_ddeltas3','PLP_ddeltas4','PLP_ddeltas5','PLP_ddeltas6',...
%                    'PLP_ddeltas7','PLP_ddeltas8','PLP_ddeltas9','PLP_ddeltas10','PLP_ddeltas11','PLP_ddeltas12','PLP_ddeltas13','lable'};

               
finf = dir('E:\SpeechData\New\EN_train_f\*.wav');  %根据文件夹中的文件格式，选择读取类型，如.jpg、.mat等。
                                                       %其中finf是一个结构体数组，包含的dataset下所有mat文件
                                                       %的名称、修改时间大小、是否文件夹等属性。
n = length(finf);
parfor k=1:n
    filename = ['E:\SpeechData\New\EN_train_f\',finf(k).name];        %构造第k个文件的位置（合并文件路径和文件名）
    [d,sr] = audioread(filename);
    % 以下为特征提取部分
    % VAD pre-processing
    [vs,zo] = vadsohn(d,sr);
    d_nozero = d(1:length(vs));
    d_nozero(vs==0) = [];            %去掉silence部分
    if(isempty(d_nozero))
        continue
    end
%     d_nozero = envexpand(d_nozero,fb);
    % Calculate 12th order PLP features without RASTA
    [cep, ~] = rastaplp(d_nozero, sr, 0, 12);
    del = deltas(cep);
    ddel = deltas(deltas(cep,5),5);
    cepDpDD = [cep',del',ddel'];
    [ MFCCs, ~, ~ ] =  melfcc( d_nozero, sr,'lifterexp', L,'nbands', M,'maxfreq', maxfreq, 'sumpower', 0,'fbtype', 'htkmel','dcttype', 3);    MFCC_d = deltas(MFCCs);
    MFCC_dd = deltas(deltas(MFCCs,5),5);
    MFCCDpDD = [MFCCs',MFCC_d',MFCC_dd'];
    % 特征提取结束
    if(isempty(MFCCs))
        continue
    end
    % 将每一帧特征都放在一个特征矩阵里
    [~,col_num] = size(cep);
%     names = repmat(finf(k).name,col_num,1);% 同一语音文件的不同帧用同一个文件名
    lables = repmat('en_f',col_num,1);          % 性别标签
    lables_sets = [lables_sets; lables];% 每行为一段新的语音的特征
    cepDpDD_sets = [cepDpDD_sets; cepDpDD];
    MFCCs_sets = [MFCCs_sets; MFCCDpDD];
end


finf = dir('E:\SpeechData\New\CH_train_m\*.wav');  %根据文件夹中的文件格式，选择读取类型，如.jpg、.mat等。
                                                       %其中finf是一个结构体数组，包含的dataset下所有mat文件
                                                       %的名称、修改时间大小、是否文件夹等属性。
n = length(finf);
parfor k=1:n
    filename = ['E:\SpeechData\New\CH_train_m\',finf(k).name];        %构造第k个文件的位置（合并文件路径和文件名）
    [d,sr] = audioread(filename);
    % 以下为特征提取部分
    % VAD pre-processing
    [vs,zo] = vadsohn(d,sr);
    d_nozero = d(1:length(vs));
    d_nozero(vs==0) = [];            %去掉silence部分
    if(isempty(d_nozero))
        continue
    end
%     d_nozero = envexpand(d_nozero,fb);
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
    % 将每一帧特征都放在一个特征矩阵里
    [~,col_num] = size(cep);
%     names = repmat(finf(k).name,col_num,1);% 同一语音文件的不同帧用同一个文件名
    lables = repmat('cn_m',col_num,1);          % 性别标签
    lables_sets = [lables_sets; lables];% 每行为一段新的语音的特征
    cepDpDD_sets = [cepDpDD_sets; cepDpDD];
    MFCCs_sets = [MFCCs_sets; MFCCDpDD];
end


finf = dir('E:\SpeechData\New\CH_train_f\*.wav');  %根据文件夹中的文件格式，选择读取类型，如.jpg、.mat等。
                                                       %其中finf是一个结构体数组，包含的dataset下所有mat文件
                                                       %的名称、修改时间大小、是否文件夹等属性。

n = length(finf);
parfor k=1:n
    filename = ['E:\SpeechData\New\CH_train_f\',finf(k).name];        %构造第k个文件的位置（合并文件路径和文件名）
    [d,sr] = audioread(filename);
    % 以下为特征提取部分
    % VAD pre-processing
    [vs,zo] = vadsohn(d,sr);
    d_nozero = d(1:length(vs));
    d_nozero(vs==0) = [];            %去掉silence部分
    if(isempty(d_nozero))
        continue
    end
%     d_nozero = envexpand(d_nozero,fb);
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
    % 将每一帧特征都放在一个特征矩阵里
    [~,col_num] = size(cep);
%     names = repmat(finf(k).name,col_num,1);% 同一语音文件的不同帧用同一个文件名
    lables = repmat('cn_f',col_num,1);          % 性别标签
    lables_sets = [lables_sets; lables];% 每行为一段新的语音的特征
    cepDpDD_sets = [cepDpDD_sets; cepDpDD];
    MFCCs_sets = [MFCCs_sets; MFCCDpDD];
end
% delete(poolobj);
% make columns
datacolumns1 = {'MFCC1','MFCC2','MFCC3','MFCC4','MFCC5','MFCC6',...
               'MFCC7','MFCC8','MFCC9','MFCC10','MFCC11','MFCC12','MFCC13',...
               'MFCC1_d','MFCC2_d','MFCC3_d','MFCC4_d','MFCC5_d','MFCC6_d',...
               'MFCC7_d','MFCC8_d','MFCC9_d','MFCC10_d','MFCC11_d','MFCC12_d','MFCC13_d',...
               'MFCC1_dd','MFCC2_dd','MFCC3_dd','MFCC4_dd','MFCC5_dd','MFCC6_dd','MFCC7_dd',...
               'MFCC8_dd','MFCC9_dd','MFCC10_dd','MFCC11_dd','MFCC12_dd','MFCC13_dd',...
               'label'};
            
datacolumns2 = {'PLP1','PLP2','PLP3','PLP4','PLP5','PLP6',...
               'PLP7','PLP8','PLP9','PLP10','PLP11','PLP12','PLP13',...
               'PLP_d1','PLP_d2','PLP_d3','PLP_d4','PLP_d5','PLP_d6',...
               'PLP_d7','PLP_d8','PLP_d9','PLP_d10','PLP_d11','PLP_d12','PLP_d13',...
               'PLP_dd1','PLP_dd2','PLP_dd3','PLP_dd4','PLP_dd5','PLP_dd6',...
               'PLP_dd7','PLP_dd8','PLP_dd9','PLP_dd10','PLP_dd11','PLP_dd12','PLP_dd13',...
               'label'};
            
% datacolumns3 = {'PLP_d1','PLP_d2','PLP_d3','PLP_d4','PLP_d5','PLP_d6',...
%                'PLP_d7','PLP_d8','PLP_d9','PLP_d10','PLP_d11','PLP_d12','PLP_d13','label'};
            
% datacolumns4 = {'PLP_dd1','PLP_dd2','PLP_dd3','PLP_dd4','PLP_dd5','PLP_dd6',...
%                'PLP_dd7','PLP_dd8','PLP_dd9','PLP_dd10','PLP_dd11','PLP_dd12','PLP_dd13','label'};
% datacolumns = {'MFCC1','MFCC2','MFCC3','MFCC4','MFCC5','MFCC6',...
%                'MFCC7','MFCC8','MFCC9','MFCC10','MFCC11','MFCC12','MFCC13',...
%                'PLP_cep1','PLP_cep2','PLP_cep3','PLP_cep4','PLP_cep5','PLP_cep6',...
%                'PLP_cep7','PLP_cep8','PLP_cep9','PLP_cep10','PLP_cep11','PLP_cep12','PLP_cep13',...
%                'PLP_d1','PLP_d2','PLP_d3','PLP_d4','PLP_d5','PLP_d6',...
%                'PLP_d7','PLP_d8','PLP_d9','PLP_d10','PLP_d11','PLP_d12','PLP_d13',...
%                'PLP_dd1','PLP_dd2','PLP_dd3','PLP_dd4','PLP_dd5','PLP_dd6',...
%                'PLP_dd7','PLP_dd8','PLP_dd9','PLP_dd10','PLP_dd11','PLP_dd12','PLP_dd13',...
%                'lable'};

% creat 4 table to store the features
MFCC_data = table(MFCCs_sets(:,1),MFCCs_sets(:,2),MFCCs_sets(:,3),MFCCs_sets(:,4),MFCCs_sets(:,5),MFCCs_sets(:,6),...
    MFCCs_sets(:,7),MFCCs_sets(:,8),MFCCs_sets(:,9),MFCCs_sets(:,10),MFCCs_sets(:,11),MFCCs_sets(:,12),MFCCs_sets(:,13),...
    MFCCs_sets(:,14),MFCCs_sets(:,15),MFCCs_sets(:,16),MFCCs_sets(:,17),MFCCs_sets(:,18),MFCCs_sets(:,19),MFCCs_sets(:,20),MFCCs_sets(:,21),...
    MFCCs_sets(:,22),MFCCs_sets(:,23),MFCCs_sets(:,24),MFCCs_sets(:,25),MFCCs_sets(:,26),MFCCs_sets(:,27),MFCCs_sets(:,28),MFCCs_sets(:,29),...
    MFCCs_sets(:,30),MFCCs_sets(:,31),MFCCs_sets(:,32),MFCCs_sets(:,33),MFCCs_sets(:,34),MFCCs_sets(:,35),MFCCs_sets(:,36),MFCCs_sets(:,37),...
    MFCCs_sets(:,38),MFCCs_sets(:,39),lables_sets,...
    'VariableNames',datacolumns1);

PLP_data = table(cepDpDD_sets(:,1),cepDpDD_sets(:,2),cepDpDD_sets(:,3),cepDpDD_sets(:,4),cepDpDD_sets(:,5),cepDpDD_sets(:,6),cepDpDD_sets(:,7),...
    cepDpDD_sets(:,8),cepDpDD_sets(:,9),cepDpDD_sets(:,10),cepDpDD_sets(:,11),cepDpDD_sets(:,12),cepDpDD_sets(:,13),...
    cepDpDD_sets(:,14),cepDpDD_sets(:,15),cepDpDD_sets(:,16),cepDpDD_sets(:,17),cepDpDD_sets(:,18),cepDpDD_sets(:,19),cepDpDD_sets(:,20),...
    cepDpDD_sets(:,21),cepDpDD_sets(:,22),cepDpDD_sets(:,23),cepDpDD_sets(:,24),cepDpDD_sets(:,25),cepDpDD_sets(:,26),...
    cepDpDD_sets(:,27),cepDpDD_sets(:,28),cepDpDD_sets(:,29),cepDpDD_sets(:,30),cepDpDD_sets(:,31),cepDpDD_sets(:,32),cepDpDD_sets(:,33),...
    cepDpDD_sets(:,34),cepDpDD_sets(:,35),cepDpDD_sets(:,36),cepDpDD_sets(:,37),cepDpDD_sets(:,38),cepDpDD_sets(:,39),lables_sets,...
    'VariableNames',datacolumns2);

% dPLP_data = table(cepDpDD_sets(:,14),cepDpDD_sets(:,15),cepDpDD_sets(:,16),cepDpDD_sets(:,17),cepDpDD_sets(:,18),cepDpDD_sets(:,19),cepDpDD_sets(:,20),...
%     cepDpDD_sets(:,21),cepDpDD_sets(:,22),cepDpDD_sets(:,23),cepDpDD_sets(:,24),cepDpDD_sets(:,25),cepDpDD_sets(:,26),lables_sets,'VariableNames',datacolumns3);

% ddPLP_data = table(cepDpDD_sets(:,27),cepDpDD_sets(:,28),cepDpDD_sets(:,29),cepDpDD_sets(:,30),cepDpDD_sets(:,31),cepDpDD_sets(:,32),cepDpDD_sets(:,33),...
%     cepDpDD_sets(:,34),cepDpDD_sets(:,35),cepDpDD_sets(:,36),cepDpDD_sets(:,37),cepDpDD_sets(:,38),cepDpDD_sets(:,39),lables_sets,'VariableNames',datacolumns4);

% data = table(MFCCs_sets(:,1),MFCCs_sets(:,2),MFCCs_sets(:,3),MFCCs_sets(:,4),MFCCs_sets(:,5),MFCCs_sets(:,6),...
%     MFCCs_sets(:,7),MFCCs_sets(:,8),MFCCs_sets(:,9),MFCCs_sets(:,10),MFCCs_sets(:,11),MFCCs_sets(:,12),MFCCs_sets(:,13),...
%     cepDpDD_sets(:,1),cepDpDD_sets(:,2),cepDpDD_sets(:,3),cepDpDD_sets(:,4),cepDpDD_sets(:,5),cepDpDD_sets(:,6),cepDpDD_sets(:,7),...
%     cepDpDD_sets(:,8),cepDpDD_sets(:,9),cepDpDD_sets(:,10),cepDpDD_sets(:,11),cepDpDD_sets(:,12),cepDpDD_sets(:,13),...
%     cepDpDD_sets(:,14),cepDpDD_sets(:,15),cepDpDD_sets(:,16),cepDpDD_sets(:,17),cepDpDD_sets(:,18),cepDpDD_sets(:,19),cepDpDD_sets(:,20),...
%     cepDpDD_sets(:,21),cepDpDD_sets(:,22),cepDpDD_sets(:,23),cepDpDD_sets(:,24),cepDpDD_sets(:,25),cepDpDD_sets(:,26),...
%     cepDpDD_sets(:,27),cepDpDD_sets(:,28),cepDpDD_sets(:,29),cepDpDD_sets(:,30),cepDpDD_sets(:,31),cepDpDD_sets(:,32),cepDpDD_sets(:,33),...
%     cepDpDD_sets(:,34),cepDpDD_sets(:,35),cepDpDD_sets(:,36),cepDpDD_sets(:,37),cepDpDD_sets(:,38),cepDpDD_sets(:,39),...
%     lables_sets,'VariableNames',datacolumns);
tts('醒醒，特征提取完了','Microsoft Huihui Desktop');
writetable(MFCC_data, 'MFCCs.csv');
% 0.8513 m 5db
% 0.9897 f 5db