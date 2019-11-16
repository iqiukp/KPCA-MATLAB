%{
    Examples for fault detection based on DKPCA


    Notice:  
    
     (1)     Dynamic KPCA is spoported in this code. Just add a field named
             'timelag'. Shown as below:

                application = struct('type','faultdetection',...
                     'cumulativepercentage', 0.75,...
                     'significancelevel', 0.95,...
                     'timelag', 10);
%}

clc
clear all
close all
addpath(genpath(pwd))

% load the original process data of the TE process
load('.\data\teprocess.mat')

% normalization (in general, this step is important for fault detection)
[traindata, testdata] = normalize(traindata, testdata);

% create a parameter structure for the KPCA application
application = struct('type','faultdetection',...
                     'cumulativepercentage', 0.75,...
                     'significancelevel', 0.95,...
                     'timelag', 60);
 
% create an object for kernel function
kernel = Kernel('type', 'gauss', 'width', 800);

 
% create an object for kpca model
kpca = KpcaModel('application', application,...
                 'kernel', kernel);
% train kpca model
model = kpca.train(traindata);

% test KPCA model
testresult = kpca.test(model, testdata);

% visualize the testing results
plotTestResult(model.spelimit, testresult.spe, 'SPE');
plotTestResult(model.t2limit, testresult.t2, 'T2');


