function [C_Geodetic]=CGC2CGeodetic(C_GC,R)
    C_Geodetic=R*C_GC*R';
end