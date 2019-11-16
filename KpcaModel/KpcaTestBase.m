classdef KpcaTestBase < handle
%{ 
    CLASS DESCRIPTION
    
    A Base class for testing KPCA model

    Created on 16th November 2019 by Kepeng Qiu.
-------------------------------------------------------------%
%} 
    methods(Abstract)
        test(~)
    end
    
    methods(Static)
        function testtype = setfunction(value)
            switch value
                case 'dimensionalityreduction'
                    testtype = KpcaTestDimensionalityReduction;
                    
                case 'faultdetection'
                    testtype = KpcaTestFaultDetection;
                    %                
            end
        end   
    end
end
