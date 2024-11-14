function [psi]=psi_maker(etta_t,e)
    psi=atan2(sqrt(1-e^2)*sin(etta_t),cos(etta_t)-e);
end