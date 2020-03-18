classdef KernelPolynomial < KernelBase
    methods
        function kernelmatrix = getKernelMatrix(~, obj, x, y)
        %{

        DESCRIPTION
            compute the kernel matrix based on polynomial kernel function

                kernelMatrix = getKernelMatrix(~, obj, x, y)
            
        %}

            % check the input value
            if isempty(obj.parameter)
                obj.parameter.degree = 2;
                obj.parameter.offset = 0;
            else
                parameterName = fieldnames(obj.parameter);
                [degreeExist, ~] = ismember('degree', parameterName);
                if ~degreeExist
                    obj.parameter.degree = 2; % default
                end
                
                [offsetExist, ~] = ismember('offset', parameterName);
                if ~offsetExist
                    obj.parameter.offset = 0; % default
                end
            end
            
            % compute kernel function matrix
            kernelmatrix = (x*y'+obj.parameter.offset).^obj.parameter.degree;
        end
    end
end