classdef Kernel < handle
%{ 
    CLASS DESCRIPTION

    Created on 1st December 2019 by Kepeng Qiu.
-------------------------------------------------------------%
%} 

   properties
        kernel        % kernel function object
        type          % kernel type
        parameter     % parameter of kernel function
   end

   methods
       function obj = Kernel(varargin)
           % check the value of input and set the default value
           inputValue = varargin;
           checkResult = KernelFunction.checkInput(inputValue);
           obj.kernel =  KernelBase.setFunction(checkResult.type);
           obj.parameter = checkResult.parameter;
           obj.type = checkResult.type;
       end
       
       function kernelMatrix = getKernelMatrix(obj, X, Y)
          % compute the kernel matrix
          kernelMatrix = obj.kernel.getKernelMatrix(obj, X, Y);
       end
   end
end 

