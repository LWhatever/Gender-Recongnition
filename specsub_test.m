[d,sr] = audioread(filename);figure;plot(d);
[d_n,~] = noisegen(d,0);figure;plot(d_n);
dd = specsub(d_n,sr);figure;plot(dd);
[vs,zo] = vadsohn(dd,sr);
d_nozero = dd(1:length(vs));
d_nozero(vs==0) = [];            %去掉silence部分
figure;plot(d_nozero);
% sound(d,sr)
% sound(d_n,sr)
% sound(dd,sr)
% sound(d_nozero,sr)