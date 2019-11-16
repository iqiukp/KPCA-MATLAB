classdef KernelFunction < handle
%{ 
    CLASS DESCRIPTION
    
    Created on 16th November 2019 by Kepeng Qiu.
-------------------------------------------------------------%
%} 
    methods(Static)
        function checkresult = checkinput(p, inputvalue)
            functype = {'linear', 'gauss', 'poly', 'sigm', 'exp', 'lapl'};
            defaultkernel = 'gauss';
            p.addParameter('type', defaultkernel,...
                @(x)any(validatestring(x, functype)));
            
            defaultwidth = 2;
            p.addParameter('width', defaultwidth);
            
            defaultdegree = 2;
            p.addParameter('degree', defaultdegree);
            
            defaultoffset = 0;
            p.addParameter('offset', defaultoffset);
            
            defaultgamma = 0.1;
            p.addParameter('gamma', defaultgamma);
            
            p.parse(inputvalue{:});
            checkresult = p.Results;
        end
        
        function checkresult = checkinput_1(inputvalue)
            % Default Parameters setting
            checkresult.type = 'gauss';
            checkresult.width = 2; 
            checkresult.degree = 2;
            checkresult.offset = 0;
            checkresult.gamma = 0.1;
            numparameters = size(inputvalue, 2)/2;
            for n =1:numparameters
                parameters = inputvalue{(n-1)*2+1};
                value	= inputvalue{(n-1)*2+2};
                switch parameters
                    case 'type'
                        checkresult.type = value;
                    case 'width'
                        checkresult.width = value;
                    case 'degree'
                        checkresult.degree = value;
                    case 'offset'
                        checkresult.offset = value;
                    case 'gamma'
                        checkresult.gamma = value;
                end
            end
            checkresult = orderfields(checkresult);
        end
    end
end