% Demo2: Fault detection
% X: training samples
% Y: test samples

% Improve the performance of fault detection by adjusting parameters
% 1. options.sigma = 16;   % kernel width
% 2. options.beta          % corresponding probabilities 
% 3. options.pcr  ;        % principal contribution rate


% ---------------------------------------------------------------------%
clc
clear all
close all

addpath(genpath(pwd))

% Training data and Test data
X = rand(200,10);
Y = rand(100,10);
Y(20:40,:) = rand(21,10)+3;
Y(60:80,:) = rand(21,10)*3;

% Train KPCA model
model = kpca_train(X,'type',1,'sigma',60);

% Test a new sample Y (vector of matrix)
model = kpca_test(model,Y);

% Plot the result
plotResult(model.SPE_limit,model.SPE_test);
plotResult(model.T2_limit,model.T2_test);
