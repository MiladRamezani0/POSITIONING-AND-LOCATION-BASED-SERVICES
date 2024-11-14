%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% EX08: Inertial Navigation
% POS&LBS A.A. 2023/2024
% Marianna Alghisi
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear all
close all
clc

% Load user and control points databases
load -ascii 'user_db.txt';
load -ascii 'control_points_db.txt';

% Determine the size of the control_points_db matrix
temp = size(control_points_db);

% Initialize a vector to store the index of the nearest control point for each user point
contronum = ones(length(user_db), 1);

% For each user point
for i = 1:length(user_db)
    % Initialize the maximum absolute difference using the first control point
    mDist = abs(max((user_db(i,2:end) - control_points_db(1,4:end))));
    
    % For each control point
    for j = 1:length(control_points_db)
        % Calculate the minimum absolute difference
        m_newdist = abs(min((user_db(i,2:end) - control_points_db(j,4:end))));
        
        % Update the nearest control point index if a smaller difference is found
        if m_newdist < mDist
            mDist = m_newdist;
            contronum(i) = j;
        end
    end
end

% Extract the X and Y coordinates of the control points associated with each user point
Pcoordinate = control_points_db(contronum, 2:3);

% Plot the user trajectory and control points
figure
plot(Pcoordinate(:, 1), Pcoordinate(:, 2), '-g', control_points_db(:, 2), control_points_db(:, 3), '.b')
axis([-5 25 -5 15])

% Adjust legend properties
legend('User', 'Control Points', 'FontSize', 4)

title('User Trajectory', 'Color', 'r')
grid on