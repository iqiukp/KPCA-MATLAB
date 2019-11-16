classdef KernelLinear < KernelBase
    methods
        function kernelmatrix = getKernelMatrix(~, obj, x, y)
            % compute the kernel matrix based on linear kernel function
            kernelmatrix = x*y'+obj.offset;
        end
    end
end
