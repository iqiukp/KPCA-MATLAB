%{
    Demonstration of dimensionality reduction using KPCA.
%}
clc
clear all
close all
addpath(genpath(pwd))

load('.\data\helix.mat', 'data')
kernel = Kernel('type', 'gaussian', 'gamma', 2);
parameter = struct('numComponents', 2, ...
                   'kernelFunc', kernel);
% build a KPCA object
kpca = KernelPCA(parameter);
% train KPCA model
kpca.train(data);

%　mapping data
mappingData = kpca.score;

% Visualization
kplot = KernelPCAVisualization();
% visulize the mapping data
kplot.score(kpca)

