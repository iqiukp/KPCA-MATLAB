classdef KernelGaussian < KernelBase
   methods
       function kernelmatrix = getKernelMatrix(~, obj, x, y)
           % compute the kernel matrix based on gaussian kernel function
           sx = sum(x.^2, 2);
           sy = sum(y.^2, 2);
           xy = 2*x*y';
           kernelmatrix = exp((bsxfun(@minus, bsxfun(@minus, xy, sx), sy'))...
               /obj.width^2);
       end
   end
end 