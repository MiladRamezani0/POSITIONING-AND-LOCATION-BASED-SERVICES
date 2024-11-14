function [X,Y,Z,R_0]=LC2GC(X_LC,X_GC_P0,lambda_O,phi_O)
    R_0=[-sin(lambda_O) cos(lambda_O) 0;
        -sin(phi_O)*cos(lambda_O) -sin(phi_O)*sin(lambda_O) cos(phi_O);
        cos(phi_O)*cos(lambda_O) cos(phi_O)*sin(lambda_O) sin(phi_O)];
    X_GC=X_GC_P0+R_0'*X_LC;
    X=X_GC(1,1);
    Y=X_GC(2,1);
    Z=X_GC(3,1);
    disp(['X_GC = ',num2str(X)])
    disp(['Y_GC = ',num2str(Y)])
    disp(['Z_GC = ',num2str(Z)])
end