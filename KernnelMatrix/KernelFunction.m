classdef KernelFunction < handle
%{ 
    CLASS DESCRIPTION
    
-------------------------------------------------------------%
%} 
    methods(Static)
        function checkResult = checkInput(inputValue)
            %
            nParameter = size(inputValue, 2)/2;
            
            if nParameter == 0
                % Default Parameters setting
                checkResult.type = 'gauss';
                checkResult.parameter = struct('width', 2);
            end
            
            for n = 1:nParameter
                parameter = inputValue{(n-1)*2+1};
                value = inputValue{(n-1)*2+2};
                if strcmp(parameter, 'type')
                    checkResult.(parameter) = value;
                else
                    checkResult.parameter.(parameter) = value;
                end
            end
            
            tmpName = fieldnames(checkResult);
            if ~ismember(tmpName, 'parameter')
                checkResult.parameter = [];
            end
        end
    end
end