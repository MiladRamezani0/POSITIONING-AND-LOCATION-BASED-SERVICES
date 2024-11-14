function [x,y,z]=Geodetic2GC(phi,lambda,h)
    a=6378137;
    f = 1/298.257222100882711243;
    % a=6378137;
    % f=1/298.257223563;
    b=(1-f)*a;
    e=sqrt(1-(b^2/a^2));
    R_N=a/sqrt(1-(e^2)*sin(phi)^2);
    x=(R_N+h)*cos(phi)*cos(lambda);
    y=(R_N+h)*cos(phi)*sin(lambda);
    z=(R_N*(1-e^2)+h)*sin(phi);
    disp(['X_GC = ',num2str(x)])
    disp(['Y_GC = ',num2str(y)])
    disp(['Z_GC = ',num2str(z)])
end