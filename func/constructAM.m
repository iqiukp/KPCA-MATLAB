function Y = constructAM(X,lag)
% DESCRIPTION
% Construct the augmented matrix
%
%       Y = constructAM(X,lag)
%
% INPUT
%   X       original matrix (N¡Ád)
%   lag     time lag
%
% OUTPUT
%   Y       augmented matrix (N¡Ád(lag+1))
%
% Created on 18th April 2019, by Kepeng Qiu.
%-------------------------------------------------------------%

tmp = [];
tmp_X = X;
for i = lag:-1:1
    tmp = [tmp,X(i:end-lag-1+i,:)] ;
end
Y = [X(lag+1:end,:),tmp];

% If the sampling time is less than the lag time, the repeated
% measured values will replace the laged measured values.
tmp = [];
for i = 1:lag
    tmp1 = tmp_X(i:-1:1,:)';
    tmp2 = tmp1(:)';
    tmp(i,:) = [tmp2,repmat(tmp_X(1,:),1,lag+1-i)];
end
Y = [tmp;Y];
end