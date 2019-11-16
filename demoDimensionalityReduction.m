%{

    Examples for dimensionality reduction based on KPCA

%}

clc
clear all
close all
addpath(genpath(pwd))

% load the training data
load('.\data\helix.mat')
traindata = helix;

% create a parameter structure for the KPCA application
application = struct('type','dimensionalityreduction',...
                     'dimensionality', 2);

% create an object for kernel function
kernel = Kernel('type', 'gauss', 'width', 24);

% create an object for kpca model
kpca = KpcaModel('application', application,...
                 'kernel', kernel);

% train KPCA model
model = kpca.train(traindata);

% get the mapping data
mappingdata = model.mappingdata;

% plot the mapping data (only support for 2D or 3D data)
plotMappingData(traindata, mappingdata);

