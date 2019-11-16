classdef InitializeDimensionalityReduction < InitializationBase
%{ 
    CLASS DESCRIPTION
    
    A sub class for parameter initialization (dimensionality reduction).

    Created on 16th November 2019 by Kepeng Qiu.
    -------------------------------------------------------------%
%} 
    
    methods
        function parameter = initialize(~)
            %{
            DESCRIPTION
             Parameter initialization for dimensionality reduction.
            
                  parameter = initialize(~)
            
            -------------------------------------------------------------%
            %}
            
            parameter.type = 'dimensionalityreduction';
            parameter.dimensionality =  2;
        end
    end
end
