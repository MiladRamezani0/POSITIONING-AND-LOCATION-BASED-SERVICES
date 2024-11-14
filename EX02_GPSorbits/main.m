clc
clear
format long
set(0,'DefaultFigureWindowStyle','docked');

%% data
% Almanac of satellite SVN 63, PRN 01 (Block IIR) for 2016, 11, 28
dt0= -7.661711424589D-05;
dt1= -3.183231456205D-12;
dt2=  0.000000000000D+00;

sqrt_a= 5.153650835037D+03; % (sqrt of meters)
a=sqrt_a^2;
e= 3.841053112410D-03;
M0= 1.295004883409D+00; %(radians)
GMe = 3.986005D+14; %(m3/s2)


OmegaEdot = 7.2921151467D-05; %(radians) used
Omega0= -2.241692424630D-01; %(radians) used
Omegadot= -8.386063598924D-09; %(radians/sec) used
i0= 9.634782624741D-01; %(radians) used
idot= -7.286017777600D-11; %(radians/sec) used
w0= 9.419793734505D-01; %(radians) used
wdot= 0.0;  %(radians/sec) used


%% part 1

%part A
t_epoch=zeros(2878,1);
for i=1:length(t_epoch)-1
    t_epoch(i+1)=t_epoch(i)+30;
end

%part B
dt_s_tgps=dt0+dt1*t_epoch+dt2*t_epoch.^2;
figure(1)
plot(t_epoch,dt_s_tgps)
grid on
title('clock offsets')
xlabel('t(second)')
ylabel('offset')
axis square



%part C
%1
n=sqrt((GMe)/a^3);
%2 & 3
table_ORS=zeros(length(t_epoch),8);
for i=1:2878
    table_ORS(i,1)=t_epoch(i);
    table_ORS(i,2)=M(t_epoch(i),M0,n,0);
    table_ORS(i,3)=ecc_anomaly(table_ORS(i,2),e);
    table_ORS(i,4)=psi_maker(table_ORS(i,3),e);
    table_ORS(i,5)=r_maker(a,e,table_ORS(i,4));
    table_ORS(i,6)=x_maker(table_ORS(i,5),table_ORS(i,4));
    table_ORS(i,7)=y_maker(table_ORS(i,5),table_ORS(i,4));
end

table_ITRF=zeros(length(t_epoch),7);
for i=1:length(t_epoch)
    table_ITRF(i,1)=t_epoch(i);
    table_ITRF(i,2)=omega(t_epoch(i),Omega0,Omegadot,OmegaEdot,0);
    table_ITRF(i,3)=i_maker(t_epoch(i),i0,idot,0);
    table_ITRF(i,4)=omegas(t_epoch(i),w0,wdot,0);
    R3omega=[cos(-table_ITRF(i,2)) sin(-table_ITRF(i,2)) 0;
        -sin(-table_ITRF(i,2)) cos(-table_ITRF(i,2)) 0;
        0 0 1];
    R1i=[1 0 0;
        0 cos(-table_ITRF(i,3)) -sin(-table_ITRF(i,3));
        0 sin(-table_ITRF(i,3)) cos(-table_ITRF(i,3))];
    R3w=[cos(-table_ITRF(i,4)) sin(-table_ITRF(i,4)) 0;
        -sin(-table_ITRF(i,4)) cos(-table_ITRF(i,4)) 0;
        0 0 1];
    % R1=rotz(-table2(i,2));
    % R2=rotx(-table2(i,3));
    % R3=rotz(-table2(i,4));
    location_itrf=R3omega*R1i*R3w*[table_ORS(i,6);table_ORS(i,7);table_ORS(i,8)];
    table_ITRF(i,5)=location_itrf(1,1);
    table_ITRF(i,6)=location_itrf(2,1);
    table_ITRF(i,7)=location_itrf(3,1);
end
%part D
geodetic_location=zeros(length(t_epoch),3);
for i=1:length(t_epoch)
    [geodetic_location(i,1),geodetic_location(i,2),geodetic_location(i,3)]=cartesian2geodetic(table_ITRF(i,5),table_ITRF(i,6),table_ITRF(i,7));
end

%part E
figure(2)
%ax = axesm ('eqdcylin', 'Frame', 'on', 'Grid', 'on', 'LabelUnits', 'degrees', 'MeridianLabel', 'on', 'ParallelLabel', 'on', 'MLabelParallel', 'south');
geoshow('landareas.shp', 'FaceColor', 'black');
hold on
geoshow(rad2deg(geodetic_location(:,1)),rad2deg(geodetic_location(:,2)), 'DisplayType', 'line', 'MarkerEdgeColor', 'red');
axis equal; axis tight;

figure(3)
plot(t_epoch(:), geodetic_location(:,3)/1000);
title(['ellipsoidic height variations [km] around mean height = ' num2str(mean(geodetic_location(:,3))/1000) ' km']);
xlabel('seconds in one day (00:00 - 23:59 = 86400 sec)');
ylabel('[km]');
xlim([1 t_epoch(end)]);

%part F
fid = fopen('GPS_KeplerianOrbit_6parameters.txt','w');

fprintf(fid,'EXPORT FROM MATLAB: GPS_orbit_est.m \n\n');
fprintf(fid,' * Coordinates ORS (xF, yF) || Coordinates ITRF (x, y, z) || Coordinates phi, lambda, h ell\n\n');
for i = 1 : length(t_epoch)
    fprintf(fid, ' %15.6f  %15.6f %15.6f || %15.6f  %15.6f  %15.6f || %15.6f  %15.6f  %15.6f \n',table_ORS(i,6),table_ORS(i,7),table_ORS(i,8),table_ITRF(i,5),table_ITRF(i,6),table_ITRF(i,7),geodetic_location(i,1),geodetic_location(i,2),geodetic_location(i,3));
end
fprintf(fid, '\n');
fclose(fid);

save solution2.mat