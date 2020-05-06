%{ 
    DESCRIPTION
    
    MAtlab Code for Dimensionality Reduction and Fault Detection using KPCA.

    Version 2.1, 6-MAY-2020

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
    

    (2) KernelPCA
        

        Non-linear dimensionality reduction, fault detection, and fault 
        diagnosis through the use of kernels.

            kpca = KernelPCA(parameter);
    -----------------------------------------------------------------------
    
        Structures Description of 'parameter'

            application:       dimensionality reduction (dr) and fault detection (fd)
            dim:               dimensionality
            tol:               tolerance for eigenvalues
            alpha:             hyperparameter of the ridge regression that learns the reconstruction
            explained:         percent variability explained by principal components
            kernel:            kernel function
            significanceLevel: significance level (fault detection)
            theta:             experience parameter of fault diagnosis 
            display:           display the results
 
        Details of the application of dimensionality reduction and fault 
        detection please see the demo.

%} 

