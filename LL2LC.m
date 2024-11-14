function [E,N,U,R_LL2LC]=LL2LC(x,y,z,Local_North,Local_East,alpha)
    R_x=[1 0 0;
        0 cos(Local_North) -sin(Local_North);
        0 sin(Local_North) cos(Local_North)];
    R_y=[cos(Local_East) 0 -sin(Local_East);
        0 1 0;
       sin(Local_East) 0 cos(Local_East)];
    R_z=[cos(alpha) sin(alpha) 0;
        -sin(alpha) cos(alpha) 0;
        0 0 1];
    R_LC2LL=R_z*R_y*R_x;
    R_LL2LC=R_LC2LL';
    f=R_LL2LC*[x;y;z];
    E=f(1,1);
    N=f(2,1);
    U=f(3,1);
    disp(['E_LC = ',num2str(E)])
    disp(['N_LC = ',num2str(N)])
    disp(['U_LC = ',num2str(U)])
end