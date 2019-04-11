function [CPs_T2, CPs_SPE] = CPsKPCA(X,Y,model,varargin)
% DESCRIPTION
%  Contribution Plots for KPCA
%
%       [CPs_T2, CPs_SPE] = CPsKPCA(X,Y,T_s,T_e,theta,model)
%
%  Reference 
%  [1]  Deng X, Tian X. A new fault isolation method based on unified
%       contribution plots[C]//Proceedings of the 30th Chinese Control 
%       Conference. IEEE, 2011: 4280-4285.
%
% INPUT
%   X            Training samples (N*d)
%                N: number of samples
%                d: number of features
%   Y            Test samples (N*d)
%                N: number of samples
%                d: number of features
%   model        KPCA model 

% OUTPUT
%   CPs_T2       Contribution Plots of T2
%   CPs_SPE      Contribution Plots of SPE 
%
% Created on 11th April 2019, by Kepeng Qiu.

% Default Parameters setting
start_time = size(Y,1);  % Starting time for Contribution Plots
end_time = size(Y,1);    % Ending time for Contribution Plots
theta  = 0.5;            % Experience parameter between 0 and 1 
% ------------------------------------------------------------------------
% Notice:  If you want to calculate CPS of a certain time, you should 
%          set start_time equal to end_time. For example, 
%          start_time = 500, end_time = 500.
%          If you want to calculate the average CPS of a period of time,
%          start_time and end_time should be set to Starting time and 
%          Ending time respectively. 
%          For example start_time = 300, end_time = 500. 
% ------------------------------------------------------------------------

if rem(nargin-3,2)
    error('Parameters to kpca_train should be pairs')
end
numParameters = (nargin-3)/2;
for n =1:numParameters
    Parameters = varargin{(n-1)*2+1};
    value	= varargin{(n-1)*2+2};
    switch Parameters
            %
        case 'start_time'
            start_time = value;
            %
        case 'end_time'
            end_time = value;
            %
        case 'theta'
            theta = value;
    end
end

% Contribution Plots of Training samples (it may cost some time here)
[CPs_T2_train,CPs_SPE_train] = computeCPs(X,X, model,theta);

% Contribution Plots of Test samples
Y_test = Y(start_time:end_time,:);
[CPs_T2_test,CPs_SPE_test] = computeCPs(X,Y_test, model,theta);

% Normalize X Contribution Plots
[~, CPs_T2] = normalize(CPs_T2_train,CPs_T2_test);
[~, CPs_SPE] = normalize(CPs_SPE_train,CPs_SPE_test);

end