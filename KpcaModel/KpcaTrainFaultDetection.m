classdef KpcaTrainFaultDetection < KpcaTrainBase
%{ 
    CLASS DESCRIPTION
    
    A sub class for training KPCA model (fault detection).

    Created on 16th November 2019 by Kepeng Qiu.
    -------------------------------------------------------------%
%} 
    methods
        function model = train(~, obj, traindata)
            %{
            DESCRIPTION
            Train KPCA model for fault detection
            
                  model = train(~, obj, traindata)
            
            INPUT
              obj          KPCA model object
        
              traindata    training samples (N*d)
                           N: number of samples
                           d: number of features
            
            OUTPUT
              model        KPCA model
            -------------------------------------------------------------%
            %}
            
            model.traindatabackup = traindata;
            [exist, ~] = ismember('timelag', fieldnames(obj.application));
            
            if (~exist)
                obj.application.timelag = 0;
                model.timelag = 0;
            else
                % DKPCA
                traindata = constructTimelagMatrix(traindata, obj.application.timelag);
                model.timelag = obj.application.timelag; % time lag
            end
            
            M = size(traindata, 1);
            K = obj.kernel.getKernelMatrix(traindata, traindata);

            % centralize the kernel matrix
            unit = ones(M, M)/M;
            K_c = K-unit*K-K*unit+unit*K*unit;
            [V, D] = eigs(K_c/M, M);
            lambda = diag(D);
            dimensionality = find(cumsum(lambda/sum(lambda)) >= ...
                obj.application.cumulativepercentage, 1, 'first');
            
            try
                V_s = V./sqrt(M*lambda)';
            catch 
                V_s = zeros(M, M);
                for i = 1:M
                    V_s(:, i) = V(:, i)/sqrt(M*lambda(i, 1));
                end
            end
            
            % store the model
            model.traindata = traindata;
            model.mappingdata = K_c* V_s(:, 1:dimensionality);
            model.K = K;
            model.K_c = K_c;
            model.V_s = V_s;
            model.lambda = lambda;
            model.dimensionality = dimensionality;
            model.unit = unit;
            model.kernel = obj.kernel;
            model.significancelevel = obj.application.significancelevel; 
            
            % compute the control limit of SPE and T2 
            [spelimit, t2limit] = computeControlLimit(model);
            model.spelimit = spelimit;
            model.t2limit = t2limit;
        end
    end
end
