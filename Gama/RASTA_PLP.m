% batch processing
% MFCCs、PLP features
finf = dir('E:\SpeechData\New\EN_train_m\*.wav');  %根据文件夹中的文件格式，选择读取类型，如.jpg、.mat等。
                                                       %其中finf是一个结构体数组，包含的dataset下所有mat文件
                                                       %的名称、修改时间大小、是否文件夹等属性。
lables_sets1 = [];
lables_sets2 = [];
lables_sets3 = [];
lables_sets4 = [];
cepDpDD_sets1 = [];
cepDpDD_sets2 = [];
cepDpDD_sets3 = [];
cepDpDD_sets4 = [];
n = length(finf);
% poolobj = parpool('local',2);
parfor k=1:n
    filename = ['E:\SpeechData\New\EN_train_m\',finf(k).name];        %构造第k个文件的位置（合并文件路径和文件名）
    [d,sr] = audioread(filename);
    
    % 以下为特征提取部分
    % VAD pre-processing
    [vs,zo] = vadsohn(d,sr);
    d_nozero = d(1:length(vs));
    d_nozero(vs==0) = [];            %去掉silence部分
    if(isempty(d_nozero))
        continue
    end
    % Calculate 12th order PLP features without RASTA
    [cep, ~] = rastaplp(d_nozero, sr, 1, 12);
    del = deltas(cep);
    ddel = deltas(deltas(cep,5),5);
    cepDpDD = [cep',del',ddel'];
    % 将每一帧特征都放在一个特征矩阵里
    [~,col_num] = size(cep);
    lables = repmat('en_m',col_num,1);          % 性别标签
    lables_sets1 = [lables_sets1; lables];% 每行为一段新的语音的特征
    cepDpDD_sets1 = [cepDpDD_sets1; cepDpDD];
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
    % Calculate 12th order PLP features without RASTA
    [cep, ~] = rastaplp(d_nozero, sr, 1, 12);
    del = deltas(cep);
    ddel = deltas(deltas(cep,5),5);
    cepDpDD = [cep',del',ddel'];
    % 将每一帧特征都放在一个特征矩阵里
    [~,col_num] = size(cep);
    lables = repmat('en_f',col_num,1);          % 性别标签
    lables_sets2 = [lables_sets2; lables];% 每行为一段新的语音的特征
    cepDpDD_sets2 = [cepDpDD_sets2; cepDpDD];
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
    % Calculate 12th order PLP features without RASTA
    [cep, ~] = rastaplp(d_nozero, sr, 1, 12);
    del = deltas(cep);
    ddel = deltas(deltas(cep,5),5);
    cepDpDD = [cep',del',ddel'];
    % 将每一帧特征都放在一个特征矩阵里
    [~,col_num] = size(cep);
%     names = repmat(finf(k).name,col_num,1);% 同一语音文件的不同帧用同一个文件名
    lables = repmat('cn_m',col_num,1);          % 性别标签
    lables_sets3 = [lables_sets3; lables];% 每行为一段新的语音的特征
    cepDpDD_sets3 = [cepDpDD_sets3; cepDpDD];
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
    % Calculate 12th order PLP features without RASTA
    [cep, ~] = rastaplp(d_nozero, sr, 1, 12);
    del = deltas(cep);
    ddel = deltas(deltas(cep,5),5);
    cepDpDD = [cep',del',ddel'];
    % 将每一帧特征都放在一个特征矩阵里
    [~,col_num] = size(cep);
%     names = repmat(finf(k).name,col_num,1);% 同一语音文件的不同帧用同一个文件名
    lables = repmat('cn_f',col_num,1);          % 性别标签
    lables_sets4 = [lables_sets4; lables];% 每行为一段新的语音的特征
    cepDpDD_sets4 = [cepDpDD_sets4; cepDpDD];
end
delete(poolobj);
% make columns
            
datacolumns2 = {'RPLP_cep1','RPLP_cep2','RPLP_cep3','RPLP_cep4','RPLP_cep5','RPLP_cep6',...
               'RPLP_cep7','RPLP_cep8','RPLP_cep9','RPLP_cep10','RPLP_cep11','RPLP_cep12','RPLP_cep13',...
               'RPLP_deltas1','RPLP_deltas2','RPLP_deltas3','RPLP_deltas4','RPLP_deltas5','RPLP_deltas6',...
               'RPLP_deltas7','RPLP_deltas8','RPLP_deltas9','RPLP_deltas10','RPLP_deltas11','RPLP_deltas12','RPLP_deltas13',...
               'RPLP_ddeltas1','RPLP_ddeltas2','RPLP_ddeltas3','RPLP_ddeltas4','RPLP_ddeltas5','RPLP_ddeltas6',...
               'RPLP_ddeltas7','RPLP_ddeltas8','RPLP_ddeltas9','RPLP_ddeltas10','RPLP_ddeltas11','RPLP_ddeltas12','RPLP_ddeltas13',...
               'label'};

% creat table to store the features

RASTA_PLP_data_em = table(cepDpDD_sets1(:,1),cepDpDD_sets1(:,2),cepDpDD_sets1(:,3),cepDpDD_sets1(:,4),cepDpDD_sets1(:,5),cepDpDD_sets1(:,6),cepDpDD_sets1(:,7),...
    cepDpDD_sets1(:,8),cepDpDD_sets1(:,9),cepDpDD_sets1(:,10),cepDpDD_sets1(:,11),cepDpDD_sets1(:,12),cepDpDD_sets1(:,13),...
    cepDpDD_sets1(:,14),cepDpDD_sets1(:,15),cepDpDD_sets1(:,16),cepDpDD_sets1(:,17),cepDpDD_sets1(:,18),cepDpDD_sets1(:,19),cepDpDD_sets1(:,20),...
    cepDpDD_sets1(:,21),cepDpDD_sets1(:,22),cepDpDD_sets1(:,23),cepDpDD_sets1(:,24),cepDpDD_sets1(:,25),cepDpDD_sets1(:,26),...
    cepDpDD_sets1(:,27),cepDpDD_sets1(:,28),cepDpDD_sets1(:,29),cepDpDD_sets1(:,30),cepDpDD_sets1(:,31),cepDpDD_sets1(:,32),cepDpDD_sets1(:,33),...
    cepDpDD_sets1(:,34),cepDpDD_sets1(:,35),cepDpDD_sets1(:,36),cepDpDD_sets1(:,37),cepDpDD_sets1(:,38),cepDpDD_sets1(:,39),lables_sets1,...
    'VariableNames',datacolumns2);
RASTA_PLP_data_ef = table(cepDpDD_sets2(:,1),cepDpDD_sets2(:,2),cepDpDD_sets2(:,3),cepDpDD_sets2(:,4),cepDpDD_sets2(:,5),cepDpDD_sets2(:,6),cepDpDD_sets2(:,7),...
    cepDpDD_sets2(:,8),cepDpDD_sets2(:,9),cepDpDD_sets2(:,10),cepDpDD_sets2(:,11),cepDpDD_sets2(:,12),cepDpDD_sets2(:,13),...
    cepDpDD_sets2(:,14),cepDpDD_sets2(:,15),cepDpDD_sets2(:,16),cepDpDD_sets2(:,17),cepDpDD_sets2(:,18),cepDpDD_sets2(:,19),cepDpDD_sets2(:,20),...
    cepDpDD_sets2(:,21),cepDpDD_sets2(:,22),cepDpDD_sets2(:,23),cepDpDD_sets2(:,24),cepDpDD_sets2(:,25),cepDpDD_sets2(:,26),...
    cepDpDD_sets2(:,27),cepDpDD_sets2(:,28),cepDpDD_sets2(:,29),cepDpDD_sets2(:,30),cepDpDD_sets2(:,31),cepDpDD_sets2(:,32),cepDpDD_sets2(:,33),...
    cepDpDD_sets2(:,34),cepDpDD_sets2(:,35),cepDpDD_sets2(:,36),cepDpDD_sets2(:,37),cepDpDD_sets2(:,38),cepDpDD_sets2(:,39),lables_sets2,...
    'VariableNames',datacolumns2);
RASTA_PLP_data_cm = table(cepDpDD_sets3(:,1),cepDpDD_sets3(:,2),cepDpDD_sets3(:,3),cepDpDD_sets3(:,4),cepDpDD_sets3(:,5),cepDpDD_sets3(:,6),cepDpDD_sets3(:,7),...
    cepDpDD_sets3(:,8),cepDpDD_sets3(:,9),cepDpDD_sets3(:,10),cepDpDD_sets3(:,11),cepDpDD_sets3(:,12),cepDpDD_sets3(:,13),...
    cepDpDD_sets3(:,14),cepDpDD_sets3(:,15),cepDpDD_sets3(:,16),cepDpDD_sets3(:,17),cepDpDD_sets3(:,18),cepDpDD_sets3(:,19),cepDpDD_sets3(:,20),...
    cepDpDD_sets3(:,21),cepDpDD_sets3(:,22),cepDpDD_sets3(:,23),cepDpDD_sets3(:,24),cepDpDD_sets3(:,25),cepDpDD_sets3(:,26),...
    cepDpDD_sets3(:,27),cepDpDD_sets3(:,28),cepDpDD_sets3(:,29),cepDpDD_sets3(:,30),cepDpDD_sets3(:,31),cepDpDD_sets3(:,32),cepDpDD_sets3(:,33),...
    cepDpDD_sets3(:,34),cepDpDD_sets3(:,35),cepDpDD_sets3(:,36),cepDpDD_sets3(:,37),cepDpDD_sets3(:,38),cepDpDD_sets3(:,39),lables_sets3,...
    'VariableNames',datacolumns2);
RASTA_PLP_data_cf = table(cepDpDD_sets4(:,1),cepDpDD_sets4(:,2),cepDpDD_sets4(:,3),cepDpDD_sets4(:,4),cepDpDD_sets4(:,5),cepDpDD_sets4(:,6),cepDpDD_sets4(:,7),...
    cepDpDD_sets4(:,8),cepDpDD_sets4(:,9),cepDpDD_sets4(:,10),cepDpDD_sets4(:,11),cepDpDD_sets4(:,12),cepDpDD_sets4(:,13),...
    cepDpDD_sets4(:,14),cepDpDD_sets4(:,15),cepDpDD_sets4(:,16),cepDpDD_sets4(:,17),cepDpDD_sets4(:,18),cepDpDD_sets4(:,19),cepDpDD_sets4(:,20),...
    cepDpDD_sets4(:,21),cepDpDD_sets4(:,22),cepDpDD_sets4(:,23),cepDpDD_sets4(:,24),cepDpDD_sets4(:,25),cepDpDD_sets4(:,26),...
    cepDpDD_sets4(:,27),cepDpDD_sets4(:,28),cepDpDD_sets4(:,29),cepDpDD_sets4(:,30),cepDpDD_sets4(:,31),cepDpDD_sets4(:,32),cepDpDD_sets4(:,33),...
    cepDpDD_sets4(:,34),cepDpDD_sets4(:,35),cepDpDD_sets4(:,36),cepDpDD_sets4(:,37),cepDpDD_sets4(:,38),cepDpDD_sets4(:,39),lables_sets4,...
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
tts('Feature Extraction Complete','Microsoft Huihui Desktop');
% writetable(data, 'MFCCs_PLP.csv');
% 381138