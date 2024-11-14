clc
clear
format long g
% Getting observation values
run('Ex04_variables.m')
c = s_light;


%% Part 1 without cutoff angle
disp('Part 1:')

% Initialization of parameters
X0 = [0, 0, 0, 0]';
X = X0;
% Number of observations
m = length(pr_C1);
n = length(X);
% Max number of iterations
max_iter = 10;
% Threshold for convergence
convergence = 0.1;
% Storage of iterate results
% Least squares iteration
% Initializing matrices and variables for calculations
az = zeros(m, 1); % Azimuth angle
el = zeros(m, 1); % Elevation angle
rho = zeros(m, 1); % Distance
tropo_corrections = zeros(m, 1);
iono_corrections = zeros(m, 1);
A = zeros(m, n);
b = zeros(m, 1);
disp(['Number of observations: ', num2str(m)])
disp(['Number of unknown parameters: ', num2str(n)])

for i = 1:max_iter
    % Approximate geodetic coordinates of the receiver
    [phi, lambda, h] = cartesian2geodetic(X(1, 1), X(2, 1), X(3, 1));

    for j = 1:m
        [az(j, 1), el(j, 1), rho(j, 1)] = topocent(X, xyz_sat(j, :));
        % Tropospheric and ionospheric corrections
        tropo_corrections(j, 1) = tropo_correction(h, el(j, 1));
        iono_corrections(j, 1) = iono_correction(phi, lambda, az(j, 1), el(j, 1), time_rx, ionoparams);
        % LS A matrix
        A(j, :) = [(1 / rho(j, 1)) * (X(1, 1) - xyz_sat(j, 1)), (1 / rho(j, 1)) * (X(2, 1) - xyz_sat(j, 2)), (1 / rho(j, 1)) * (X(3, 1) - xyz_sat(j, 3)), 1];
        % LS known term
        b(j, 1) = iono_corrections(j, 1) + tropo_corrections(j, 1) + rho(j, 1) - (c * dtS(j, 1));
    end
    % Least square solution for the corrections to the apriori
    delta_L = pr_C1 - b;
    Q = eye(length(A));
    N = A' * A;
    % Estimated coordinates of the receiver: 
    incognite_stima = inv(N) * A' * inv(Q) * delta_L;
    % Approximate + estimated correction
    X_R(1:3, 1) = X(1:3, 1) + incognite_stima(1:3, 1);
    X_R(4, 1) = incognite_stima(4, 1);
    X_prev = X;
    X = X_R;
    delta_x = X - X_prev;
    % Check convergence of the result and exit if converged
    if max(abs(delta_x)) < convergence
        break
    end
    % Check if convergence failed at the end
    if i == max_iter
        disp('Convergence failed');
    end
