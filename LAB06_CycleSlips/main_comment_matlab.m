% Positioning & Location Based Services
% A.A. 2023/2024
% EX05: DD analysis and cycle slip identification and repairing
% Author: Marianna Alghisi
% -------------------------------------------------------------------------
% Guidelines
%
% Input data = 'CycleSlipsData.txt' text file with
%              col1 = epoch [s]
%              col2 = observed DD [m]
%              col3 = approx DD [m]
%
% 1) Import data in Matlab and graph observed DDs
clear
close all
clc
[newdata] = importdata('CycleSlipsDataSun.txt', '	', 1);
idata = newdata.data;  %we have 3 columns: epochs, DD_obs, DD_apr

epochs = idata(:,1);
DD_obs = idata(:,2);
DDaprx = idata(:,3);


threshold = 3.8 * 1e-2;
lam = 19 * 1e-2;

% Step 2: Plot observed DDs
figure;

subplot(2,3,1);
plot(epochs, DD_obs, '-y');
title('Observed DDs');

% Step 3: Compute and plot residual DDs
DD_residual = DD_obs - DDaprx;

subplot(3,3,2);
plot(epochs, DD_residual, '-g');
ylabel('DD residual');
title('Residual DDs');

% Step 4: Compute and plot differences between consecutive epochs of residual DDs
DD_diff = diff(DD_residual);

subplot(2,3,3);
plot(epochs(1:end-1), DD_diff, '-r');
ylabel('DD diff');
title('Differences between Residual DDs');

% Step 5: Identify and repair cycle slips
n = 0;
DD_corr = DD_obs;
x = 0;

for i = 1:length(DD_diff)
    if abs(DD_diff(i)) > threshold
        x = DD_diff(i) / lam;
        n = round(x);
    end

    DD_corr(i+1) = ((lam * abs(n - x)) <= threshold) * (DD_obs(i+1) - lam * n);
end

% Step 6: Plot corrected DDs
subplot(2,3,4);
plot(epochs, DD_corr, '-c');
ylabel('DD corr');
title('Corrected DDs');

% Step 7: Compute and plot corrected residuals
DD_res_corr = DD_corr - DDaprx;

subplot(2,3,5);
plot(epochs, DD_res_corr, '-b');
ylabel('DD residual corr');
title('Corrected Residual DDs');

% Step 8: Compute and plot differences between consecutive epochs of corrected residuals
DD_diff_corr = diff(DD_res_corr);

subplot(2,3,6);
plot(epochs(1:end-1), DD_diff_corr, '-m');
ylabel('DD diff residual corr');
title('Differences between Corrected Residual DDs');
