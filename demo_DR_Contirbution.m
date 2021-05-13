%{
    Demonstration of dimensionality reduction using KPCA.
%}
clc
clear all
close all
addpath(genpath(pwd))

load('.\data\TE.mat', 'trainData')
kernel = Kernel('type', 'gaussian', 'gamma', 1/128^2);

%% case 1
%{
    The number of components is determined by the given explained level.
    The given explained level should be 0 < explained level < 1.
    For example, when explained level is set to 0.75, the parameter should
    be set as:

    parameter = struct('numComponents', 0.75, ...
                       'kernelFunc', kernel);
%}
parameter = struct('numComponents', 0.75, ...
                   'kernelFunc', kernel);
% build a KPCA object
kpca = KernelPCA(parameter);
% train KPCA model
kpca.train(trainData);

% Visualization
kplot = KernelPCAVisualization();
kplot.cumContribution(kpca)

%% case 2
%{
    The number of components is determined by the given number.
    For example, when given number is set to 24, the parameter should
    be set as:

    parameter = struct('numComponents', 24, ...
                       'kernelFunc', kernel);
%}
parameter = struct('numComponents', 24, ...
                   'kernelFunc', kernel);
% build a KPCA object
kpca = KernelPCA(parameter);
% train KPCA model
kpca.train(trainData);

% Visualization
kplot = KernelPCAVisualization();
kplot.cumContribution(kpca)

