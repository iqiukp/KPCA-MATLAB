function contribution = diagnoseFault(testresult, varargin)
%{

DESCRIPTION
 Compute the Contribution Plots (CPs)

 Reference
 [1]  Deng X, Tian X. A new fault isolation method based on unified
      contribution plots[C]//Proceedings of the 30th Chinese Control
      Conference. IEEE, 2011: 4280-4285.
-------------------------------------------------------------------

      contribution = diagnoseFault(testresult, varargin)

    INPUT
      testresult   testing results

    OUTPUT
      contribution results of contribution

Created on 16th November 2019 by Kepeng Qiu.
-------------------------------------------------------------%

%}


    % Default Parameters setting
    testdata = testresult.testdata;

    startingtime = size(testdata,1);  % Starting time for Contribution Plots
    endingtime = size(testdata,1);    % Ending time for Contribution Plots
    theta  = 0.5;                     % Experience parameter between 0 and 1 
    %{
    ------------------------------------------------------------------------
    Notice:  
    
     (1)     If you want to calculate CPS of a certain time, you should 
             set starting time equal to ending time. For example, 
             startingtime = 500, endingtime = 500.
    
     (2)     If you want to calculate the average CPS of a period of time,
             starting time and ending time should be set respectively. 
             For example startingtime = 300, endingtime = 500. 
    
    ------------------------------------------------------------------------
    %}
    
    if rem(nargin-1,2)
        error('Parameters of diagnosefault should be pairs')
    end
    numparameters = (nargin-1)/2;
    for n =1:numparameters
        parameters = varargin{(n-1)*2+1};
        value	= varargin{(n-1)*2+2};
        switch parameters
            case 'startingtime'
                startingtime = value;
            case 'endingtime'
                endingtime = value;
            case 'theta'
                theta = value;
        end
    end
    
    testresult.testdata = testdata(startingtime:endingtime, :);
    
    try
        % Contribution Plots of Training samples (it may cost some time here)
        [t2cpstrain, specpstrain] = computeContribution_mex(testresult, theta, 'train');
        % Contribution Plots of Testing samples
        [t2cpstest, specpstest] = computeContribution_mex(testresult, theta, 'test');
    catch
        % Contribution Plots of Training samples (it may cost some time here)
        [t2cpstrain, specpstrain] = computeContribution(testresult, theta, 'train');
        % Contribution Plots of Testing samples
        [t2cpstest, specpstest] = computeContribution(testresult, theta, 'test');
    end

    % Normalize the Contribution Plots
    [~, t2cps] = normalize(t2cpstrain, t2cpstest);
    [~, specps] = normalize(specpstrain, specpstest);

    contribution.t2cps = t2cps;
    contribution.specps = specps;
    contribution.startingtime = startingtime;
    contribution.endingtime = endingtime;
end

