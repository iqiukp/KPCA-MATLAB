classdef KernelPCAOption < handle
    
    methods(Static)
        function checkInputForDiagnosis(obj)
            tmp_.switch = 'off';
            tmp_.start = [];
            tmp_.end = [];
            errorText = sprintf('Incorrected input for diagnosis.\n');
            if isempty(obj.diagnosis)
                obj.diagnosis = tmp_;
            else
                if ~strcmp(obj.kernelFunc.type, 'gaussian')
                    error('Only fault diagnosis of Gaussian kernel is supported.')
                end
                if ~isa(obj.diagnosis, 'double')
                    error(errorText);
                end
                numInput = length(obj.diagnosis);
                switch numInput
                    case 1
                        tmp_.switch = 'on';
                        tmp_.start = obj.diagnosis(1);
                        tmp_.end = tmp_.start;
                    case 2
                        if obj.diagnosis(1) > obj.diagnosis(2)
                            error(errorText)
                        end
                        tmp_.switch = 'on';
                        tmp_.start = obj.diagnosis(1);
                        tmp_.end = obj.diagnosis(2);
                    otherwise
                        error(errorText)
                end
                obj.diagnosis = tmp_;
            end
        end
        
        function tmp_ = saveCheckObj(kpca)
            names_ = fieldnames(kpca.kernelFunc);
            for i = 1:length(names_)
                tmp_.kernelFunc.(names_{i}) = (kpca.kernelFunc.(names_{i}));
            end
            tmp_.data = kpca.data;
            tmp_.numComponents = kpca.numComponents;
            tmp_.explainedLevel = kpca.explainedLevel;
            tmp_.eigenvalueTolerance = kpca.eigenvalueTolerance;
            tmp_.significanceLevel = kpca.significanceLevel;
        end
        
        function displayTrain(kpca)
            fprintf('\n')
            fprintf('*** KPCA model training finished ***\n')
            fprintf('running time            = %.4f seconds\n', kpca.runningTime)
            fprintf('kernel function         = %s \n', kpca.kernelFunc.type)
            fprintf('number of samples       = %d \n', kpca.numSamples)
            fprintf('number of features      = %d \n', kpca.numFeatures)
            fprintf('number of components    = %d \n', kpca.numComponents)
            fprintf('number of T2 alarm      = %d \n', kpca.numT2Alarm)
            fprintf('number of SPE alarm     = %d \n', kpca.numSPEAlarm)
            fprintf('accuracy of T2          = %.4f%% \n', 100*kpca.accuracyT2)
            fprintf('accuracy of SPE         = %.4f%% \n', 100*kpca.accuracySPE)
        end
        
        function displayTest(results)
            fprintf('\n')
            fprintf('*** KPCA model test finished ***\n')
            fprintf('running time            = %.4f seconds\n', results.runningTime)
            fprintf('number of test data     = %d \n', results.numSamples)
            fprintf('number of T2 alarm      = %d \n', results.numT2Alarm)
            fprintf('number of SPE alarm     = %d \n', results.numSPEAlarm)
            if strcmp(results.evaluation, 'on')
                fprintf('accuracy of T2          = %.4f%% \n', 100*results.accuracyT2)
                fprintf('accuracy of SPE         = %.4f%% \n', 100*results.accuracySPE)
            end
            fprintf('\n')
        end

        function displayDiagnose(results)
            fprintf('Fault diagnosis finished.\n')
            fprintf('running time            = %.4f seconds\n', results.diagnosis.runningTime)
            fprintf('start point             = %d \n', results.diagnosis.start)
            fprintf('ending point            = %d \n', results.diagnosis.end)
            tmp_T2 = results.diagnosis.faultVariabeT2.index;
            tmp_SPE = results.diagnosis.faultVariabeSPE.index;
            if length(tmp_T2) > 3
                numShow = 3;
            else
                numShow = length(tmp_T2);
            end
            fprintf('fault variables (T2)    = %s \n', num2str(tmp_T2(1:numShow)))
            fprintf('fault variables (SPE)   = %s \n', num2str(tmp_SPE(1:numShow))) 
            fprintf('\n')
        end
    end
end