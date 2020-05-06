%{
    Examples for kernel function

    kernel = Kernel('type', 'gauss', 'width', 2);
    kernel = Kernel('type', 'exp', 'width', 2);
    kernel = Kernel('type', 'linear', 'offset', 0);
    kernel = Kernel('type', 'lapl', 'width', 2);
    kernel = Kernel('type', 'sigm', 'gamma', 0.1, 'offset', 0);
    kernel = Kernel('type', 'poly', 'degree', 2, 'offset', 0);

%}


clc
clear all
addpath(genpath(pwd))
x = rand(30, 5);
y = rand(30, 5);

kernelmatrix = cell(6, 1);
% compute kernel matrix using gaussian kernel function
kernel = Kernel('type', 'gauss', 'width', 2);
kernelmatrix{1, 1} = kernel.getKernelMatrix(x, y);

% compute kernel matrix using exponential kernel function
kernel = Kernel('type', 'exp', 'width', 2);
kernelmatrix{2, 1} = kernel.getKernelMatrix(x, y);

% compute kernel matrix using linear kernel function
kernel = Kernel('type', 'linear', 'offset', 0);
kernelmatrix{3, 1} = kernel.getKernelMatrix(x, y);

% compute kernel matrix using laplacian kernel function
kernel = Kernel('type', 'lapl', 'width', 2);
kernelmatrix{4, 1} = kernel.getKernelMatrix(x, y);

% compute kernel matrix using sigmoid kernel function
kernel = Kernel('type', 'sigm', 'gamma', 0.01, 'offset', 0);
kernelmatrix{5, 1} = kernel.getKernelMatrix(x, y);

% compute kernel matrix using polynomial kernel function
kernel = Kernel('type', 'poly', 'degree', 2, 'offset', 0);
kernelmatrix{6, 1} = kernel.getKernelMatrix(x, y);

