%vad method 2

% ������ƵԴ������һ��speaker.wav�ļ������Զ�����ļ����з�֡��ÿ֡80��������
audioSource = dsp.AudioFileReader('SamplesPerFrame',80,...
                               'Filename','E:\�γ�\�����źŴ���\Topic2\wav_m\arctic_a0001.wav',...
                               'OutputDataType', 'single');
 
% ����һ��ʾ������ʾ������ʱ�䷶Χ30S�����õ��ڶ�ȡ�������ȡ���ļ��ĳ��ȣ��������ź�����
scope = dsp.TimeScope(2,... 
                      'SampleRate', [8000/80 8000], ...
                      'BufferLength', 240000, ...
                      'YLimits', [-0.3 1.1], ...
                      'TimeSpan',length(d)/sr,...
                      'ShowGrid', true, ...
                      'Title','Decision speech and speech data', ...
                      'TimeSpanOverrunAction','Scroll');
 
% ��VAD��������
VAD_cst_param = vadInitCstParams;
 
% clear vadG729
 
% ÿ֡���ݳ���10ms������3000֡ = 30S
numTSteps = floor(length(d)/sr/0.01);
while(numTSteps)
    
  % ��audioSource�ж�ȡһ֡ = 10ms ������
  speech = audioSource();
  
  % �����ݽ���VAD�ж�
  decision = vadG729(speech, VAD_cst_param);
 
  % ����ȡ�������źŲ����Լ�VAD�жϽ����ʾ��ʾ������
  scope(decision, speech);
  numTSteps = numTSteps - 1;
end
release(scope);