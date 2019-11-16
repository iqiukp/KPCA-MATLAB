classdef KpcaTestDimensionalityReduction < KpcaTestBase
%{ 
    CLASS DESCRIPTION
    
    A sub class for testing KPCA model (dimensionality reduction).

    Created on 16th November 2019 by Kepeng Qiu.
    -------------------------------------------------------------%
%} 
    methods
        function testresult = test(~, ~, model, testdata)
            %{
            DESCRIPTION
            Test KPCA model for dimensionality reduction
            
                  testresult = test(~, ~, model, testdata)
            
            INPUT
              model        KPCA model
        
              testdata     testing samples (N*d)
                           N: number of samples
                           d: number of features
            
            OUTPUT
              testresult   testing results
            -------------------------------------------------------------%
            %}

            M = size(model.traindata, 1);
            Mt = size(testdata, 1);
            Kt = model.kernel.getKernelMatrix(testdata, model.traindata);
            
            % centralize the kernel matrix
            unit = ones(Mt, M)/M;
            Kt_c = Kt-unit*model.K-Kt*model.unit+unit*model.K*model.unit;
            
            % stroe the testing results
            testresult.testdata = testdata;
            testresult.mappingtestdata = Kt_c*model.V_s(:, 1:model.dimensionality);
        end
    end
end
