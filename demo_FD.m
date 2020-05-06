
%  Examples for fault detection based on KPCA
% --------------------------------------------------------------------

clc
clear all
close all
addpath(genpath(pwd))

% load the training data
load('.\data\teprocess.mat')
% kernel function
kernel = Kernel('type', 'gauss', 'width', 128);
% parameter setting
parameter = struct('application', 'fd', 'kernel', kernel);
% build a KPCA object
kpca = KernelPCA(parameter);
% train KPCA model
kpca.train(traindata);
% test KPCA model
kpca.test(testdata);
% Visualize the prediction
Visualization.prediction(kpca);



