function [C_GC]=CLC2CGC(C_LC,R,C_GC0)
    C_GC_dx=R'*C_LC*R;
    C_GC=C_GC0+C_GC_dx;
end