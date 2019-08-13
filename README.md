# 性别识别软件使用说明

## 环境建立
- 将主目录下的rastamat工具箱和sap-voicebox工具箱添加到MATLAB路径中
- 将主目录下Gama文件夹添加到MATLAB路径
- 需要MATLAB2018b或者MATLAB Runtime9.4

## 使用方法
- 环境建立后，双击运行*Gender_Recognition.mlapp*
- 或者在MATLAB中打开运行

## 代码结构
### 顶层文件：Gender_Recognition.mlapp
### 调用文件：
- GFCC_result.m 基于GMM的GFCC，其中输出参数result为返回结果（0表示识别结果为女，1为男）,输入参数x1为经过预处理和vad的语音信号，fs为采样率，GMM_chinese是GMM模型
- GFCC.m 用于提取GFCC特征
- lmultigauss.m 用于计算输入特征在模型中的可能性，输出是一个负值，直接与另外一个输出比较大小即可。
- PLP_result.m  基于GMM的PLP，其中输出参数result为返回结果（0表示识别结果为女，1为男）,输入参数x1为经过预处理和vad的语音信号，fs为采样率，GMM_chinese是GMM模型
- rastaplp.m 用于提取PLP特征
- deltas.m 用于提取差分特征
- lmultigauss.m 用于计算输入特征在模型中的可能性，输出是一个负值，直接与另外一个输出比较大小即可。
- gender_pitch.m 基于pitch的性别识别，分类器为拟合高斯模型，输入YY为语音信号，Fs为采样率，输出1表示男性，0表示女性。
- shrp.m用于语音基音频率的提取，输出的是一段语音中每一帧对应的基音频率，如果某一帧没有基音频率，则得到的结果为0。
- fbankmake.m 生成RASTA滤波器组

### 其他文件说明：
- save文件夹下的文件为python生成的分类器模型, 被test.py调用
- Gama文件夹下保存了GFCC的特征提取、分类模型
- special thanks to   [RASTA-PLP](https://labrosa.ee.columbia.edu/matlab/rastamat/)  
    @misc{Ellis05-rastamat,
          Author = {Daniel P. W. Ellis},
          Year = {2005},
          Title = {{PLP} and {RASTA} (and {MFCC}, and inversion) in {M}atlab},
          Url = {http://www.ee.columbia.edu/~dpwe/resources/matlab/rastamat/},
          Note = {online web resource}}

[sap-voicebox](https://github.com/ImperialCollegeLondon/sap-voicebox)
