function frame_data = framing(signal, frame_len, noverlap)
len = length(signal);
frame_num = 1 + ceil((len - frame_len)/noverlap);
frame_data = zeros(frame_len, frame_num);
for i = 1:frame_num-1
    frame_data(:,i) = signal(noverlap*(i-1)+1:noverlap*(i-1)+frame_len);
end
rem = (frame_num-1)*noverlap+1;
com = frame_len - len + rem - 1;
frame_data(:,frame_num) = [signal(rem:end);zeros(com,1)];
end