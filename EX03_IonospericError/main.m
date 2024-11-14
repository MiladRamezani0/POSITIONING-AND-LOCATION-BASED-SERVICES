clc
clear
close all
format long

%load parameters
line1 = 'GPSA 7.4506D-09 1.4901D-08 -5.9605D-08 -1.1921D-07 IONOSPHERIC CORR';
line2 = 'GPSB 9.2160D+04 1.3107D+05 -6.5536D+04 -5.2429D+05 IONOSPHERIC CORR';
ionoparams = [cell2mat(textscan(line1, '%*s %f %f %f %f %*s')) ...
cell2mat(textscan(line2, '%*s %f %f %f %f %*s'))];
%% part 1
% zenithal maps of Iono corrections
el=90;
az=0;
lat= -80:0.5:80;
lon= -180:0.5:180;
time=[0 6 12 18]*60*60;

delay=zeros(length(lat),length(lon),length(time));
for i=1:4
    for j=1:length(lat)
        for k=1:length(lon)
            [delay(j,k,i)]=iono_correction(lat(j), lon(k), az, el, time(i), ionoparams);
        end
    end
end

% plots
[phi_grid,lambda_grid] = meshgrid(lat,lon);
figure(1)
title('Ionospheric Error Maps')
for i = 1:length(time)
    subplot(2,2,i);
    geoshow(phi_grid, lambda_grid, delay(:,:,i), 'DisplayType','texturemap','facealpha',.5)
    hold on
    geoshow('landareas.shp', 'FaceColor', 'none');
    title(['time = ', num2str(time(i)/3600),':00']);
    xlabel('longitude [deg]')
    ylabel('latitude [deg]')
    xlim([-180 180]);
    ylim([-80 80]);
    colormap(jet);
end
hp4 = get(subplot(2,2,4),'Position');
colorbar('Position', [hp4(1)+hp4(3)+0.028  hp4(2)  0.03  hp4(2)+hp4(3)*2.1]);

%% part 2

% Milano position in degrees
lat = 45 + 28 / 60 + 38.28 / 60^2; %degrees
lon = 9 + 10 / 60 + 53.40 / 60^2; %degrees
time=[0, 12]*60*60;
az=-180:0.5:180;
el=0:0.5:90;
delay2=zeros(length(el),length(az),length(time));

for i=1:2
for j=1:length(el)
    for k=1:length(az)
        delay2(j,k,i)=iono_correction(lat, lon, az(k), el(j), time(i), ionoparams);
    end
end
end

%plots
[Az, El] = meshgrid(az, el);
for i = 1 : length(time)
    figure(i + 1)
    title(['Ionospheric Error Polar Map for Milan Observer time = ', num2str(time(i)/3600),':00'])
    axesm('eqaazim', 'MapLatLimit', [0 90]);
    axis off
    framem on
    gridm on
    mlabel on
    plabel on;
    setm(gca,'MLabelParallel',0)
    geoshow(El, Az, delay2(:,:,i), 'DisplayType','texturemap', 'facealpha',.6)
    colormap(jet)
    hcb = colorbar('eastoutside');
    set(get(hcb,'Xlabel'),'String','Legend')
end