function [signal_out,f_axis] = signal_fft(signal_in,Fs) %�����źźͲ����ʣ��õ��źų���һ���fft����Լ���Ӧ��Ƶ����
y = fft(signal_in);                 %�������ź���fft,length(signal_in) 
signal_out = 2.*abs( y(1 : length(signal_in)/2 ));%����ת��
% signal_out = abs(y(1 : length(signal_in)));%����ת��
f_axis = (1:length(signal_in)/2)*Fs/length(signal_in);%�õ�Ƶ����
end