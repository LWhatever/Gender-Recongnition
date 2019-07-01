function SNR = voiceSNR(d_n,sr)
% INPUT
%       d_n --voice with noise
%       sr  --sample rate
% OUTPUT
%       SNR
% Author:LZY
win = 0.025*sr;
frames = floor(length(d_n)/win);
% d_o_cut = d_o(1:frames*win);
d_n_cut = d_n(1:win*2);
noise_pow = sum(d_n_cut.^2)*frames/2;
sig_pow = sum(d_n.^2)-noise_pow;
SNR = 10*log10(sig_pow/noise_pow);