%{

    Examples for fault detection based on KPCA


    Notice:  
    
     (1)     You can use different kernel functions by creating different 
             kernel objects.
     (2)     Dynamic KPCA is spoported in this code. Just add a field named
             'timelag'. Shown as below:

                application = struct('type','faultdetection',...
                     'cumulativepercentage', 0.75,...
                     'significancelevel', 0.95,...
                     'timelag', 10);
                

     (3)     The module of fault diagnosis is closed by default. If you
             want to use this module, just add somes fields in the parameter 
             structure for the kpca application. For example:
             
             Defalut:
                application = struct('type','faultdetection',...
                     'cumulativepercentage', 0.75,...
                     'significancelevel', 0.95);

             Add fault diagnosis module:
                application = struct('type','faultdetection',...
                     'cumulativepercentage', 0.75,...
                     'significancelevel', 0.95,...
                     'faultdiagnosis','on',...
                     'diagnosisparameter', 0.7);
            
     (4)     The fault diagnosis module is only supported for gaussian 
             kernel function. Although this release has accelerated the 
             speed of fault diagnosis, it may still take a long time when 
             the number of the training data is large.
     
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
                     'significancelevel', 0.95);

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


