% Demo1: Dimensionality reduction or feature extraction using KPCA
% X: training samples
%
%%%%%%%%%%%%%%%%%%%%%%%%%%     KPCA       %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Improve the performance by adjusting the following parameters:
% 1. sigma  % kernel width
% 2. dims   % Dimensionality
% ---------------------------------------------------------------------%

clc
clear all
close all

addpath(genpath(pwd))

% 4 circles
load circledata
X = circledata;
figure
for i = 1:4
    scatter(X(1+250*(i-1):250*i,1),X(1+250*(i-1):250*i,2))
    hold on
end

% Train KPCA model
model = kpca_train(X,'type',0,'sigma',5,'dims',2);

% Visualize the result of dimensionality reduction
figure
for i = 1:4
    scatter(model.mappedX(1+250*(i-1):250*i,1), ... 
        model.mappedX(1+250*(i-1):250*i,2))
    hold on
end
