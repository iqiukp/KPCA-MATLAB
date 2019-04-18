function [CPs_T2,CPs_SPE] = computeCPs(X,Y, model,theta)
% DESCRIPTION
%  Compute the Contribution Plots(CPs)
%
%  Reference
%  [1]  Deng X, Tian X. A new fault isolation method based on unified
%       contribution plots[C]//Proceedings of the 30th Chinese Control
%       Conference. IEEE, 2011: 4280-4285.
% -------------------------------------------------------------------
%  Thanks for the code provided by Rui.
% --------------------------------------------------------------------
%       [CPs_T2,CPs_SPE] = computeCPs(X,Y, model,theta)
%
% INPUT
%   X            Training samples (N*d)
%                N: number of samples
%                d: number of features
%   Y            Test samples (N*d)
%                N: number of samples
%                d: number of features
%   model        KPCA model
%   theta        Experience parameter between 0 and 1 

% OUTPUT
%   CPs_T2       Contribution Plots of T2
%   CPs_SPE      Contribution Plots of SPE
%
% Created on 18th April 2019, by Kepeng Qiu.
%-------------------------------------------------------------%

[N,d] = size(X);
[M,d] = size(Y);

A_T2 = model.V_s(:,1:model.dims)*diag(model.lambda(1:model.dims))^(-1) ...
    *model.V_s(:,1:model.dims)';
A_SPE = model.V_s(:,1:model.dims)*model.V_s(:,1:model.dims)';

if ~isequal(X,Y)
    Kt = model.Kt;
else
    Kt = model.K;
end
K = model.K;
Y_new = theta*Y;

% Initialization
Knew = zeros(M,N);
Knew_d1 = zeros(1,N);
Knew_d2 = zeros(M,N);
CPs_T2 = zeros(M,d);
CPs_SPE = zeros(M,d);
Knew_s = zeros(M,N);

% Compute CPs
for i = 1:M
    for j = 1:d
        for k = 1:N
            Knew(i,k) = Kt(i,k);  
            Knew_d1(k) = Knew(i,k)*2*theta*(Y_new(i,j)-X(k,j)) ...
                /(-model.sigma^2); % derivative
            Knew_d2(i,k) = Knew(i,k)*4*theta*(Y_new(i,j)-X(k,j)) ...
                /(model.sigma^2); % derivative
        end
        
        Knew_d1_s = Knew_d1-ones(1,N)*mean(Knew_d1);
        Knew_s(i,:) = Knew(i,:)-ones(1,N)*K/N-Knew(i,:)*ones(N) ...
            /N+ones(1,N)/N*K*ones(N)/N;
        
        % CPs of T2
        CPs_T2(i,j) = Y(i,j)*(Knew_d1_s*A_T2*Knew_s(i,:)' ... 
            +Knew_s(i,:)*A_T2*Knew_d1_s');
        
        % CPs of SPE
        CPs_SPE(i,j)= Y(i,j)*mean(Knew_d2(i,:))-Y(i,j) ...
            *(Knew_d1_s*A_SPE*Knew_s(i,:)'+Knew_s(i,:)*A_SPE*Knew_d1_s');
    end
end

end