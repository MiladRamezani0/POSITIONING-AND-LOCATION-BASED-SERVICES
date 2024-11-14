function[x_y] = CalcTrajectory(acc, omegaz, epoch)
    acc_x = acc(:, 1);
    acc_y = acc(:, 2);
    w = omegaz;
    
    alpha = 0;
    velocity_x = 0;
    velocity_y = 0;
    x_y = [100 100];
    x = x_y(1);
    y = x_y(2);
    dx = 0;
    dy = dx;
    centr_y = 0;

    for i = 2 : length(acc_x)
        dt = epoch(i) - epoch(i-1);
  
        velocity_x = [velocity_x; velocity_x(i-1) + acc_x(i) * dt]; 
        velocity_y = [velocity_y; velocity_y(i-1) + acc_y(i) * dt];
    
        x = [x; x(i-1) + velocity_x(i-1) * dt + 1/2 * acc_x(i) * dt^2];
        dx = [dx; x(i) - x(i-1)]; 

        y = [y; y(i-1) + velocity_y(i-1) * dt + 1/2 * acc_y(i) * dt^2];
        dy = [dy; y(i) - y(i-1)]; 

        x_y = [x_y; x(i) y(i)];    

        centr_y = [centr_y; sqrt(velocity_x(i-1)^2 + velocity_y(i-1)^2) * w(i)]; %

        acc_y(i) = acc_y(i) - centr_y(i); %

        velocity_y(i) = velocity_y(i-1) + acc_y(i) * dt; 

        y(i) = y(i-1) + velocity_y(i-1) * dt + 1/2 * acc_y(i) * dt^2;
        dy(i) = y(i) - y(i-1);
 
        delta_xy = [dx dy];
        x_y(i, 2) = y(i);

        alpha = [alpha; alpha(i-1) + w(i) * dt]; 
        R = [cos(alpha(i)) sin(alpha(i)); -sin(alpha(i)) cos(alpha(i))]; 

        x_y(i, :) = x_y(i-1, :) + delta_xy(i, :) * R';
        x(i) = x_y(i, 1);
        y(i) = x_y(i, 2);
    end
end
