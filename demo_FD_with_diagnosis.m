
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

%{
fault diagnosis

Notice:  

 (1)     If you want to calculate CPS of a certain time, you should 
         set starting time equal to ending time. For example, 
         startingtime = 500, endingtime = 500.

 (2)     If you want to calculate the average CPS of a period of time,
         starting time and ending time should be set respectively. 
         For example startingtime = 300, endingtime = 500.
 
 (3)     The fault diagnosis module is only supported for gaussian 
         kernel function and it may still take a long time when 
         the number of the training data is large.

------------------------------------------------------------------------
%}
kpca.diagnose('start_time', 301, 'end_time', 500)

% Visualize the diagnosis results
Visualization.diagnose(kpca);




