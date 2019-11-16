classdef KpcaTrainBase < handle
%{ 
    CLASS DESCRIPTION
    
    A Base class for training KPCA model

    Created on 16th November 2019 by Kepeng Qiu.
-------------------------------------------------------------%
%} 
    methods(Abstract)
        train(~)
    end
    methods(Static)
        function traintype = setfunction(value)
            switch value
                case 'dimensionalityreduction'
                    traintype = KpcaTrainDimensionalityReduction;
                    
                case 'faultdetection'
                    traintype = KpcaTrainFaultDetection;
            end
        end   
    end
end
