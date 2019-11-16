%{

Examples for using Class KernnelMatrix

kernel = Kernel('type', 'gauss', 'width', 2);
kernel = Kernel('type', 'exp', 'width', 2);
kernel = Kernel('type', 'linear', 'offset', 0);
kernel = Kernel('type', 'lapl', 'width', 2);
kernel = Kernel('type', 'sigm', 'gamma', 0.1, 'offset', 0);
kernel = Kernel('type', 'poly', 'degree', 2, 'offset', 0);

%}

clc
clear class
addpath(genpath(pwd))
x = rand(20, 3);
y = rand(20, 3);

% compute kernel matrix using gaussian kernel function
kernel = Kernel('type', 'gauss', 'width', 2);
kernelmatrix1 = kernel.getKernelMatrix(x, y);

% compute kernel matrix using exponential kernel function
kernel = Kernel('type', 'exp', 'width', 2);
kernelmatrix2 = kernel.getKernelMatrix(x, y);

% compute kernel matrix using linear kernel function
kernel = Kernel('type', 'linear', 'offset', 0);
kernelmatrix3 = kernel.getKernelMatrix(x, y);

% compute kernel matrix using laplacian kernel function
kernel = Kernel('type', 'lapl', 'width', 2);
kernelmatrix4 = kernel.getKernelMatrix(x, y);

% compute kernel matrix using sigmoid kernel function
kernel = Kernel('type', 'sigm', 'gamma', 0.1, 'offset', 0);
kernelmatrix5 = kernel.getKernelMatrix(x, y);

% compute kernel matrix using polynomial kernel function
kernel = Kernel('type', 'poly', 'degree', 2, 'offset', 0);
kernelmatrix6 = kernel.getKernelMatrix(x, y);

