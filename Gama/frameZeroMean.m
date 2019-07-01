function frameMat = frameZeroMean(frameMat, order);
% frameZeroMean: Make a frame zero mean by using polyfit
%	Usage: frameMat = frameZeroMean(frameMat, order);
%			frameMat: a column vector of a frame, or a matrix where each column is a frame
%			order: order of polyfit (0 for DC, 1 for line, 2 for quadratic, etc)
%	This function is usually used before computing volume, hod, etc. 
%
%	For example:
%		waveFile='star_noisy.wav';
%		[y, fs, nbits]=wavReadInt(waveFile);
%		subplot(2,1,1); plot(y); title('Original'); grid on
%		epdParam=epdParamSet(fs);
%		frameMat=buffer2(y, epdParam.frameSize, epdParam.overlap);
%		order=0;
%		frameMat2=frameZeroMean(frameMat, order);
%		y2=frameMat2(:);
%		subplot(2,1,2); plot(y2); title('Order=0'); grid on

%	Roger Jang, 20041223, 20070417

if nargin<1, selfdemo; return; end
if nargin<2, order=2; end

[frameSize, frameNum]=size(frameMat);

for i=1:frameNum
	frameMat(:,i)=frameMat(:,i)-polyval(polyfit((1:frameSize)', frameMat(:,i), order), (1:frameSize)');
end

% ====== Self demo
function selfdemo
waveFile='star_noisy.wav';
[y, fs, nbits]=wavReadInt(waveFile);
subplot(4,1,1); plot(y); title('Original');
epdParam=epdParamSet(fs);
frameMat=buffer2(y, epdParam.frameSize, epdParam.overlap);
order=0;
frameMat2=frameZeroMean(frameMat, order);
y2=frameMat2(:);
subplot(4,1,2); plot(y2); title('Order=0');
order=1;
frameMat2=frameZeroMean(frameMat, order);
y2=frameMat2(:);
subplot(4,1,3); plot(y2); title('Order=1');
order=2;
frameMat2=frameZeroMean(frameMat, order);
y2=frameMat2(:);
subplot(4,1,4); plot(y2); title('Order=2');