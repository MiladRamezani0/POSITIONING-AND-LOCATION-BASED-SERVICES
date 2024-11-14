clc
clear all
%load data without errors
data = load("Inertial_data.dat");
epoch = data(:, 1);
%accelerations
acc = data(:, 2:3); 
%omega in zed
omegaz = data(:,4);
%load data with errors (repeat)
%call function to compute trajectory without errors
traject = CalcTrajectory(acc, omegaz, epoch);
%call function to compute trajectory with errors
%plot comparison on the same plot
%%
%load data with errors
data_ni = load("Inertial_data_ni.dat");
epoch_ni = data_ni(:, 1);
%accelerations
acc_ni = data_ni(:, 2:3); 
%omega in zed
omegaz_ni = data_ni(:,4);
%call function to compute trajectory with errors
traject_ni = CalcTrajectory(acc_ni, omegaz_ni, epoch_ni);

%%
plot(traject(:, 1), traject(:, 2), 'LineWidth', 2,'Color','Red'); 
hold on;
plot(traject_ni(:, 1), traject_ni(:, 2), 'LineWidth', 2,'Color','Blue'); 
legend('Trajectory Without Errors', 'Trajectory With Errors', 'Location', 'Southwest'); 
