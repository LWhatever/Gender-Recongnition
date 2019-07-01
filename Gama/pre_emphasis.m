function y=pre_emphasis(x) 
pre_filter1=[1 0.9375];                 %1+0.97z^(-1),高通滤波器的系数，作为分子
pre_filter2=1;                        %分母
y = filter(pre_filter1,pre_filter2,x);%预加重
end
