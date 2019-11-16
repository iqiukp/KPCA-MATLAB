classdef InitializeFaultDetection < InitializationBase
%{ 
    CLASS DESCRIPTION
    
    A sub class for parameter initialization (fault detection).

    Created on 16th November 2019 by Kepeng Qiu.
    -------------------------------------------------------------%
%} 
    
    methods
        function parameter = initialize(~)
            %{
            DESCRIPTION
             Parameter initialization for fault detection.
            
                  parameter = initialize(~)
            
            -------------------------------------------------------------%
            %}

            parameter.type = 'faultdetection';
            parameter.cumulativepercentage =  0.75;
            parameter.significancelevel =  0.95;
            parameter.faultdiagnosis =  'off';  
            parameter.diagnosisparameter = 0.5; 
            parameter.timelag = 0;            
        end
    end
end