classdef KernelLaplacian < KernelBase
   methods
       function kernelmatrix = getKernelMatrix(~, obj, x, y)
           % compute the kernel matrix based on laplacian kernel function
           sx = sum(x.^2, 2);
           sy = sum(y.^2, 2);
           xy = 2*x*y';
           kernelmatrix = exp(-sqrt(-(bsxfun(@minus,...
               bsxfun(@minus, xy, sx), sy')))/obj.width);
       end
   end
end 