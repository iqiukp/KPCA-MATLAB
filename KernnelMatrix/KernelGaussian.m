classdef KernelGaussian < KernelBase
   methods
       function kernelmatrix = getKernelMatrix(~, obj, x, y)
        %{

        DESCRIPTION
            compute the kernel matrix based on gaussian kernel function

                kernelMatrix = getKernelMatrix(~, obj, x, y)
           
        %}
           
           % check the input value
           if isempty(obj.parameter)
               obj.parameter.width = 2;
           else
               parameterName = fieldnames(obj.parameter);
               [widthExist, ~] = ismember('width', parameterName);
               if ~widthExist
                   obj.parameter.width = 2; % default
               end
           end
           
           % compute kernel function matrix
           sx = sum(x.^2, 2);
           sy = sum(y.^2, 2);
           xy = 2*x*y';
           kernelmatrix = exp((bsxfun(@minus, bsxfun(@minus, xy, sx), sy'))...
               /obj.parameter.width^2);
       end
   end
end 