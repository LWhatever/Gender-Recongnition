function [signal_out,f_axis] = signal_fft(signal_in,Fs) %输入信号和采样率，得到信号长度一般的fft输出以及对应的频率轴
y = fft(signal_in);                 %对输入信号做fft,length(signal_in) 
signal_out = 2.*abs( y(1 : length(signal_in)/2 ));%幅度转化
% signal_out = abs(y(1 : length(signal_in)));%幅度转化
f_axis = (1:length(signal_in)/2)*Fs/length(signal_in);%得到频率轴
end