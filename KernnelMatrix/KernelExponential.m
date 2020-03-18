classdef KernelExponential < KernelBase
   methods
       function kernelmatrix = getKernelMatrix(~, obj, x, y)
        %{

        DESCRIPTION
            compute the kernel matrix based on exponential kernel function

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
           kernelmatrix = zeros(size(x, 1), size(y, 1));
           for i = 1:size(x, 1)
               for j = 1:size(y, 1)
                   kernelmatrix(i, j) = exp(-sum(abs(x(i, :)-y(j, :)))/obj.parameter.width^2);
               end
           end
           
       end
   end
end 