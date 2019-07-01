function [diff]=difference(x,char)
if char==0
    A=x';
elseif char ==1
    A=x;
else
    A=x;
end
for i = 1:length(A(1,:))
    if i<3
        diff(:,i) = A(:,i+1)-A(:,i);
    elseif i> length(A(1,:))-3
        diff(:,i) = A(:,i)-A(:,i-1); 
    else
        diff(:,i) = -2*A(:,i-2)-A(:,i-1)+A(:,i+1)+2*A(:,i+2);
    end
end
    diff= diff/sqrt(10);
end