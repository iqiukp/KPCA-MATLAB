%{
    Demonstration of fault detection and fault diagnosis using KPCA.
%}
clc
clear all
close all
addpath(genpath(pwd))

load('.\data\TE.mat', 'trainData', 'testData')
kernel = Kernel('type', 'gaussian', 'gamma', 1/128^2);

parameter = struct('numComponents', 0.65, ...
                   'kernelFunc', kernel,...
                   'diagnosis', [300, 500]);
               
% build a KPCA object
kpca = KernelPCA(parameter);
% train KPCA model
kpca.train(trainData);
% test KPCA model
results = kpca.test(testData);

% Visualization
kplot = KernelPCAVisualization();
kplot.cumContribution(kpca)
kplot.trainResults(kpca)
kplot.testResults(kpca, results)
kplot.diagnosis(results)