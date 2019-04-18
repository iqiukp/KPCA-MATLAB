function [K] = computeKM(x,y,sigma)
% DESCRIPTION
% Compute Kernel Matrix
% x: iuput samples (n1¡Ád)
% y: iuput samples (n2¡Ád)
% simga: kernel width
% n1,n2: number of iuput samples
% d: characteristic dimension of the samples
% K: kernelMatrix (n1¡Án2)
%
% Created on 18th April 2019, by Kepeng Qiu.
%-------------------------------------------------------------%

sx = sum(x.^2,2);
sy = sum(y.^2,2);
K = exp((bsxfun(@minus,bsxfun(@minus,2*x*y',sx),sy'))/sigma^2);
end