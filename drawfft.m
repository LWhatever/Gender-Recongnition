function [Spec,freq] = drawfft(y,fs)
% Spec -- half spectrum of FFT result
L = length(y);
freq=fs*(0:L/2)/L;
F=fft(y);
F = abs(F/L);
Spec = F(1:floor(L/2)+1);
Spec(2:end-1) = 2*Spec(2:end-1);
plot(freq,Spec);
title('Spectrum');
xlabel('frequency/Hz');
ylabel('Amplitude');