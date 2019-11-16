classdef KpcaFunction < handle
%{ 
    CLASS DESCRIPTION
    

    Created on 16th November 2019 by Kepeng Qiu.
    -------------------------------------------------------------%
%}
    methods(Static)
        function checkresult = checkinput(inputvalue)
            
            % Default Parameters setting
            numparameters = size(inputvalue,2)/2;
            for n =1:numparameters
                parameters = inputvalue{(n-1)*2+1};
                value	= inputvalue{(n-1)*2+2};
                if strcmp(parameters, 'application')
                    applicationtype = value.type;
                    application = InitializationBase.setfunction(applicationtype);
                    checkresult.application = application.initialize;
                    break
                else
                    application = InitializationBase.setfunction('dimensionalityreduction');
                    checkresult.application = application.initialize;
                end
            end

            checkresult.kernel = Kernel('type', 'gauss', 'width', 2);

            % 
            for n =1:numparameters
                parameters = inputvalue{(n-1)*2+1};
                value	= inputvalue{(n-1)*2+2};
                switch parameters
                    case 'application'                        
                        checkresult.application = catstruct(checkresult.application, value);
                    case 'kernel'
                        checkresult.kernel = value;
                end
            end
        end
    end
end