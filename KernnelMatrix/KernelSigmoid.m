classdef KernelSigmoid < KernelBase
    methods
        function kernelmatrix = getKernelMatrix(~, obj, x, y)
            % compute the kernel matrix based on sigmoid kernel function
            kernelmatrix = tanh(obj.gamma*x*y'+obj.offset);
        end
    end
end