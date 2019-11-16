function [t2cps, specps] = computeContribution(testresult, theta, type)
%{

DESCRIPTION
 Compute the Contribution Plots (CPs)

 Reference
 [1]  Deng X, Tian X. A new fault isolation method based on unified
      contribution plots[C]//Proceedings of the 30th Chinese Control
      Conference. IEEE, 2011: 4280-4285.
-------------------------------------------------------------------
 Thanks for the code provided by Rui.
--------------------------------------------------------------------
      [t2cps, specps] = computeContribution(testresult, theta, type)

    INPUT
      testresult   testing results
      theta        experience parameter between 0 and 1 
      type         'train' and 'test'

    OUTPUT
      t2cps        Contribution Plots of T2
      specps       Contribution Plots of SPE

Created on 15th November 2019 by Kepeng Qiu.
-------------------------------------------------------------%

%}
    traindata = testresult.traindata;
    testdata = traindata;
    Kt = testresult.K;
    switch type
        case 'train'
            Kt = testresult.K;
            testdata = testresult.traindata;
        case 'test'
            Kt = testresult.Kt;
            testdata = testresult.testdata;
    end
    
    K = testresult.K;
    [M, ~] = size(traindata);
    [Mt, d] = size(testdata);

    A_T2 = testresult.V_s(:, 1:testresult.dimensionality)*...
        diag(testresult.lambda(1:testresult.dimensionality))^(-1)*...
        testresult.V_s(:, 1:testresult.dimensionality)';
    A_SPE = testresult.V_s(:, 1:testresult.dimensionality)*...
        testresult.V_s(:, 1:testresult.dimensionality)';
    newtestdata = testdata*theta;

    % initialization
    Knew = zeros(Mt, M);
    Knew_d1 = zeros(1, M);
    Knew_d2 = zeros(Mt, M);
    t2cps = zeros(Mt, d);
    specps = zeros(Mt, d);
    Knew_s = zeros(Mt, M);
    sigma = testresult.width;

    % compute contribution of statistic
    for i = 1:Mt
        for j = 1:d
            for k = 1:M

                Knew(i, k) = Kt(i, k);
                Knew_d1(k) = Knew(i, k)*2*theta*(newtestdata(i, j)-traindata(k, j))/(-sigma^2); % derivative
                Knew_d2(i, k) = -2*Knew_d1(k);
%                 Knew_d2(i,k) = Knew(i,k)*4*theta*(Y_new(i,j)-X(k,j)) ...
%                     /(sigma^2); % derivative
            end

            Knew_d1_s = Knew_d1-ones(1, M)*mean(Knew_d1);
            Knew_s(i, :) = Knew(i, :)-ones(1, M)*K/M-Knew(i, :)*ones(M) ...
                /M+ones(1, M)/M*K*ones(M)/M;

            % contribution of T2
            t2cps(i, j) = testdata(i, j)*(Knew_d1_s*A_T2*Knew_s(i, :)' ...
                +Knew_s(i, :)*A_T2*Knew_d1_s');

            % contribution of SPE
            specps(i, j)= testdata(i, j)*mean(Knew_d2(i, :))-testdata(i, j) ...
                *(Knew_d1_s*A_SPE*Knew_s(i, :)'+Knew_s(i, :)*A_SPE*Knew_d1_s');
        end
    end
end

