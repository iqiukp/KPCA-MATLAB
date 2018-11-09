% Demo1: dimensionality reduction or feature extraction 
% ---------------------------------------------------------------------%
clc
clear all
close all

addpath(genpath(pwd))

% 4 circles
load circledata

% 
X = circledata;
for i = 1:4
    scatter(X(1+250*(i-1):250*i,1),X(1+250*(i-1):250*i,2))
    hold on
end

% Parameters setting
options.sigma = 5;   % kernel width
options.dims  = 2;   % output dimension
options.type  = 0;   % 0:dimensionality reduction or feature extraction
                     % 1:fault detection
options.beta  = 0.9; % corresponding probabilities (for ault detection)
options.cpc  = 0.85; % Principal contribution rate (for ault detection)


% Train KPCA model
model = kpca_train(X,options);

figure
for i = 1:4
    scatter(model.mappedX(1+250*(i-1):250*i,1), ... 
        model.mappedX(1+250*(i-1):250*i,2))
    hold on
end
