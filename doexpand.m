% doexpand
% script to do the envelope expansion
% assume the envelopes are columns of A
nu = 2;
%alpha =
% disp 'computing expansion parameters'
AN = (sum(A'))' ./nbands;
AK = (sum(A))' ./length(A);
AA = sum(AK) ./nbands;
gamma = zeros(size(AN));
for i = 1:nbands
    gamma = gamma + ((A(:,i)-AN).^2) ./nbands;
end
gamma = gamma .^ (0.5);
Akn = ((1 ./ gamma)* AK') * alpha * nbands / AA .* alpha ./ (2.5*12);
Skn1 = (Akn ./ A) .^ nu;
A = A ./ ( Skn1 + 1 );
clear AN AK AA gamma i Akn Skn1