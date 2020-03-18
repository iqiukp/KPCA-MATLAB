classdef KernelBase < handle
%{ 
    CLASS DESCRIPTION

-------------------------------------------------------------%
%} 
   methods(Abstract)
       getKernelMatrix(~)
   end

   methods(Static)
       function kernel = setFunction(value)
        %{
        DESCRIPTION
              type   -  linear :  k(x,y) = x'*y
                        poly   :  k(x,y) = (x'*y+c)^d
                        gauss  :  k(x,y) = exp(-(norm(x-y)/s)^2)
                        sigm   :  k(x,y) = tanh(g*x'*y+c)
                        exp    :  k(x,y) = exp(-(norm(x-y))/s^2)
                        lapl   :  k(x,y) = exp(-(norm(x-y))/s)
           
                degree -  d
                offset -  c
                width  -  s
                gamma  -  g
        %}
           
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