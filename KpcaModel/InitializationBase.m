classdef InitializationBase < handle
%{ 
    CLASS DESCRIPTION
    
    A Base class for Parameter Optimization

    Created on 16th November 2019 by Kepeng Qiu.
-------------------------------------------------------------%
%} 
    methods(Abstract)
        initialize(~)
    end
    
    methods(Static)
        function type = setfunction(value)
            switch value
                case 'dimensionalityreduction'
                    type = InitializeDimensionalityReduction;
                case 'faultdetection'
                    type = InitializeFaultDetection;
            end
        end   
    end
end

