classdef KernelPCA < handle
    %{
        Kernel Principal component analysis (KPCA)

        Non-linear dimensionality reduction, fault detection, and fault diagnosis
        through the use of kernels.
    
        Version 2.1, 6-MAY-2020
        Email: iqiukp@outlook.com
    ----------------------------------------------------------------------
    %}
    
    
    properties
        parameter                    % KPCA parameter
        model                        % KPCA model
        prediction                   % predicted results
    end
    
    methods
        
        function obj = KernelPCA(parameter)
            obj.parameter = parameter;
            KernelPCAFunction.checkInput(obj);
        end
        
        function varargout = train(obj, X)
            % train the model from data X
            
            tic
            % compute the kernel matrix
            n_samples = size(X, 1);
            obj.model.n_samples = n_samples;
            K = obj.parameter.kernel.getKernelMatrix(X, X);
            % centralize the kernel matrix
            unit = ones(n_samples, n_samples)/n_samples;
            K_c = K-unit*K-K*unit+unit*K*unit;
            
            if strcmp(obj.parameter.dim, 'None') || strcmp(obj.parameter.application, 'fd')
                obj.model.dim = n_samples;
            else
                obj.model.dim = obj.parameter.dim;
            end
            
            % compute the eigenvalues and eigenvectors
            [V_s, lambda] = obj.computeEigenvalue(K_c);
            
            % store the model
            obj.model.X =  X;
            obj.model.X_map = K_c* V_s;
            obj.model.K = K;
            obj.model.K_c = K_c;
            obj.model.V_s = V_s;
            obj.model.lambda = lambda;
            obj.model.unit = unit;
            
            
            % fault detection
            if strcmp(obj.parameter.application, 'fd')
                
                if ~strcmp(obj.parameter.dim, 'None')
                    obj.model.dim = obj.parameter.dim;
                else
                    % obtain the number of the components according to the percent variability
                    obj.model.dim = find(cumsum(lambda/sum(lambda)) >= obj.parameter.explained, 1, 'first');
                end
                % compute the control limit of SPE and T2
                obj.computeControlLimit;
                % model validation
                obj.test(obj.model.X);
                obj.model.t2AlarmIndex = obj.prediction.t2AlarmIndex;
                obj.model.speAlarmIndex = obj.prediction.speAlarmIndex;
                obj.model.n_speAlarm = obj.prediction.n_speAlarm;
                obj.model.n_t2Alarm = obj.prediction.n_t2Alarm;
                % false alarm rate
                obj.model.speFAR = obj.model.n_speAlarm/obj.model.n_samples;
                obj.model.t2FAR = obj.model.n_t2Alarm/obj.model.n_samples;
                obj.model.timeCost = toc;
                obj.prediction = [];
                % display
                if strcmp(obj.parameter.display, 'on')
                    KernelPCAFunction.displayTrain(obj)
                end
            else
                obj.model.timeCost = toc;
                if strcmp(obj.parameter.display, 'on')
                    KernelPCAFunction.displayTrain(obj)
                end
            end
            
            % output
            if nargout == 1
                varargout{1} = obj.model.X_map;
            end
            
            
        end
        
        function varargout = reconstruct(obj)
            % Transform the mapping data back to original space.
            % References
            % ----------
            % Bakır G H, Weston J, Schölkopf B. Learning to find pre-images[J].
            % Advances in neural information processing systems, 2004, 16: 449-456.
            
            K_1 =  obj.parameter.kernel.getKernelMatrix(obj.model.X_map, obj.model.X_map);
            k_1_ = K_1;
            for i = 1:obj.model.n_samples
                K_1(i, i) = K_1(i, i)+obj.parameter.alpha;
            end
            dual_coef = mldivide(K_1, obj.model.X);
            K_2 =  k_1_;
            obj.model.X_re = K_2*dual_coef;
            % output
            if nargout == 1
                varargout{1} = obj.model.X_re;
            end
        end
        
        
        function varargout = test(obj, Y)
            % test the model from the given data Y
            tic
            Kt = obj.parameter.kernel.getKernelMatrix(Y, obj.model.X);
            % centralize the kernel matrix
            unit = ones(size(Y, 1), obj.model.n_samples)/obj.model.n_samples;
            Kt_c = Kt-unit*obj.model.K-Kt*obj.model.unit+unit*obj.model.K*obj.model.unit;
            % stroe the test results
            obj.prediction.n_samples = size(Y, 1);
            obj.prediction.Y = Y;
            obj.prediction.Y_map = Kt_c*obj.model.V_s(:, 1:obj.model.dim);
            obj.prediction.Kt = Kt;
            
            % fault detection
            if strcmp(obj.parameter.application, 'fd')
                % compute Hotelling's T2 statistic
                obj.prediction.t2 = diag(obj.prediction.Y_map/...
                    diag(obj.model.lambda(1:obj.model.dim))*obj.prediction.Y_map');
                % compute the squared prediction error (SPE)
                obj.prediction.spe = sum((Kt_c*obj.model.V_s).^2, 2)-sum(obj.prediction.Y_map.^2 , 2);
                % store the results
                obj.prediction.t2AlarmIndex = find(obj.prediction.t2>obj.model.t2Limit);
                obj.prediction.speAlarmIndex = find(obj.prediction.spe>obj.model.speLimit);
                obj.prediction.n_speAlarm = length(obj.prediction.speAlarmIndex);
                obj.prediction.n_t2Alarm = length(obj.prediction.t2AlarmIndex);
                obj.prediction.timeCost = toc;
                if strcmp(obj.parameter.display, 'on')
                    KernelPCAFunction.displayTest(obj)
                end
            else
                obj.prediction.timeCost = toc;
                if strcmp(obj.parameter.display, 'on')
                    KernelPCAFunction.displayTest(obj)
                end
            end
            % output
            if nargout == 1
                varargout{1} = obj.prediction.Y_map;
            end
        end
        
        function [V_s, lambda] = computeEigenvalue(obj, K_c)
            % compute the eigenvalues and eigenvectors
            rng('default')
            try
                [V, D] = eigs(K_c/obj.model.n_samples, obj.model.dim);
                lambda = diag(D);
            catch
                [V, D] = eig(K_c/obj.model.n_samples) ;
                lambda_ = diag(D);
                [~, index_] = sort(lambda_, 'descend');
                V = V(:, index_);
                D = D(:, index_);
                V = V(:, 1:obj.model.dim);
                D = D(1:obj.model.dim, 1:obj.model.dim);
                lambda = diag(D);
            end
            
            % ill-conditioned matrix
            if ~(isreal(V)) || ~(isreal(D))
                V = real(V);
                D = real(D);
            end

            if strcmp(obj.parameter.dim, 'None') || strcmp(obj.parameter.application, 'fd')
                indices = lambda > obj.parameter.tol;
                lambda = lambda(indices);
                V = V(:, indices);
                obj.model.dim = length(lambda);
            end
            try
                V_s = V ./ sqrt(obj.model.n_samples*lambda)';
            catch
                V_s = zeros(obj.model.n_samples, obj.model.dim);
                for i = 1:obj.model.dim
                    V_s(:, i) = V(:, i)/sqrt(obj.model.n_samples*lambda(i, 1));
                end
            end
        end
        
        function computeControlLimit(obj)
            % compute the control limit of SPE and T2
            
            % compute the squared prediction error (SPE)
            temp1 = obj.model.K_c*obj.model.V_s;
            temp2 = obj.model.K_c*obj.model.V_s(:, 1:obj.model.dim);
            SPE = sum(temp1.^2, 2)-sum(temp2.^2, 2);
            % compute the T2 limit (the F-Distribution)
            k = obj.model.dim*(obj.model.n_samples-1)/(obj.model.n_samples-obj.model.dim);
            t2Limit = k *finv(obj.parameter.significanceLevel, obj.model.dim, obj.model.n_samples-obj.model.dim);
            % compute the SPE limit (the Chi-square Distribution)
            a = mean(SPE);
            b = var(SPE);
            g = b/2/a;
            h = 2*a^2/b;
            speLimit = g*chi2inv(obj.parameter.significanceLevel, h);
            % store the results
            obj.model.t2Limit = t2Limit;
            obj.model.speLimit = speLimit;
        end
        
        function diagnose(obj, varargin)
            % falut diagnosis
            tic
            if ~strcmp(obj.parameter.kernel.type, 'gauss')
                error('Only fault diagnosis of Gaussian kernel is supported.')
            end
            
            % Default Parameters setting
            start_time = 1;  % Starting time for Contribution Plots
            end_time = size(obj.prediction.Y, 1);   % Ending time for Contribution Plots
            if rem(nargin-1,2)
                error('Parameters of fault diagnosis should be pairs.')
            end
            numparameters = (nargin-1)/2;
            for n =1:numparameters
                parameters = varargin{(n-1)*2+1};
                value	= varargin{(n-1)*2+2};
                switch parameters
                    case 'start_time'
                        start_time = value;
                    case 'end_time'
                        end_time = value;
                end
            end
            
            fprintf('\n')
            fprintf('Fault diagnosis start...\n')
            Y_ = obj.prediction.Y;
            obj.prediction.Y = Y_(start_time:end_time, :);
            % contribution plots of test data
            [t2cpstrain, specpstrain] = obj.computeContribution('train');
            [t2cpstest, specpstest] = obj.computeContribution('test');
            % normalize the contribution plots
            t2cpstrain_mu = mean(t2cpstrain);
            t2cpstrain_std = std(t2cpstrain);
            try
                t2cps = bsxfun(@rdivide, bsxfun(@minus, t2cpstest, t2cpstrain_mu), t2cpstrain_std);
            catch
                mu_array = repmat(t2cpstrain_mu, size(t2cpstest,1), 1);
                st_array = repmat(t2cpstrain_std, size(t2cpstest,1), 1);
                t2cps = (t2cpstest-mu_array)./st_array;
            end
            specpstrain_mu = mean(specpstrain);
            specpstrain_std = std(specpstrain);
            try
                specps = bsxfun(@rdivide, bsxfun(@minus, specpstest, specpstrain_mu), specpstrain_std);
            catch
                mu_array = repmat(specpstrain_mu, size(specpstest,1), 1);
                st_array = repmat(specpstrain_std, size(specpstest,1), 1);
                specps = (specpstest-mu_array)./st_array;
            end
            
            % store the results
            obj.prediction.t2cps = t2cps;
            obj.prediction.specps = specps;
            obj.prediction.start_time = start_time;
            obj.prediction.end_time = end_time;
            obj.prediction.Y = Y_;
            fprintf('Fault diagnosis finished\n')
            fprintf('time cost %.4f s\n', toc)
            fprintf('\n')
        end
        
        function [t2cps, specps] = computeContribution(obj, type)
            
            %  Compute the Contribution Plots (CPs)
            %
            %  Reference
            %  [1]  Deng X, Tian X. A new fault isolation method based on unified
            %       contribution plots[C]//Proceedings of the 30th Chinese Control
            %       Conference. IEEE, 2011: 4280-4285.
            % -------------------------------------------------------------------
            %  Thanks for the code provided by Rui.
            % --------------------------------------------------------------------
            
            X = obj.model.X;
            switch type
                case 'train'
                    Kt = obj.model.K;
                    Y = X;
                case 'test'
                    Kt = obj.prediction.Kt;
                    Y = obj.prediction.Y;
            end
            
            K = obj.model.K;
            M = size(X, 1);
            [Mt, d] = size(Y);
            
            A_T2 = obj.model.V_s(:, 1:obj.model.dim)*...
                diag(obj.model.lambda(1:obj.model.dim))^(-1)*...
                obj.model.V_s(:, 1:obj.model.dim)';
            
            A_SPE = obj.model.V_s(:, 1:obj.model.dim)*...
                obj.model.V_s(:, 1:obj.model.dim)';
            newY = Y*obj.parameter.theta;
            
            % initialization
            Knew = zeros(Mt, M);
            Knew_d1 = zeros(1, M);
            Knew_d2 = zeros(Mt, M);
            t2cps = zeros(Mt, d);
            specps = zeros(Mt, d);
            Knew_s = zeros(Mt, M);
            sigma = obj.parameter.kernel.parameter.width;
            
            % compute contribution of statistic
            for i = 1:Mt
                for j = 1:d
                    for k = 1:M
                        Knew(i, k) = Kt(i, k);
                        Knew_d1(k) = Knew(i, k)*2*obj.parameter.theta*(newY(i, j)-X(k, j))/(-sigma^2); % derivative
                        Knew_d2(i, k) = -2*Knew_d1(k);
                        %                 Knew_d2(i,k) = Knew(i,k)*4*theta*(Y_new(i,j)-X(k,j)) ...
                        %                     /(sigma^2); % derivative
                    end
                    Knew_d1_s = Knew_d1-ones(1, M)*mean(Knew_d1);
                    Knew_s(i, :) = Knew(i, :)-ones(1, M)*K/M-Knew(i, :)*ones(M) ...
                        /M+ones(1, M)/M*K*ones(M)/M;
                    % contribution of T2
                    t2cps(i, j) = Y(i, j)*(Knew_d1_s*A_T2*Knew_s(i, :)' ...
                        +Knew_s(i, :)*A_T2*Knew_d1_s');
                    % contribution of SPE
                    specps(i, j)= Y(i, j)*mean(Knew_d2(i, :))-Y(i, j) ...
                        *(Knew_d1_s*A_SPE*Knew_s(i, :)'+Knew_s(i, :)*A_SPE*Knew_d1_s');
                end
            end
        end
        
    end
end
