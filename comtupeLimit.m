function [SPE_limit,T2_limit] = comtupeLimit(model)
% DESCRIPTION
% Compute the control limit of T2 statistic and SPE statistic
%
%       [SPE_limit,T2_limit] = comtupeLimit(model)
%
% INPUT
%   model       KPCA model
%
% OUTPUT
%   SPE_limit   the control limit of SPE statistic
%   T2_limit    the control limit of T2 statistic
%
% Created on 9th November, 2018, by Kepeng Qiu.


% Compute Hotelling's T2 statistic
% T2 = diag(model.mappedX/diag(model.lambda(1:model.dims))*model.mappedX');

% Compute the squared prediction error (SPE)
temp1 = model.K_c*model.V_s;
temp2 = model.K_c*model.V_s(:,1:model.dims);
SPE = sum(temp1.^2,2)-sum(temp2.^2 ,2);

% Compute the T2 limit (the Chi-square Distribution)
k = model.dims*(model.L-1)/(model.L-model.dims);
T2_limit = k *finv(model.beta,model.dims,model.L-model.dims);

% Compute the SPE limit (the Chi-square Distribution)
a = mean(SPE);
b = var(SPE);
g = b/2/a;
h = 2*a^2/b;
SPE_limit = g*chi2inv(model.beta,h);

end