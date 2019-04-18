% Demo4: Fault detection and fault diagnosis for TE process using DKPCA
% X: training samples
% Y: test samples

%%%%%%%%%%%%%%%%%%%%%%%%%%     DKPCA       %%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Improve the performance by adjusting the following parameters:
% 1. sigma  % kernel width
% 2. pcr    % principal contribution rate
% 3. lag    % time lag
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
model = kpca_train(X,'type',2,'sigma',800,'lag',2,'fd',1);

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
