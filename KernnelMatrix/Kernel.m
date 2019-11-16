classdef Kernel < handle
%{ 
    CLASS DESCRIPTION


    Created on 16th November 2019 by Kepeng Qiu.
-------------------------------------------------------------%
%} 

   properties
        kernel        % kernel object
        degree        % kernel parameter for polynomial kernel function
        offset        % kernel parameter for polynomial kernel function
                      %                      linear kernel function
        width         % kernel parameter for gaussian kernel function,
                      %                      exponential kernel function,
                      %                      laplacian kernel function）
        gamma         % kernel parameter for sigmoid kernel function
        type          % kernel type
   end

   methods
       function obj = Kernel(varargin)
           % check the value of input and set the default value
           inputvalue = varargin;
           matlabversion = version('-release');
           if sum(abs(matlabversion)) >= sum(abs('2013b'))
               checkresult =  KernelFunction.checkinput(inputParser, inputvalue);
           else
               checkresult = KernelFunction.checkinput_1(inputvalue);
           end
           obj.kernel =  KernelBase.setfunction(checkresult.type);
           obj.width = checkresult.width;
           obj.degree = checkresult.degree;
           obj.offset = checkresult.offset;
           obj.gamma = checkresult.gamma;
           obj.type = checkresult.type;
       end
       
       function kernelmatrix = getKernelMatrix(obj, X, Y)
          % compute the kernel matrix
          kernelmatrix = obj.kernel.getKernelMatrix(obj, X, Y);
       end
   end
end 

