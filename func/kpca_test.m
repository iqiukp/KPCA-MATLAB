function model = kpca_test(model,Y)
% DESCRIPTION
% Compute the T2 statistic, SPE statistic,and the nonlinear component of Y
%
%       model = kpca_test(model,Y)
%
% INPUT
%   model       KPCA model
%   Y           test data
%
% OUTPUT
%   model       updated KPCA model (adding fault detection results)
%
% Created on 11th April 2019, by Kepeng Qiu.


% Compute Hotelling's T2 statistic
% T2 = diag(model.mappedX/diag(model.lambda(1:model.dims))*model.mappedX');

% the number of test samples
L = size(Y,1);

% Compute the kernel matrix
Kt = computeKM(Y,model.X,model.sigma ); 

% Centralize the kernel matrix
unit = ones(L,model.L)/model.L; 
Kt_c = Kt-unit*model.K-Kt*model.unit+unit*model.K*model.unit; 

% Extract the nonlinear component
mappedY = Kt_c*model.V_s(:,1:model.dims);

% Compute Hotelling's T2 statistic
T2 = diag(mappedY/diag(model.lambda(1:model.dims))*mappedY');

% Compute the squared prediction error (SPE)
SPE = sum((Kt_c*model.V_s).^2,2)-sum(mappedY.^2 ,2);

% update KPCA model (adding fault detection results)
model.T2_test = T2;
model.SPE_test = SPE;
model.mappedY = mappedY;

% Fault diagnosis
if model.diagnosis  == 1
    model.Kt = Kt; 
end

end