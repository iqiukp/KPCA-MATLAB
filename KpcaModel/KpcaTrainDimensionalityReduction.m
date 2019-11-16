classdef KpcaTrainDimensionalityReduction < KpcaTrainBase
%{ 
    CLASS DESCRIPTION
    
    A sub class for training KPCA model (dimensionality reduction).

    Created on 16th November 2019 by Kepeng Qiu.
    -------------------------------------------------------------%
%} 
    methods
        function model = train(~, obj, traindata)
            %{
            DESCRIPTION
            Train KPCA model for dimensionality reduction
            
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

            % compute the kernel matrix
            M = size(traindata, 1);
            K = obj.kernel.getKernelMatrix(traindata, traindata);

            % centralize the kernel matrix
            unit = ones(M,M)/M;
            K_c = K-unit*K-K*unit+unit*K*unit;
            [V, D] = eigs(K_c/M, obj.application.dimensionality);
            lambda = diag(D);
            
            try
                V_s = V ./ sqrt(M*lambda)';
            catch 
                V_s = zeros(M, obj.application.dimensionality);
                for i = 1:obj.application.dimensionality
                    V_s(:,i) = V(:,i)/sqrt(M*lambda(i,1));
                end
            end
            
            % store the model
            model.traindata =  traindata;
            model.mappingdata = K_c* V_s;
            model.K = K;
            model.K_c = K_c;
            model.V_s = V_s;
            model.lambda = lambda;
            model.dimensionality = obj.application.dimensionality;
            model.unit = unit;
            model.kernel = obj.kernel;
        end
    end
end
