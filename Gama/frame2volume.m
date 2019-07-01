function volume = frame2volume(frameMat, method, usePolyfit);
% frame2volume: Frame or frame matrix to volume conversion
%	Usage: volume = frame2volume(frameMat, method, usePolyfit)
%			frameMat: a column vector of a frame, or a matrix where each column is a frame
%			method: 1 for sum of abs, 2 for decibel
%			usePolyfit: 1 for using polyfit (degree 2), 0 for not using it
%
%	For example:
%		waveFile='lately2.wav';
%		[y, fs, nbits]=wavReadInt(waveFile);
%		frameSize=640; overlap=480;
%		frameMat=buffer2(y, frameSize, overlap);
%		frameNum=size(frameMat, 2);
%		volume1=frame2volume(frameMat, 1);
%		volume2=frame2volume(frameMat, 2);
%		time=(1:length(y))/fs;
%		frameTime=((0:frameNum-1)*(frameSize-overlap)+0.5*frameSize)/fs;
%		subplot(3,1,1); plot(time, y); axis tight; ylabel('Amplitude'); title(waveFile);
%		subplot(3,1,2); plot(frameTime, volume1, '.-'); axis tight; ylabel('Abs. sum');
%		subplot(3,1,3); plot(frameTime, volume2, '.-'); axis tight; ylabel('Decibels'); xlabel('Time (sec)');

%	Roger Jang, 20041223, 20070417

if nargin<1, selfdemo; return; end
if nargin<2, method=1; end
if nargin<3, usePolyfit=0; end

[frameSize, frameNum]=size(frameMat);

% Use polyfit
if usePolyfit
	for i=1:frameNum
		frameMat(:,i)=frameMat(:,i)-polyval(polyfit((1:frameSize)', frameMat(:,i), 2), (1:frameSize)');
	end
end

volume=zeros(1, frameNum);
switch method
	case 1
		for i=1:frameNum
			frame=frameMat(:,i);
			frame=frame-median(frame);
			volume(i)=sum(abs(frame));
		end
	case 2
		for i=1:frameNum
			frame=frameMat(:,i);
			frame=frame-mean(frame);
			squaredSum=sum(frame.^2)+realmin;	% add realmin to avoid log(0) warning
			volume(i)=10*log10(squaredSum);
		end
	otherwise
		error('Unknown method!');
end

% ====== Self demo
function selfdemo
waveFile='lately2.wav';
[y, fs, nbits]=wavReadInt(waveFile);
frameSize=640; overlap=480;
frameMat=buffer2(y, frameSize, overlap);
frameNum=size(frameMat, 2);
volume1=frame2volume(frameMat, 1);
volume2=frame2volume(frameMat, 2);
time=(1:length(y))/fs;
frameTime=((0:frameNum-1)*(frameSize-overlap)+0.5*frameSize)/fs;
subplot(3,1,1); plot(time, y); axis tight; ylabel('Amplitude'); title(waveFile);
subplot(3,1,2); plot(frameTime, volume1, '.-'); axis tight; ylabel('Abs. sum');
subplot(3,1,3); plot(frameTime, volume2, '.-'); axis tight; ylabel('Decibels'); xlabel('Time (sec)');