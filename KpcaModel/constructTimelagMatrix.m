function Y = constructTimelagMatrix(X, timelag)
%{

DESCRIPTION
 Construct the time lag Matrix (DKPCA)


      Y = constructTimelagMatrix(X, lag)

    INPUT
      X             original matrix (N*d)
      timelag       time lag

    OUTPUT
      Y             time lag Matrix (N*d(timelag+1))

Created on 16th November 2019 by Kepeng Qiu.
-------------------------------------------------------------%

%}


    tmp = [];
    tmp_X = X;
    for i = timelag:-1:1
        tmp = [tmp, X(i:end-timelag-1+i, :)] ;
    end
    Y = [X(timelag+1:end, :), tmp];

    % If the sampling time is less than the time lag, the repeated
    % measured values will replace the laged measured values.
    tmp = [];
    for i = 1:timelag
        tmp1 = tmp_X(i:-1:1, :)';
        tmp2 = tmp1(:)';
        tmp(i,:) = [tmp2, repmat(tmp_X(1,:), 1, timelag+1-i)];
    end
    Y = [tmp; Y];
end

