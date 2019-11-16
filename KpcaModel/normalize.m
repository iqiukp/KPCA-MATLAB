function [Xs, Ys] = normalize(X, Y)
%{ 
    DESCRIPTION
     Normalization

          [X_s, Y_s] = normalize(X,Y)

    INPUT
      X            Training samples (N*d)
                   N: number of samples
                   d: number of features
      Y            Testing samples (N*d)
                   N: number of samples
                   d: number of features

    OUTPUT
      Xs          Normalizated X
      Ys          Normalizated Y

    Created on 16th November 2019 by Kepeng Qiu.
    -------------------------------------------------------------%

%} 

    % normalize X
    X_mu = mean(X);
    X_std = std(X);
    Xs = zscore(X);

    % normalize Y using the mean and standard deviation of X
    try
        Ys = bsxfun(@rdivide,bsxfun(@minus,Y,X_mu),X_std);
    catch
        mu_array = repmat( X_mu, size(Y,1), 1 );
        st_array = repmat( X_std, size(Y,1), 1 );
        Ys = (Y-mu_array)./st_array;
    end
end


