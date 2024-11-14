function [omegat]=omega(t,omega0,omegadot,omegaEdot,t0)
    omegat=omega0+(omegadot-omegaEdot)*(t-t0);
end