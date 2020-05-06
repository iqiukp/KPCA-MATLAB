classdef KernelPCAFunction < handle
    
    methods(Static)
        function checkInput(obj)
            % number of components
            if ~isfield (obj.parameter, 'dim')
                obj.parameter.dim = 'None';
            end
            
            % tolerance for eigenvalues
            if ~isfield (obj.parameter, 'tol')
                obj.parameter.tol = 1e-8;
            end
            
            % hyperparameter of the ridge regression that learns the reconstruction
            if ~isfield (obj.parameter, 'alpha')
                obj.parameter.alpha = 1;
            end
            
            % percent variability explained by principal components
            if ~isfield (obj.parameter, 'explained')
                obj.parameter.explained = 0.75;
            end
            
            % kernel function
            if ~isfield (obj.parameter, 'kernel')
                obj.parameter.kernel = Kernel('type', 'gauss', 'width', 2);
            end
            
            % significance level (fault detection)
            if ~isfield (obj.parameter, 'significanceLevel')
                obj.parameter.significanceLevel = 0.95;
            end
            
            % application
            % dimensionality reduction (dr)
            % fault detection (fd)
            if ~isfield (obj.parameter, 'application')
                obj.parameter.application = 'dr';
            end
            
            % experience parameter of fault diagnosis
            if ~isfield (obj.parameter, 'theta')
                obj.parameter.theta = 0.7;
            end
            
            % display
            if ~isfield (obj.parameter, 'display')
                obj.parameter.display = 'on';
            end
        end
        
        function displayTrain(obj)
            if strcmp(obj.parameter.application, 'dr')
                fprintf('\n')
                fprintf('*** KPCA model training finished ***\n')
                fprintf('dimensionality             =  %d \n', obj.model.dim);
                fprintf('time cost                  =  %.4f s\n', obj.model.timeCost)
                fprintf('\n')
            end
            if strcmp(obj.parameter.application, 'fd')
                fprintf('\n')
                fprintf('*** KPCA model training finished ***\n')
                fprintf('dimensionality             =  %d \n', obj.model.dim);
                fprintf('number of T2 alarm         =  %d \n', obj.model.n_t2Alarm)
                fprintf('number of SPE alarm        =  %d \n', obj.model.n_speAlarm)
                fprintf('FAR of SPE                 =  %.4f%% \n', 100*obj.model.speFAR)
                fprintf('FAR of T2                  =  %.4f%% \n', 100*obj.model.t2FAR)
                fprintf('time cost                  =  %.4f s\n', obj.model.timeCost)
                fprintf('\n')
            end
        end
        
        function displayTest(obj)
            if strcmp(obj.parameter.application, 'dr')
                fprintf('\n')
                fprintf('*** KPCA model test finished ***\n')
                fprintf('time cost                  =  %.4f s\n', obj.prediction.timeCost)
                fprintf('\n')
            end
            if strcmp(obj.parameter.application, 'fd')
                fprintf('\n')
                fprintf('*** KPCA model test finished ***\n')
                fprintf('number of test data        =  %d \n', obj.prediction.n_samples)
                fprintf('number of T2 alarm         =  %d \n', obj.prediction.n_t2Alarm)
                fprintf('number of SPE alarm        =  %d \n', obj.prediction.n_speAlarm)
                fprintf('time cost                  =  %.4f s\n', obj.prediction.timeCost)
                fprintf('\n')
            end
        end
        
    end
end

