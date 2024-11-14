function [C_LC]=CLL2CLC(zigma,R_LL2LC)
    C_LL=zeros(3,3);
    for i=1:3
        C_LL(i,i)=zigma^2;
    end
    C_LC=R_LL2LC*C_LL*R_LL2LC';
end