clc
clear all
close all
format longG
%% input GPS data 
GPS1=readtable('GPS_T1.csv');
E_GPS1=table2array(GPS1(:,"Easting"));
N_GPS1=table2array(GPS1(:,"Northing"));
GPS2=readtable('GPS_T2.csv');
E_GPS2=table2array(GPS2(:,"Easting"));
N_GPS2=table2array(GPS2(:,"Northing"));
%% input Phone data 
Phone_T1=readtable('Phone_T1.csv');
Lat_Phone_T1=table2array(Phone_T1(:,"Latitude"));
Long_Phone_T1=table2array(Phone_T1(:,"Longitude"));
[E_Phone1,N_Phone1,utmzone]=deg2utm(Lat_Phone_T1,Long_Phone_T1);
Phone_T2=readtable('Phone_T2.csv');
Lat_Phone_T2=table2array(Phone_T2(:,"Latitude"));
Long_Phone_T2=table2array(Phone_T2(:,"Longitude"));
[E_Phone2,N_Phone2,utmzone]=deg2utm(Lat_Phone_T2,Long_Phone_T2);
%%
% Plotting
figure;
% Subplot 1: GPS Figures
subplot(4, 3, [1, 4]);
plot(E_GPS1, N_GPS1, '*r');
hold on;
plot(E_GPS2, N_GPS2, '*b');
axis equal;
title('GPS Figures');
% Subplot 2: Phone Figures
subplot(4, 3, [7, 10]);
plot(E_Phone1, N_Phone1, '*g');
hold on;
plot(E_Phone2, N_Phone2, '*y');
axis equal;
title('Phone Figures');
% Subplot 3: Combined GPS Figures
subplot(4, 3, 2);
plot(E_GPS1, N_GPS1, '*r');
hold on;
plot(E_GPS2, N_GPS2, '*b');
axis equal;
title('Combined GPS Figures');
% Subplot 4: Combined Phone Figures
subplot(4, 3, 5);
plot(E_Phone1, N_Phone1, '*g');
hold on;
plot(E_Phone2, N_Phone2, '*y');
axis equal;
title('Combined Phone Figures');
% Subplot 5: GPS and Phone Figures Combined
subplot(4, 3, [3, 6, 8, 9, 11, 12]);
plot(E_GPS1, N_GPS1, '*r');
hold on;
plot(E_GPS2, N_GPS2, '*b');
plot(E_Phone1, N_Phone1, '*g');
plot(E_Phone2, N_Phone2, '*y');
axis equal;
title('Combined GPS and Phone Figures');
% Adjust the layout
sgtitle('Data Comparison');
%%
% Distance GPS1 and Phone1
Min_dist_1 = zeros(length(E_GPS1), 1);
i = 1;
while i <= length(E_GPS1)
    dist_1 = zeros(length(E_Phone1), 1);
    for j = 1:length(E_Phone1)
        dist_1(j) = sqrt((E_GPS1(i) - E_Phone1(j))^2 + (N_GPS1(i) - N_Phone1(j))^2);
    end
    Min_dist_1(i) = min(dist_1);
    i = i + 1;
end
% Distance GPS2 and Phone2
Min_dist_2 = zeros(length(E_GPS2), 1);
i = 1;
while i <= length(E_GPS2)
    dist_2 = zeros(length(E_Phone2), 1);
    for j = 1:length(E_Phone2)
        dist_2(j) = sqrt((E_GPS2(i) - E_Phone2(j))^2 + (N_GPS2(i) - N_Phone2(j))^2);
    end
    Min_dist_2(i) = min(dist_2);
    i = i + 1;
end
%%
% Statistics for first data
Min_1=min(Min_dist_1);
Max_1=max(Min_dist_1);
Average_1=mean(Min_dist_1);
Sigma_1=std(Min_dist_1);
% Statistics for secound data
Min_2=min(Min_dist_2);
Max_2=max(Min_dist_2);
Average_2=mean(Min_dist_2);
Sigma_2=std(Min_dist_2);

%% Create a figure with two subplots
figure;
% Subplot for GPS1 and Phone1
subplot(1, 2, 1);
scatter3(E_GPS1, N_GPS1, Min_dist_1, '.b');
axis equal;
title('Distance GPS1 and Phone1');
% Subplot for GPS2 and Phone2
subplot(1, 2, 2);
scatter3(E_GPS2, N_GPS2, Min_dist_2, '.b');
axis equal;
title('Distance GPS2 and Phone2');
