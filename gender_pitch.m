function result = gender_pitch(YY, Fs)
f = 8000;
yy = resample(YY, f, Fs);
yy = yy/max(abs(yy));
F0MinMax=[80 500];  frame_length=25;  timestep=10;  SHR_Threshold=0.2; 
ceiling=1250;   med_smooth=5;  CHECK_VOICING=1;
[~,f0_value,~,~]=shrp(yy,f,F0MinMax,frame_length,...
    timestep,SHR_Threshold,ceiling,med_smooth,CHECK_VOICING);
f0_value(find(f0_value<F0MinMax(1)))=0;
f0_value(find(f0_value>F0MinMax(2)))=0;
f0 = f0_value(f0_value~=0);
result = gauss1_dis_test(f0);
end

function result = gauss1_dis_test(X)
m_pitch = 125.3216;
f_pitch = 215.1373;
aver_f0 = mean(X);
if aver_f0>f_pitch
    result = 0;
elseif aver_f0<m_pitch
    result = 1;
else 
    result = -1;
end 
if (result==-1) 
    male_result = gauss1_m(X);
    female_result = gauss1_f(X);
    result = sum(male_result)>sum(female_result);
end
end
function result = gauss1_m(X)
%for new chinese speech library
c = 0.0166;
mu = 125.3216;
sigma = -23.9966;

%for old chinese speech library
% c = 0.1861/12.9107;
% mu = 128.9927;
% sigma = -27.6699;
result = c*exp(-(X-mu).^2/(2*sigma^2));
end
function result = gauss1_f(X)
%for new chinese speech library
c = 0.0100;
mu = 215.1373;
sigma = -40.6854;

%for old chinese speech library
% c = 0.0612/5.2221;
% mu = 235.3625;
% sigma = -34.0640;
result = c*exp(-(X-mu).^2/(2*sigma^2));
end