function samples = envexpand(data,sr,ftbank)
% envelope expansion routine
% - use filterbank to split signal
% - use hilbert to extract envelope and excitation
% - expand envelope
% - recombine envelope with excitation
% - sum and scale

SSNR = voiceSNR(data,sr);
% loaded filterbank is loaded
% if ~exist('fbanklen')
% 	fbankmake
% % 	disp 'loading filters'
% 	load filterbank.mat
% end
fbank = ftbank.fbank;
fbanklen = ftbank.fbanklen;
lpf = ftbank.lpf;
lpflen = ftbank.lpflen;
nbands = ftbank.nbands;

% compute alpha
samples = data;
pwr = std(samples);
alpha = pwr/((10^(2*SSNR/20)+1)^0.5);

% filterbank the samples
channels = zeros(length(samples)+fbanklen-1,nbands);
for i = 1:nbands
	channels(:,i) = conv(samples,fbank(:,i));
end

% compute envelopes and excitations
chanhilb = hilbert(channels);
A = abs(chanhilb);
excit = cos(angle(chanhilb));
clear chanhilb

% expand the envelopes
doexpand

% low pass filter the expanded envelopes
B = zeros(length(A)+lpflen-1,nbands);
for i = 1:nbands
	B(:,i) = conv(A(:,i),lpf);
end
cut = (lpflen-1)/2;
[chm,~] = size(B);
A = B((cut+1):(chm-cut),:);
clear chm chn B i

% resynthesize
channels = A.*excit;
clear A excit
resynth = (sum(channels'))';

% adjust for delay and added samples due to convolution filter
cut = (fbanklen-1)/2;
[chm,chn] = size(resynth);
samples = resynth((cut+1):(chm-cut));
samples = exp(1-abs(samples)).*samples;
