classdef KernelPCA < handle
    %{
        Kernel Principal component analysis (KPCA)
    
        Version 2.2, 14-MAY-2021
        Email: iqiukp@outlook.com
    -------------------------------------------------------------------
    %}
    
    properties
        data
        label
        numComponents
        explainedLevel
        kernelFunc = Kernel('type', 'gaussian', 'gamma', 0.5)
        lambda
        coefficient %　principal component coefficients
        score %　principal component scores.
        cumContribution % cumulative contribution rate
        newData % Transform the mapping data back to original space
        T2
        SPE
        T2Limit
        SPELimit
        numSPEAlarm
        numT2Alarm
        accuracySPE
        accuracyT2
        eigenvalueTolerance = 1e-8 % tolerance for eigenvalues
        alpha = 1 % hyperparameter of the ridge regression that learns the reconstruction
        theta = 0.7 % experience parameter of fault diagnosis
        significanceLevel = 0.95
        display = 'on'
        temporary
        diagnosis = []
        runningTime
    end
    
    properties (Dependent)
        numSamples
        numFeatures
    end
    
    methods
        function obj = KernelPCA(parameter)
            name_ = fieldnames(parameter);
            for i = 1:size(name_, 1)
                obj.(name_{i, 1}) = parameter.(name_{i, 1});
            end
            KernelPCAOption.checkInputForDiagnosis(obj);
        end
        
        function obj = train(obj, data)
            tStart = tic;
            obj.data = data;
            obj.label = ones(obj.numSamples, 1);

            % compute the kernel matrix
            K = obj.kernelFunc.computeMatrix(obj.data, obj.data);
            % centralize the kernel matrix
            unit = ones(obj.numSamples, obj.numSamples)/obj.numSamples;
            K_c = K-unit*K-K*unit+unit*K*unit;
            % compute the eigenvalues and eigenvectors
            [obj.coefficient, obj.lambda] = obj.computeEigenvalue(K_c);
            % 
            obj.score = K_c* obj.coefficient(:, 1:obj.numComponents);
            obj.newData = obj.reconstruct;
            obj.temporary.K = K;
            obj.temporary.K_c = K_c;
            obj.temporary.unit = unit;
            obj.computeControlLimit;

            % compute accuracy
            T2AlarmIndex = find(obj.T2 > obj.T2Limit);
            SPEAlarmIndex = find(obj.SPE > obj.SPELimit);
            obj.numSPEAlarm = length(SPEAlarmIndex);
            obj.numT2Alarm = length(T2AlarmIndex);

            label_ = obj.label;
            label_(SPEAlarmIndex) = -1;
            obj.accuracySPE = sum(label_ == obj.label)/obj.numSamples;
            label_ = obj.label;
            label_(T2AlarmIndex) = -1;
            obj.accuracyT2 = sum(label_ == obj.label)/obj.numSamples;
            % 
            obj.runningTime = toc(tStart);
            if strcmp(obj.display, 'on')
                KernelPCAOption.displayTrain(obj)
            end
        end

        function results = test(obj, data, varargin)
            % test the model from the given data
            tStart = tic;
            results.evaluation = 'off';
            if nargin == 3
                results.evaluation = 'on';
                testLabel = varargin{1};
            end
            Kt = obj.kernelFunc.computeMatrix(data, obj.data);
            % centralize the kernel matrix
            unit = ones(size(data, 1), obj.numSamples)/obj.numSamples;
            Kt_c = Kt-unit*obj.temporary.K-Kt*obj.temporary.unit+unit*obj.temporary.K*obj.temporary.unit;
            % 
            results.numSamples = size(data, 1);
            results.data = data;
            results.score = Kt_c*obj.coefficient(:, 1:obj.numComponents);

            % compute Hotelling's T2 statistic
            results.T2 = diag(results.score/diag(obj.lambda(1:obj.numComponents))*results.score');
            % compute the squared prediction error (SPE)
            results.SPE = sum((Kt_c*obj.coefficient).^2, 2)-sum(results.score.^2 , 2);
            
            % compute accuracy
            results.T2AlarmIndex = find(results.T2 > obj.T2Limit);
            results.SPEAlarmIndex = find(results.SPE > obj.SPELimit);
            if strcmp(results.evaluation, 'on')
                label_ = testLabel;
                label_(results.SPEAlarmIndex) = -1;
                results.accuracySPE = sum(label_ == testLabel)/results.numSamples;
                label_ = testLabel;
                label_(results.T2AlarmIndex) = -1;
                results.accuracyT2 = sum(label_ == testLabel)/results.numSamples;
            end
            results.numSPEAlarm = length(results.SPEAlarmIndex);
            results.numT2Alarm = length(results.T2AlarmIndex);
            results.temporary.Kt = Kt;
            results.runningTime = toc(tStart);
            
            if strcmp(obj.display, 'on')
                KernelPCAOption.displayTest(results)
            end
            
            % fault diagnosis
            if strcmp(obj.diagnosis.switch, 'on')
                results = obj.diagnose(results);
            end
        end
        
        function newData = reconstruct(obj)
            % Transform the mapping data back to original space.
            % References
            % ----------
            % Bakır G H, Weston J, Schölkopf B. Learning to find pre-images[J].
            % Advances in neural information processing systems, 2004, 16: 449-456.
            
            K_1 =  obj.kernelFunc.computeMatrix(obj.score, obj.score);
            K_1_ = K_1;
            for i = 1:obj.numSamples
                K_1(i, i) = K_1(i, i)+obj.alpha;
            end
            dual_coef = mldivide(K_1, obj.data);
            K_2 =  K_1_;
            newData = K_2*dual_coef;
        end
        
        function [coefficient, lambda] = computeEigenvalue(obj, K_c)
            % compute the eigenvalues and eigenvectors
            rng('default')
            [V, D, ~] = svd(K_c/obj.numSamples, 'econ');
            % ill-conditioned matrix
            if ~(isreal(V)) || ~(isreal(D))
                V = real(V);
                D = real(D);
            end
            lambda_ = diag(D);
            obj.cumContribution = cumsum(lambda_/sum(lambda_));
            
            if isempty(obj.numComponents)
                obj.numComponents = obj.numFeatures;
            else
                if obj.numComponents >= 1
                    obj.numComponents = obj.numComponents;
                else
                    obj.explainedLevel = obj.numComponents;
                    obj.numComponents = find(obj.cumContribution >= obj.numComponents, 1, 'first');
                end
            end
            lambda = lambda_;
            try
                coefficient = V./sqrt(obj.numSamples*lambda_)';
            catch
                coefficient = zeros(obj.numSamples, obj.numSamples);
                for i = 1:obj.numSamples
                    coefficient(:, i) = V(:, i)/sqrt(obj.numSamples*lambda_(i, 1));
                end
            end
        end
        
        function computeControlLimit(obj)
            % compute the squared prediction error (SPE)
            temp1 = obj.temporary.K_c*obj.coefficient;
            temp2 = obj.temporary.K_c*obj.coefficient(:, 1:obj.numComponents);
            obj.SPE = sum(temp1.^2, 2)-sum(temp2.^2, 2);
            obj.T2 = diag(obj.score/diag(obj.lambda(1:obj.numComponents))*obj.score');
            
            % compute the T2 limit (the F-Distribution)
            k = obj.numComponents*(obj.numSamples-1)/(obj.numSamples-obj.numComponents);
            obj.T2Limit = k*finv(obj.significanceLevel, obj.numComponents, obj.numSamples-obj.numComponents);
            
            % compute the SPE limit (the Chi-square Distribution)
            a = mean(obj.SPE);
            b = var(obj.SPE);
            g = b/2/a;
            h = 2*a^2/b;
            obj.SPELimit = g*chi2inv(obj.significanceLevel, h);
        end
        
        function results = diagnose(obj, results, varargin)
            % falut diagnosis
            tStart = tic;
            fprintf('\n')
            fprintf('*** Fault diagnosis ***\n')
            fprintf('Fault diagnosis start...\n')
            results.diagnosis = obj.diagnosis;
            data_ = results.data;
            results.diagnosis.data = data_(results.diagnosis.start:results.diagnosis.end, :);
            % contribution plots of train data
            if ~exist('.\data', 'dir')
                mkdir data;
            end
            file_ = dir('.\data\*.mat');
            name_ = {file_(1:length(file_)).name}';
            if ismember('diagnosis.mat', name_)
                load('.\data\diagnosis.mat', 'tmp_')
                tmp__ = KernelPCAOption.saveCheckObj(obj);
                if isequal(tmp__, tmp_)
                    load('.\data\diagnosis.mat', 'T2CpsTrain', 'SPECpsTrain')
                else
                    [T2CpsTrain, SPECpsTrain] = obj.computeContribution(results, 'train');
                    tmp_ = KernelPCAOption.saveCheckObj(obj);
                    save('.\data\diagnosis.mat', 'T2CpsTrain', 'SPECpsTrain', 'tmp_')
                end
            else
                [T2CpsTrain, SPECpsTrain] = obj.computeContribution(results, 'train');
                tmp_ = KernelPCAOption.saveCheckObj(obj);
                save('.\data\diagnosis.mat', 'T2CpsTrain', 'SPECpsTrain', 'tmp_')
            end
            
            % contribution plots of test data
            [T2CpsTest, SPECpsTest] = obj.computeContribution(results, 'test');
            % normalize the contribution plots
            T2CpsTrainMu = mean(T2CpsTrain);
            T2CpsTrainStd = std(T2CpsTrain);
            
            try
                T2Cps = bsxfun(@rdivide, bsxfun(@minus, T2CpsTest, T2CpsTrainMu), T2CpsTrainStd);
            catch
                mu_array = repmat(T2CpsTrainMu, size(T2CpsTest,1), 1);
                st_array = repmat(T2CpsTrainStd, size(T2CpsTest,1), 1);
                T2Cps = (T2CpsTest-mu_array)./st_array;
            end
            SPECpsTrainMu = mean(SPECpsTrain);
            SPECpsTrainStd = std(SPECpsTrain);
            try
                SPECps = bsxfun(@rdivide, bsxfun(@minus, SPECpsTest, SPECpsTrainMu), SPECpsTrainStd);
            catch
                mu_array = repmat(SPECpsTrainMu, size(SPECpsTest,1), 1);
                st_array = repmat(SPECpsTrainStd, size(SPECpsTest,1), 1);
                SPECps = (SPECpsTest-mu_array)./st_array;
            end
            
            % store the results
            results.diagnosis.T2Cps = T2Cps;
            results.diagnosis.SPECps = SPECps;
            
            %
            T2Cps_ = mean(abs(T2Cps), 1);
            results.diagnosis.meanT2Cps = T2Cps_/sum(T2Cps_, 2);
            
            SPECps_ = mean(abs(SPECps), 1);
            results.diagnosis.meanSPECps = SPECps_/sum(SPECps_, 2);
            
            %
            [value, index] = sort(results.diagnosis.meanT2Cps, 'descend');
            results.diagnosis.faultVariabeT2.value = value;
            results.diagnosis.faultVariabeT2.index = index;

            [value, index] = sort(results.diagnosis.meanSPECps, 'descend');
            results.diagnosis.faultVariabeSPE.value = value;
            results.diagnosis.faultVariabeSPE.index = index;
            
            results.diagnosis.runningTime = toc(tStart); 
            if strcmp(obj.display, 'on')
                KernelPCAOption.displayDiagnose(results)
            end
        end
        
        function [T2Cps, SPECps] = computeContribution(obj, result, type)
            
            %  Compute the Contribution Plots (CPs)
            %
            %  Reference
            %  [1]  Deng X, Tian X. A new fault isolation method based on unified
            %       contribution plots[C]//Proceedings of the 30th Chinese Control
            %       Conference. IEEE, 2011: 4280-4285.
            % -------------------------------------------------------------------
            %  Thanks for the code provided by Rui.
            % --------------------------------------------------------------------
            
            data_ = obj.data;
            switch type
                case 'train'
                    Kt = obj.temporary.K;
                    Y = data_;
                case 'test'
                    Kt = result.temporary.Kt;
                    Y = result.diagnosis.data;
            end
            
            K = obj.temporary.K;
            M = size(data_, 1);
            [Mt, d] = size(Y);
            
            A_T2 = obj.coefficient(:, 1:obj.numComponents)*...
                diag(obj.lambda(1:obj.numComponents))^(-1)*...
                obj.coefficient(:, 1:obj.numComponents)';
            
            A_SPE = obj.coefficient(:, 1:obj.numComponents)*...
                obj.coefficient(:, 1:obj.numComponents)';
            newY = Y*obj.theta;
            
            % initialization
            Knew = zeros(Mt, M);
            Knew_d1 = zeros(1, M);
            Knew_d2 = zeros(Mt, M);
            T2Cps = zeros(Mt, d);
            SPECps = zeros(Mt, d);
            Knew_s = zeros(Mt, M);
            sigma = sqrt(1/2/obj.kernelFunc.gamma);
            
            % compute contribution of statistic
            for i = 1:Mt
                for j = 1:d
                    for k = 1:M
                        Knew(i, k) = Kt(i, k);
                        Knew_d1(k) = Knew(i, k)*2*obj.theta*(newY(i, j)-data_(k, j))/(-sigma^2); % derivative
                        Knew_d2(i, k) = -2*Knew_d1(k);
                    end
                    Knew_d1_s = Knew_d1-ones(1, M)*mean(Knew_d1);
                    Knew_s(i, :) = Knew(i, :)-ones(1, M)*K/M-Knew(i, :)*ones(M) ...
                        /M+ones(1, M)/M*K*ones(M)/M;
                    % contribution of T2
                    T2Cps(i, j) = Y(i, j)*(Knew_d1_s*A_T2*Knew_s(i, :)' ...
                        +Knew_s(i, :)*A_T2*Knew_d1_s');
                    % contribution of SPE
                    SPECps(i, j)= Y(i, j)*mean(Knew_d2(i, :))-Y(i, j) ...
                        *(Knew_d1_s*A_SPE*Knew_s(i, :)'+Knew_s(i, :)*A_SPE*Knew_d1_s');
                end
            end
        end
        
        function numSamples = get.numSamples(obj)
            numSamples= size(obj.data, 1);
        end
        
        function numFeatures = get.numFeatures(obj)
            numFeatures= size(obj.data, 2);
        end
    end
end
