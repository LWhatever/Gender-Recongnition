%vad method 2

% 设置音频源，读入一个speaker.wav文件，并对读入的文件进行分帧，每帧80个采样点
audioSource = dsp.AudioFileReader('SamplesPerFrame',80,...
                               'Filename','E:\课程\语音信号处理\Topic2\wav_m\arctic_a0001.wav',...
                               'OutputDataType', 'single');
 
% 设置一个示波器，示波器的时间范围30S，正好等于读取的上面读取的文件的长度，有两个信号输入
scope = dsp.TimeScope(2,... 
                      'SampleRate', [8000/80 8000], ...
                      'BufferLength', 240000, ...
                      'YLimits', [-0.3 1.1], ...
                      'TimeSpan',length(d)/sr,...
                      'ShowGrid', true, ...
                      'Title','Decision speech and speech data', ...
                      'TimeSpanOverrunAction','Scroll');
 
% 对VAD进行配置
VAD_cst_param = vadInitCstParams;
 
% clear vadG729
 
% 每帧数据长度10ms，计算3000帧 = 30S
numTSteps = floor(length(d)/sr/0.01);
while(numTSteps)
    
  % 从audioSource中读取一帧 = 10ms 的数据
  speech = audioSource();
  
  % 对数据进行VAD判断
  decision = vadG729(speech, VAD_cst_param);
 
  % 将读取的语音信号波形以及VAD判断结果显示在示波器上
  scope(decision, speech);
  numTSteps = numTSteps - 1;
end
release(scope);