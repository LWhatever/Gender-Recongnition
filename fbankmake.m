% filterbank creation
% quarter octave filters
% spanning 6 octaves = 24 bands
nbands = 24;
fbanklen = 511;
fbank = zeros(fbanklen,nbands);
for i = nbands:-1:2
low = 2^(-i/4);
high = 2^(-(i-1)/4);
f = [low high];
fbank(:,(nbands-i+1)) = (fir1(fbanklen-1,f))';
end
fbank(:,24) = (fir1(fbanklen-1,high,'high'))';
lpflen = 127;
lpf = fir1(lpflen-1,(25/4000))';
clear m i low high f
save filterbank fbank nbands fbanklen lpf lpflen
% plot frequency response
% mm = fft(fbank,512);
% plot(20*log(abs(mm(1:256,:))))
% set(gca, 'xscale','log')