end
disp(['Number of loop repetitions: ', num2str(i)])
disp('Delta_x:')
disp(delta_x)
disp('Estimated coordinates of Receiver (E, N, h):')
disp(['Easting (X): ', num2str(X(1, 1))])
disp(['Northing (Y): ', num2str(X(2, 1))])
disp(['Height (h): ', num2str(X(3, 1))])
dtR = X_R(4, 1) / c;
X(4, 1) = X_R(4, 1) / c;
disp(['Estimated dt Receiver = ', num2str(dtR)])
% Residuals and sigma2
y_estimate = A * X + b;
v = pr_C1 - y_estimate;
sigmaq_est = (v' * Q * v) / (m - n);
% covariance matrix of the estimated coordinates
Cxx = sigmaq_est(1,1)* inv(N);
disp('Covariance matrix (C_xx):')
disp(Cxx)
phi=deg2rad(phi);
lambda=deg2rad(lambda);
% PDOP computation
R = [-sin(lambda), cos(lambda), 0;
    -sin(phi) * cos(lambda), -sin(phi) * sin(lambda), cos(phi);
    cos(phi) * cos(lambda), cos(phi) * sin(lambda), sin(phi)];
Q_geom = inv(N);
Q_geom = Q_geom(1:3, 1:3);
Q_at = R * Q_geom * R';
PDOP = sqrt(trace(Q_at));
disp(['PDOP = ', num2str(PDOP)])
%% part 2 with 5 degrees cutoff angle on elevation
disp('------------------------------------------------------------------------------------------------------')
disp('part 2:')
CutOfAngle=5;
xyz_sat_new=zeros(m,3);
pr_C1_new=zeros(m,1);
for i=1:m
    [~,el,~]=topocent(X(1:3,1), xyz_sat(i,1:3));
    if abs(el)>CutOfAngle
        xyz_sat_new(i,:)=xyz_sat(i,:);
        pr_C1_new(i,1)=pr_C1(i,1);
    end

end
rows_with_zeros = all(xyz_sat_new == 0, 2);
xyz_sat_new = xyz_sat_new(~rows_with_zeros, :);
xyz_sat=xyz_sat_new;

rows_with_zeros = all(pr_C1_new == 0, 2);
pr_C1_new = pr_C1_new(~rows_with_zeros, :);
pr_C1=pr_C1_new;

% Number of observations
m = length(pr_C1);
n = length(X);
% Max number of iterations
max_iter = 10;
% Threshold for convergence
convergence = 0.1;
% Storage of iterate results
% Least squares iteration
% Initializing matrices and variables for calculations
az = zeros(m, 1); % Azimuth angle
el = zeros(m, 1); % Elevation angle
rho = zeros(m, 1); % Distance
tropo_corrections = zeros(m, 1);
iono_corrections = zeros(m, 1);
A = zeros(m, n);
b = zeros(m, 1);
disp(['number of observations: ',num2str(m)])
disp(['number of uknown parameters: ',num2str(n)])
for i = 1:max_iter
    % Approximate geodetic coordinates of the receiver
    [phi, lambda, h] = cartesian2geodetic(X(1, 1), X(2, 1), X(3, 1));

    for j = 1:m
        [az(j, 1), el(j, 1), rho(j, 1)] = topocent(X, xyz_sat(j, :));
        % Tropospheric and ionospheric corrections
        tropo_corrections(j, 1) = tropo_correction(h, el(j, 1));
        iono_corrections(j, 1) = iono_correction(phi, lambda, az(j, 1), el(j, 1), time_rx, ionoparams);
        % LS A matrix
        A(j, :) = [(1 / rho(j, 1)) * (X(1, 1) - xyz_sat(j, 1)), (1 / rho(j, 1)) * (X(2, 1) - xyz_sat(j, 2)), (1 / rho(j, 1)) * (X(3, 1) - xyz_sat(j, 3)), 1];
        % LS known term
        b(j, 1) = iono_corrections(j, 1) + tropo_corrections(j, 1) + rho(j, 1) - (c * dtS(j, 1));
    end
    % Least square solution for the corrections to the apriori
    delta_L = pr_C1 - b;
    Q = eye(length(A));
    N = A' * A;
    % Estimated coordinates of the receiver: 
    incognite_stima = inv(N) * A' * inv(Q) * delta_L;
    % Approximate + estimated correction
    X_R(1:3, 1) = X(1:3, 1) + incognite_stima(1:3, 1);
    X_R(4, 1) = incognite_stima(4, 1);
    X_prev = X;
    X = X_R;
    delta_x = X - X_prev;
    % Check convergence of the result and exit if converged
    if max(abs(delta_x)) < convergence
        break
    end
    % Check if convergence failed at the end
    if i == max_iter
        disp('Convergence failed');
    end
end
disp(['Number of loop repetitions: ', num2str(i)])
disp('Delta_x:')
disp(delta_x)
disp('Estimated coordinates of Receiver (E, N, h):')
disp(['Easting (X): ', num2str(X(1, 1))])
disp(['Northing (Y): ', num2str(X(2, 1))])
disp(['Height (h): ', num2str(X(3, 1))])
dtR = X_R(4, 1) / c;
X(4, 1) = X_R(4, 1) / c;
disp(['Estimated dt Receiver = ', num2str(dtR)])
% Residuals and sigma2
y_estimate = A * X + b;
v = pr_C1 - y_estimate;
sigmaq_est = (v' * Q * v) / (m - n);
% covariance matrix of the estimated coordinates
Cxx = sigmaq_est(1,1)* inv(N);
disp('Covariance matrix (C_xx):')
disp(Cxx)
phi=deg2rad(phi);
lambda=deg2rad(lambda);
% PDOP computation
R = [-sin(lambda), cos(lambda), 0;
    -sin(phi) * cos(lambda), -sin(phi) * sin(lambda), cos(phi);
    cos(phi) * cos(lambda), cos(phi) * sin(lambda), sin(phi)];
Q_geom = inv(N);
Q_geom = Q_geom(1:3, 1:3);
Q_at = R * Q_geom * R';
PDOP = sqrt(trace(Q_at));
disp(['PDOP = ', num2str(PDOP)])
% print
disp('-------------------------------------------------------------');
COA_print = sprintf('Cut off Angle: %d',CutOfAngle);
disp(COA_print);
i_print = sprintf('The total number of iterations (COA) is: %d', i);
disp(i_print);
coord_print = sprintf('The coordinates of the receiver (COA) are: [%d %d %d]', X(1:3,1));
disp(coord_print);
offset_print = sprintf('The clock offset of the receiver (COA) is: %d', X(4,1));
disp(offset_print);
PDOP_print = sprintf('PDOP (COA) value is %f', PDOP);
disp(PDOP_print);