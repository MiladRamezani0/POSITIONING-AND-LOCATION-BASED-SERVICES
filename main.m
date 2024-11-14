clc
clear
format shortg
% [lambda,phi,h] = cartesian2geodetic(10000,10000,1000);
% lambda
% phi
% h

%% section 1:Data

zigma_O=10;
X_O_ITRF=[44 23 24;
    8 56 20
    70 0 0];

X_A_LL=[0 30 0]';
X_B_LL=[0 -30 0]';
X_C_LL=[200 0 0]';
zigma_A=2;
zigma_B=2;
zigma_C=10;
% phi=deg2rad(dms2degrees(X_O_ITRF(1,:)));
% lambda=deg2rad(dms2degrees(X_O_ITRF(2,:)));
phi=(44+23/60+24/3600)*(pi/180);
lambda=(8+56/60+20/3600)*(pi/180);
Local_North=[0 0 10.23];
Local_Earth=[0 0 9.5];
alpha=[30 27 18];
Local_North=deg2rad(dms2degrees(Local_North));
Local_Earth=deg2rad(dms2degrees(Local_Earth));
alpha=deg2rad(dms2degrees(alpha));
%% section 2:X_O Geodetic2GC
h=X_O_ITRF(3,1);
disp('O')
[X_O_GC,Y_O_GC,Z_O_GC]=Geodetic2GC(phi,lambda,h);

%% section 3:A,B,C LL2LC
disp('A')
[E_A_LC,N_A_LC,U_A_LC,R_LL2LC_A]=LL2LC(0,30,0,Local_North,Local_Earth,alpha);
disp('B')
[E_B_LC,N_B_LC,U_B_LC,R_LL2LC_B]=LL2LC(0,-30,0,Local_North,Local_Earth,alpha);
disp('C')
[E_C_LC,N_C_LC,U_C_LC,R_LL2LC_C]=LL2LC(200,0,0,Local_North,Local_Earth,alpha);

%% section 4:LC2GC
disp('A')
[E_A_GC,N_A_GC,U_A_GC,R0]=LC2GC([E_A_LC,N_A_LC,U_A_LC]',[X_O_GC,Y_O_GC,Z_O_GC]',lambda,phi);
disp('B')
[E_B_GC,N_B_GC,U_B_GC,R0]=LC2GC([E_B_LC,N_B_LC,U_B_LC]',[X_O_GC,Y_O_GC,Z_O_GC]',lambda,phi);
disp('C')
[E_C_GC,N_C_GC,U_C_GC,R0]=LC2GC([E_C_LC,N_C_LC,U_C_LC]',[X_O_GC,Y_O_GC,Z_O_GC]',lambda,phi);

%% section 5:ITRF GC 2 ETRF GC 89


%% section 6:ETRF GC 2 Geodetic
A =[4509854.8132 709344.7329 4439228.7612]';
B =[4509885.8305 709380.3979 4439191.802]';
C =[4509773.4716 709521.8492 4439282.7126]';

[phi_A,lambda_A,h_A] = cartesian2geodetic(A(1,1),A(2,1),A(3,1));
rad2deg(phi_A)
AAAA=[degrees2dms(rad2deg(phi_A))
degrees2dms(rad2deg(lambda_A))
h_A 0 0]

[phi_B,lambda_B,h_B] = cartesian2geodetic(B(1,1),B(2,1),B(3,1));
BBBB=[degrees2dms(rad2deg(phi_B))
degrees2dms(rad2deg(lambda_B))
h_B 0 0]

[phi_C,lambda_C,h_C] = cartesian2geodetic(C(1,1),C(2,1),C(3,1));
CCCC=[degrees2dms(rad2deg(phi_C))
degrees2dms(rad2deg(lambda_C))
h_C 0 0]


%% section 7
C_LC_A=CLL2CLC(zigma_A*10^-2,R_LL2LC_A)
C_LC_B=CLL2CLC(zigma_B*10^-2,R_LL2LC_B)
C_LC_C=CLL2CLC(zigma_C*10^-2,R_LL2LC_C)

%% section 8 
C_GC0=[10 0 0;
    0 10 0;
    0 0 10]*10^-2;
C_GC_A=CLC2CGC(C_LC_A,R0,C_GC0)
C_GC_B=CLC2CGC(C_LC_B,R0,C_GC0)
C_GC_C=CLC2CGC(C_LC_C,R0,C_GC0)


C_g_A=CGC2CGeodetic(C_GC_A,R0)
C_g_B=CGC2CGeodetic(C_GC_B,R0)
C_g_C=CGC2CGeodetic(C_GC_C,R0)


%% section 9
