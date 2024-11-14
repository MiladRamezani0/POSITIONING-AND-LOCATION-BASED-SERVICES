function [phi,lambda,h] = cartesian2geodetic(x,y,z)
    a=6378137;
    f = 1/298.257222100882711243;
    % a=6378137;
    % f=1/298.257223563;
    b=(1-f)*a;
    e=sqrt(1-(b^2/a^2));
    e_b2=(a^2-b^2)/b^2;
    r=sqrt(x^2+y^2);
    psi=atan2(z,(r*sqrt(1-e^2)));
    lambda = atan2(y,x);
    phi = atan2((z+e_b2*b*sin(psi)^3),(r-(e^2)*a*cos(psi)^3));
    R_N=a/sqrt(1-(e^2)*sin(phi)^2);
    h=(r/cos(phi))-R_N;
end
