classdef KernelSigmoid < KernelBase
    methods
        function kernelmatrix = getKernelMatrix(~, obj, x, y)
        %{

        DESCRIPTION
            compute the kernel matrix based on sigmoid kernel function

                kernelMatrix = getKernelMatrix(~, obj, x, y)
            
        %}

            % check the input value
            if isempty(obj.parameter)
                obj.parameter.gamma = 0.1;
                obj.parameter.offset = 0;
            else
                parameterName = fieldnames(obj.parameter);
                [gammaExist, ~] = ismember('gamma', parameterName);
                if ~gammaExist
                    obj.parameter.gamma = 0.1; % default
                end
                
                [offsetExist, ~] = ismember('offset', parameterName);
                if ~offsetExist
                    obj.parameter.offset = 0; % default
                end
            end
            
            % compute kernel function matrix
            kernelmatrix = tanh(obj.parameter.gamma*x*y'+obj.parameter.offset);
        end
    end
end