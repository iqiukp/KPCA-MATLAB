% Demo3: Fault detection and fault diagnosis for TE process
% X: training samples
% Y: test samples

% Improve the performance of fault detection by adjusting parameters
% 1. options.sigma = 800;   % kernel width
% 2. options.beta          % corresponding probabilities 
% 3. options.pcr  ;        % principal contribution rate
% ---------------------------------------------------------------------%

clc
clear all
close all
addpath(genpath(pwd))

% load TE process data
load train
load test

% Normalization 
[X, Y] = normalize(train,test);

% Train KPCA model
model = kpca_train(X,'type',1,'sigma',800,'fd',1);

% Test a new sample Y (vector of matrix)
model = kpca_test(model,Y);

% Plot the result
plotResult(model.SPE_limit,model.SPE_test);
plotResult(model.T2_limit,model.T2_test);

% Fault diagnosis
[CPs_T2_test_s, CPs_SPE_test_s] = CPsKPCA(X,Y,model, ... 
    'start_time',300,'end_time',500,'theta',0.7);

% Plot Contribution Plots
plotCPs(CPs_SPE_test_s)
plotCPs(CPs_T2_test_s)
