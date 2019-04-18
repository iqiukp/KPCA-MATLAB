function model = kpca_train(X,varargin)
% DESCRIPTION
% Kernel principal component analysis (KPCA)
%
%       model = kpca_train(X,varargin)
%
% INPUT
%   X            Training samples (N*d)
%                N: number of samples
%                d: number of features
%
% OUTPUT
%   model        KPCA model
%
%
% Created on 18th April 2019, by Kepeng Qiu.
%-------------------------------------------------------------%

% Default Parameters setting
options.sigma = 10;   % kernel width
options.dims  = 2;    % output dimension (dimensionality reduction)
                      % 2D data is easy to visualize
options.type  = 0;    % 0: dimensionality reduction or feature extraction
                      % 1: fault detection using KPCA
                      % 2: fault detection using dynamic KPCA(DKPCA)
options.beta  = 0.9;  % corresponding probabilities (for fault detection)
                      % 
options.pcr   = 0.65; % principal contribution rate (for fault detection)
options.fd    = 0;    % 0: No fault diagnosis (fd)
                      % 1: fault diagnosis (fd)
options.lag   = 4;    % time lag (for DKPCA)
%

if rem(nargin-1,2)
    error('Parameters to kpca_train should be pairs')
end
numParameters = (nargin-1)/2;

for n =1:numParameters
    Parameters = varargin{(n-1)*2+1};
    value	= varargin{(n-1)*2+2};
    switch Parameters
            %
        case 'type'
            options.type = value;
            %
        case 'dims'
            options.dims = value;
            %
        case 'sigma'
            options.sigma = value;
            %
        case 'fd'
            options.fd = value;
            %
        case 'lag'
            options.lag = value;
            %
        case 'pcr'
            options.pcr = value;
            %
        case 'beta'
            options.beta = value;
    end
end

% number of training samples
L = size(X,1);

% DPCA
if options.type == 2
    %  Construct the augmented matrix
    X = constructAM(X,options.lag);
    L = size(X,1);
    model.lag = options.lag; % time lag
end

% Compute the kernel matrix
K = computeKM(X,X,options.sigma);

% Centralize the kernel matrix
unit = ones(L,L)/L;
K_c = K-unit*K-K*unit+unit*K*unit;

% Solve the eigenvalue problem
[V,D] = eigs(K_c/L);
% [V,D] = eig(K_c/L);
lambda = diag(D);

% Normalize the eigenvalue
V_s = V ./ sqrt(L*lambda)';
%  Lower version of MATLAB may report an error at line 70,
%  please replace it with the following code.
% ------------------------------
% for i = 1:size(lambda,1)
%     V_s(:,i) = V(:,i)/sqrt(L*lambda(i,1));
% end
% ------------------------------

% Compute the numbers of principal component
if options.type  == 1 || options.type  == 2  % fault detection
    dims = find(cumsum(lambda/sum(lambda)) >= ...
        options.pcr,1, 'first');
else % dimensionality reduction or feature extraction
    dims = options.dims;
end

% Extract the nonlinear component
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
model.diagnosis = options.fd;
model.type = options.type;

% Compute the threshold for fault detection
if options.type  == 1 || options.type  == 2
    model.beta = options.beta; % corresponding probabilities
    [SPE_limit,T2_limit] = comtupeLimit(model);
    model.SPE_limit = SPE_limit;
    model.T2_limit = T2_limit;
end

end