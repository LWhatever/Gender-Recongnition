function newcep = meanCeprmv(cep)
% mean ceptrum sub
cep_mean = mean(cep);
newcep = cep - cep_mean;