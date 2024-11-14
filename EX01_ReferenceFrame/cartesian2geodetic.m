% function [phi,lambda,h] = cartesian2geodetic(x,y,z)
%     a=6378137;
%     f = 1/298.257222100882711243;
%     b=(1-f)*a;
%     e=sqrt(1-(b^2/a^2));
%     r=sqrt(x^2+y^2+z^2);
%     lambda = atan2(y,x);
%     phic=atan(z/sqrt(x^2+y^2));
%     psi=atan(tan(phic)/sqrt(1-e^2));
%     phi = atan(r*sin(phic+e^2*a/sqrt(1-e^2)*(sin(psi))^3) / ...
%         r*(cos(phic)-e^2*a*(cos(psi))^3));
%     N=a/sqrt(1-(e^2)*sin(phi)^2);
%     h=r*cos(phic)/cos(phi)-N;
%     phi=rad2deg(phi);
%     lambda=rad2deg(lambda);
% end

function [phi, lambda, h] = cartesian2geodetic(x, y, z)
    a = 6378137; % Semi-major axis of the Earth
    f = 1/298.257222100882711243; % Flattening of the Earth
    b = (1 - f) * a; % Semi-minor axis of the Earth
    e = sqrt(1 - (b^2 / a^2)); % Eccentricity of the Earth
    r = sqrt(x^2 + y^2 + z^2); % Distance from the origin
    lambda = atan2(y, x); % Longitude calculation
    % Iterative calculation for latitude (phi)
    phic = atan(z / sqrt(x^2 + y^2));
    phi = atan((z + e^2 * a * sin(phic)^3) / (r - e^2 * a * cos(phic)^3));
    % Iterative calculation for height (h)
    N = a / sqrt(1 - e^2 * sin(phi)^2);
    h = r / cos(phi) - N;
    % Convert radians to degrees
    phi = rad2deg(phi);
    lambda = rad2deg(lambda);
end