function [X_s, Y_s] = normalize(X,Y)
% DESCRIPTION
%  Normalization 
%
%       [X_s, Y_s] = normalize(X,Y)
%
% INPUT
%   X            Training samples (N*d)
%                N: number of samples
%                d: number of features
%   Y            Test samples (N*d)
%                N: number of samples
%                d: number of features
%
% OUTPUT
%   X_s          Normalizated X
%   Y_s          Normalizated Y
%
% Created on 18th April 2019, by Kepeng Qiu.
%-------------------------------------------------------------%

% normalize X
X_mu = mean(X);
X_std = std(X);
X_s = zscore(X);

% normalize Y by using the mean and standard deviation of X 
Y_s = bsxfun(@rdivide,bsxfun(@minus,Y,X_mu),X_std);

%  Lower version of MATLAB may report an error at line 27, 
%  please replace it with the following code.
% ---------------------------------------------
% mu_array = repmat( X_mu , size(Y,1) , 1 );
% st_array = repmat( X_std , size(Y,1) , 1 );
% Y_s = (Y-mu_array)./st_array;
% ----------------------------------------------

end