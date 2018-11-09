% Demo2: Fault detection
% X: training samples
% Y: test samples

% Improve the performance of fault detection by adjusting parameters
% 1. options.sigma = 16;   % kernel width
% 2. options.beta          % corresponding probabilities 
% 3. options.cpc  ;        % principal contribution rate


% ---------------------------------------------------------------------%
clc
clear all
close all

addpath(genpath(pwd))

%
X = rand(200,10);
Y = rand(100,10);
Y(20:40,:) = rand(21,10)+3;
Y(60:80,:) = rand(21,10)*3;

% Normalization (if necessary)
% mu = mean(X);
% st = std(X);
% X = zscore(X);
% Y = bsxfun(@rdivide,bsxfun(@minus,Y,mu),st);

% Parameters setting
options.sigma = 16;   % kernel width
options.dims  = 2;   % output dimension
options.type  = 1;   % 0:dimensionality reduction or feature extraction
                     % 1:fault detection
options.beta  = 0.9; % corresponding probabilities (for ault detection)
options.cpc  = 0.85; % principal contribution rate (for ault detection)

% Train KPCA model
model = kpca_train(X,options);

% Test a new sample Y (vector of matrix)
[SPE,T2,mappedY] = kpca_test(model,Y);

% Plot the result
plotResult(model.SPE_limit,SPE);
plotResult(model.T2_limit,T2);
