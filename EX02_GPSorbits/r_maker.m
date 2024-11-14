function [r_t]=r_maker(a,e,psi)
    r_t=(a*(1-e^2))/(1+e*cos(psi));
end