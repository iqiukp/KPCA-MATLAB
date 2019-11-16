classdef KernelPolynomial < KernelBase
    methods
        function kernelmatrix = getKernelMatrix(~, obj, x, y)
            % compute the kernel matrix based on polynomial kernel function
            kernelmatrix = (x*y'+obj.offset).^obj.degree;
        end
    end
end