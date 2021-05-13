%{
    Demonstration of computing the kernel function matrix.
%}

clc
clear all
close all
addpath(genpath(pwd))

% data
X = rand(33, 2);
Y = rand(23, 2);

% kernel setting
kernel1 = Kernel('type', 'gaussian', 'gamma', 0.01);
kernel2 = Kernel('type', 'polynomial', 'degree', 3);
kernel3 = Kernel('type', 'linear');
kernel4 = Kernel('type', 'sigmoid', 'gamma', 0.01);
kernel5 = Kernel('type', 'laplacian', 'gamma', 0.1);

% compute the kernel function matrix
matrix{1} = kernel1.computeMatrix(X, Y);
matrix{2} = kernel2.computeMatrix(X, Y);
matrix{3} = kernel3.computeMatrix(X, Y);
matrix{4} = kernel4.computeMatrix(X, Y);
matrix{5} = kernel5.computeMatrix(X, Y);