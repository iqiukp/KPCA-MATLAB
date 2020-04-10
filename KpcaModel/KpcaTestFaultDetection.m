classdef KpcaTestFaultDetection < KpcaTestBase
%{ 
    CLASS DESCRIPTION
    
    A sub class for testing KPCA model (fault detection).

    Created on 16th November 2019 by Kepeng Qiu.
    -------------------------------------------------------------%
%}
    methods
        function testresult = test(~, obj, model, testdata)
            %{
            DESCRIPTION
            Test KPCA model for fault detection
            
                  testresult = test(~, obj, model, testdata)
            
            INPUT
              model        KPCA model
        
              testdata     testing samples (N*d)
                           N: number of samples
                           d: number of features
            
            OUTPUT
              testresult   testing results
            -------------------------------------------------------------%
            %}

            testresult.testdatabackup = testdata;
            if model.timelag > 0  % DKPCA
                %  construct the time lag matrix
                testdata = constructTimelagMatrix(testdata, model.timelag);
            end

            M = size(model.traindata, 1);
            Mt = size(testdata, 1);
            Kt = model.kernel.getKernelMatrix(testdata, model.traindata);
            
            % centralize the kernel matrix
            unit = ones(Mt, M)/M;
            Kt_c = Kt-unit*model.K-Kt*model.unit+unit*model.K*model.unit;
            
            % extract the nonlinear component
            mappingtestdata = Kt_c*model.V_s(:, 1:model.dimensionality);
            
            % compute Hotelling's T2 statistic
            t2 = diag(mappingtestdata/diag...
                (model.lambda(1:model.dimensionality))*mappingtestdata');
            
            % compute the squared prediction error (SPE)
            spe = sum((Kt_c*model.V_s).^2, 2)-sum(mappingtestdata.^2 , 2);
            
            % stroe the testing results
            testresult.testdata = testresult.testdatabackup;
            testresult.t2 = t2;
            testresult.spe = spe;
            testresult.mappingtestdata = mappingtestdata;
            testresult = rmfield(testresult, 'testdatabackup');

             % fault diagnosis
             names = fieldnames(obj.application);
             [exist, ~] = ismember('faultdiagnosis', names);
             if exist
                 if strcmp(obj.application.faultdiagnosis, 'on')
                     if strcmp(model.kernel.type, 'gauss')
                         testresult.Kt = Kt;
                         testresult.K = model.K;
                         testresult.V_s = model.V_s;
                         testresult.dimensionality = model.dimensionality;
                         testresult.lambda = model.lambda;
                         testresult.width = model.kernel.parameter.width;
                         testresult.traindata = model.traindatabackup;
                     else
                         error('Only Gaussian kernel function based fault diagnosis is supported.')
                     end
                 end
             end

            evalin('base', 'model.traindata = model.traindatabackup;');
            model.traindata = model.traindatabackup;
            model = rmfield(model, 'traindatabackup');

            % display the testing results
            t2alarmindex = find(testresult.t2>model.t2limit);
            spealarmindex = find(testresult.spe>model.spelimit);
            fprintf('\n')
            fprintf('*** Detection finished ***\n')
            fprintf('Testing samples number:  %d \n', size(testresult.testdata,1))
            fprintf('T2 alarm number       :  %d \n', size(t2alarmindex,1))
            fprintf('SPE alarm number      :  %d \n', size(spealarmindex,1))
            fprintf('\n')
        end
    end
end
