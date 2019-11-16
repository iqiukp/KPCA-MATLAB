classdef KernelBase < handle
%{ 
    CLASS DESCRIPTION

    Created on 16th November 2019 by Kepeng Qiu.
-------------------------------------------------------------%
%} 
   methods(Abstract)
       getKernelMatrix(~)
   end

   methods(Static)
       function kernel = setfunction(value)
          switch value
              
              % linear kernel function
              case 'linear'
                  kernel = KernelLinear;
                  
              % gaussian kernel function
              case 'gauss'
                  kernel = KernelGaussian;
                  
              % polynomial kernel function
              case 'poly'
                  kernel = KernelPolynomial;
                  
              % sigmoid kernel function
              case 'sigm'
                  kernel = KernelSigmoid;
                  
              % exponential kernel function
              case 'exp'
                  kernel = KernelExponential;
                  
              % laplacian kernel function
              case 'lapl'
                  kernel = KernelLaplacian;
          end
       end
   end
end 