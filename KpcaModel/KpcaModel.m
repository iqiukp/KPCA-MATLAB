classdef KpcaModel < handle
%{ 
    CLASS DESCRIPTION
    
    A class to train and test KPCA model.

    Created on 16th November 2019 by Kepeng Qiu.
    -------------------------------------------------------------%
%} 
    
    properties
        application         % application of KPCA including 
                            % dimensionality reduction and fault detection
        kernel              % kernel function
    end
 
    methods
        function obj = KpcaModel(varargin)
            % check the value of input and set the default value
            inputvalue = varargin;
            checkresult = KpcaFunction.checkinput(inputvalue);
            obj.kernel = checkresult.kernel;
            obj.application = checkresult.application;
        end

        function kpcamodel = train(obj, data)
            traintype = KpcaTrainBase.setfunction(obj.application.type);
            kpcamodel = traintype.train(obj, data);
        end
        
        function testresult = test(obj, kpcamodel, testdata)
            testtype = KpcaTestBase.setfunction(obj.application.type);
            testresult = testtype.test(obj, kpcamodel, testdata);
        end
    end
end