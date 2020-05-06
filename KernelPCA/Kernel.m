classdef Kernel < handle
    %{
        Kernel function
    
        Version 2.1, 6-MAY-2020
        Email: iqiukp@outlook.com
    ----------------------------------------------------------------------
    %}

    
    properties
        type          % kernel type
        parameter     % parameter of kernel function
    end
    
    methods
        
        function obj = Kernel(varargin)
            inputValue = varargin;
            nParameter = size(inputValue, 2)/2;
            if nParameter == 0
                % Default Parameters setting
                obj.type = 'gauss';
                obj.parameter = struct('width', 2);
            end
            for n = 1:nParameter
                parameter = inputValue{(n-1)*2+1};
                value = inputValue{(n-1)*2+2};
                if strcmp(parameter, 'type')
                    obj.(parameter) = value;
                else
                    obj.parameter.(parameter) = value;
                end
            end
            tmpName = fieldnames(obj);
            if ~ismember(tmpName, 'parameter')
                obj.parameter = [];
            end
        end
        
        function K = getKernelMatrix(obj, x, y)
            % compute the kernel matrix
            switch obj.type
                case 'linear' % linear kernel function
                    K = obj.linear(x, y);
                case 'gauss' % gaussian kernel function
                    K = obj.gaussian(x, y);
                case 'poly' % polynomial kernel function
                    K = obj.polynomial(x, y);
                case 'sigm' % sigmoid kernel function
                    K = obj.sigmoid(x, y);
                case 'exp' % exponential kernel function
                    K = obj.exponential(x, y);
                case 'lapl' % laplacian kernel function
                    K = obj.laplacian(x, y);
            end
        end
        
        function K = linear(obj, x, y)
            % check the input value
            if isempty(obj.parameter)
                obj.parameter.offset = 0;
            else
                [offsetExist, ~] = ismember('offset', fieldnames(obj.parameter));
                if ~offsetExist
                    obj.parameter.offset = 0; % default
                end
            end
            % compute kernel function matrix
            K = x*y'+obj.parameter.offset;
        end
        
        function K = gaussian(obj, x, y)
            % check the input value
            if isempty(obj.parameter)
                obj.parameter.width = 2;
            else
                [widthExist, ~] = ismember('width', fieldnames(obj.parameter));
                if ~widthExist
                    obj.parameter.width = 2; % default
                end
            end
            % compute kernel function matrix
            sx = sum(x.^2, 2);
            sy = sum(y.^2, 2);
            xy = 2*x*y';
            K = exp((bsxfun(@minus, bsxfun(@minus, xy, sx), sy'))/obj.parameter.width^2);
        end
        
        function K = polynomial(obj, x, y)
            % check the input value
            if isempty(obj.parameter)
                obj.parameter.degree = 2;
                obj.parameter.offset = 0;
            else
                [degreeExist, ~] = ismember('degree', fieldnames(obj.parameter));
                if ~degreeExist
                    obj.parameter.degree = 2; % default
                end
                
                [offsetExist, ~] = ismember('offset', fieldnames(obj.parameter));
                if ~offsetExist
                    obj.parameter.offset = 0; % default
                end
            end
            % compute kernel function matrix
            K = (x*y'+obj.parameter.offset).^obj.parameter.degree;
        end
        
        function K = sigmoid(obj, x, y)
            % check the input value
            if isempty(obj.parameter)
                obj.parameter.gamma = 0.1;
                obj.parameter.offset = 0;
            else
                [gammaExist, ~] = ismember('gamma', fieldnames(obj.parameter));
                if ~gammaExist
                    obj.parameter.gamma = 0.01; % default
                end
                [offsetExist, ~] = ismember('offset', fieldnames(obj.parameter));
                if ~offsetExist
                    obj.parameter.offset = 0; % default
                end
            end
            % compute kernel function matrix
            K = tanh(obj.parameter.gamma*x*y'+obj.parameter.offset);
        end
        
        function K = exponential(obj, x, y)
            % check the input value
            if isempty(obj.parameter)
                obj.parameter.width = 2;
            else
                [widthExist, ~] = ismember('width',fieldnames(obj.parameter));
                if ~widthExist
                    obj.parameter.width = 2; % default
                end
            end
            % compute kernel function matrix
            K = zeros(size(x, 1), size(y, 1));
            for i = 1:size(x, 1)
                for j = 1:size(y, 1)
                    K(i, j) = exp(-sum(abs(x(i, :)-y(j, :)))/obj.parameter.width^2);
                end
            end
        end
        
        function K = laplacian(obj, x, y)
            % check the input value
            if isempty(obj.parameter)
                obj.parameter.width = 2;
            else
                [widthExist, ~] = ismember('width', fieldnames(obj.parameter));
                if ~widthExist
                    obj.parameter.width = 2; % default
                end
            end
            % compute kernel function matrix
            K = zeros(size(x, 1), size(y, 1));
            for i = 1:size(x, 1)
                for j = 1:size(y, 1)
                    K(i, j) = exp(-sum(abs(x(i, :)-y(j, :)))/obj.parameter.width);
                end
            end
        end
        
    end
end

