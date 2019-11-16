%{ 
    DESCRIPTION
    
    MAtlab Code for Dimensionality Reduction and Fault Detection using KPCA.

    Version 1.0 16-NOV-2019

    -----------------------------------------------------------------------

    Main classes
    
    (1) KernnelMatrix
        
        Compute kernel matrix using different kernel functions.

            kernel = Kernel('type', 'gauss', 'width', 2);
            kernel = Kernel('type', 'exp', 'width', 2);
            kernel = Kernel('type', 'linear', 'offset', 0);
            kernel = Kernel('type', 'lapl', 'width', 2);
            kernel = Kernel('type', 'sigm', 'gamma', 0.1, 'offset', 0);
            kernel = Kernel('type', 'poly', 'degree', 2, 'offset', 0);
    

    (2) KpcaModel
        
        Create an object with properties 'application', 'kernel', 
        and methods 'train' and 'test'.

            kpca = KpcaModel('application', application, 'kernel', kernel);
    -----------------------------------------------------------------------
    
    Main structures
    
    (1) application parameter structures

           (1.1) Dimensionality Reduction
                    parameter.type = 'dimensionalityreduction';
                    parameter.dimensionality =  2;    

           (1.2) Fault Detection
                    parameter.type = 'faultdetection';
                    parameter.cumulativepercentage =  0.75; 
                    parameter.significancelevel =  0.95;
                    parameter.faultdiagnosis =  'off';  
                    parameter.diagnosisparameter = 0.5; 
                    parameter.timelag = 0;  
            
           where 
          'cumulativepercentage' : a parameter to decide the number of  
                                   principal component. 
          'significancelevel'    : a parameter as corresponding probabilities
                                   to compute the control limit.
          'diagnosisparameter'   : an experience parameter between 0 and 1
                                   for fault diagnosis.
          'timelag'              : a time lag parameter for DKPCA.
    -----------------------------------------------------------------------

        Details of the application of Dimensionality Reduction and Fault 
        Detection please see the demos.
    -----------------------------------------------------------------------
%} 

