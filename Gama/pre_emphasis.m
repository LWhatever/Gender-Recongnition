function y=pre_emphasis(x) 
pre_filter1=[1 0.9375];                 %1+0.97z^(-1),��ͨ�˲�����ϵ������Ϊ����
pre_filter2=1;                        %��ĸ
y = filter(pre_filter1,pre_filter2,x);%Ԥ����
end
