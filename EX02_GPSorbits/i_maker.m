function [it]=i_maker(t,i0,idot,t0)
    it=i0+idot*(t-t0);
end