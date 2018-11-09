function model = kpca_train(X,options)
% DESCRIPTION
% Kernel principal component analysis (KPCA)
%
%       mappedX = kpca_train(X,options)
%
% INPUT
%   X            Training samples (N*d)
%                N: number of samples
%                d: number of features
%   options      Parameters setting
%
% OUTPUT
%   model        KPCA model
%
%
% Created on 9th November, 2018, by Kepeng Qiu.



% number of training samples
L = size(X,1);

% Compute the kernel matrix
K = computeKM(X,X,options.sigma);

% Centralize the kernel matrix
unit = ones(L,L)/L;
K_c = K-unit*K-K*unit+unit*K*unit;

% Solve the eigenvalue problem
[V,D] = eigs(K_c/L);
lambda = diag(D);

% Normalize the eigenvalue
V_s = V ./ sqrt(L*lambda)';

% Compute the numbers of principal component


% Extract the nonlinear component
if options.type == 1 % fault detection
    dims = find(cumsum(lambda/sum(lambda)) >= 0.85,1, 'first');
else
    dims = options.dims;
end
mappedX  = K_c* V_s(:,1:dims) ;

% Store the results
model.mappedX =  mappedX ;
model.V_s = V_s;
model.lambda = lambda;
model.K_c = K_c;
model.L = L;
model.dims = dims;
model.X = X;
model.K = K;
model.unit = unit;
model.sigma = options.sigma;

% Compute the threshold
model.beta = options.beta;% corresponding probabilities
[SPE_limit,T2_limit] = comtupeLimit(model);
model.SPE_limit = SPE_limit;
model.T2_limit = T2_limit;

end