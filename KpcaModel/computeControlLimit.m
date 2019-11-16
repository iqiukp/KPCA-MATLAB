function [spelimit, t2limit] = computeControlLimit(model)
%{

DESCRIPTION
 Compute the control limit of T2 statistic and SPE statistic


      [spelimit, t2limit] = computeControlLimit(model)

        INPUT
          model       KPCA model

        OUTPUT
          spelimit   the control limit of SPE statistic
          t2limit    the control limit of T2 statistic

Created on 16th November 2019 by Kepeng Qiu.
-------------------------------------------------------------%

%}

    % compute Hotelling's T2 statistic
    % T2 = diag(model.mappedX/diag(model.lambda(1:model.dims))*model.mappedX');

    M = size(model.traindata, 1);
    % compute the squared prediction error (SPE)
    temp1 = model.K_c*model.V_s;
    temp2 = model.K_c*model.V_s(:, 1:model.dimensionality);
    SPE = sum(temp1.^2, 2)-sum(temp2.^2, 2);

    % compute the T2 limit (the F-Distribution)
    k = model.dimensionality*(M-1)/(M-model.dimensionality);
    t2limit = k *finv(model.significancelevel, model.dimensionality,...
                M-model.dimensionality);

    % compute the SPE limit (the Chi-square Distribution)
    a = mean(SPE);
    b = var(SPE);
    g = b/2/a;
    h = 2*a^2/b;
    spelimit = g*chi2inv(model.significancelevel, h);
end

