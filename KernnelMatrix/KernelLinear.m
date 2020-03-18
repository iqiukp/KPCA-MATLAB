classdef KernelLinear < KernelBase
    methods
        function kernelmatrix = getKernelMatrix(~, obj, x, y)
        %{

        DESCRIPTION
            compute the kernel matrix based on linear kernel function

                kernelMatrix = getKernelMatrix(~, obj, x, y)
            
        %}

           % check the input value
           if isempty(obj.parameter)
               obj.parameter.offset = 0;
           else
               parameterName = fieldnames(obj.parameter);
               [offsetExist, ~] = ismember('offset', parameterName);
               if ~offsetExist
                   obj.parameter.offset = 0; % default
               end
           end
           
           % compute kernel function matrix
            kernelmatrix = x*y'+obj.parameter.offset;
        end
    end
end
