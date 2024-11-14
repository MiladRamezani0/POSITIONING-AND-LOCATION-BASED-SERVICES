function [omegast]=omegas(t,omega0,omegasdot,t0)
    omegast=omega0+omegasdot*(t-t0);
end