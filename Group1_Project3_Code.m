clc;
clear;

% It will roughly take 3:15 mins for the plot to complete.

T1      = 300;              % Boundary Temperature
W       = 1;                % Height y
L       = 2;                % Length x

% Here we are dividing the plate into grid of nx+1,ny+1 points 
ny      = 10;               % Number of divisions in the grid in y-direction
nx      = ny*2;             % Since we are divding the plate into square and L is twice as W, therfore ny will be double of nx 



dx      = L/nx;             % length between two grid points in x direction
dy      = W/ny;             % length between two grid points in y direction

dTdx0   = -1;               % Given Boundary conditions 
dTdyW   = -1.5;


% Here T is an array defined in such a way that T' will contain the values
% of Temparature corresponding to the plate dimensions


T = zeros(nx+1,ny+1);       % Initializing the array 

T(:, ny + 1)    = T1;       % Setting the value of T at Given Boundaries as T1(300K)
T(nx + 1,:)     = T1;  
error           = 15;
tol             = 1e-6;

while (error > tol)    
    T0 = T;                         % Bookeeping previous T for calculating Error 
    for i = 1:nx+1                  % Rows
        for j = 1:ny+1              % Column
            if i ~= 1 && j ~= 1 && j~=ny+1 && i~=nx+1                               % for interior points
                T(i, j) = ( T(i, j+1) + T(i, j-1) + T(i+1, j) + T(i-1, j) ) / 4;    % obtained by using finite difference method 

            elseif i ~= 1 && j==1 && i~=nx+1
                T(i, j) = T(i, j+1) + dTdyW * dy;                                   % implementing the boundary conditions
              
            elseif j ~= 1 && i==1 && j~=ny+1                                        % implementing the boundary conditions
                T(i,j) = T(i+1,j) - dTdx0*dx;

            elseif i == 1 && j == 1
                T(i, j) = T(i+1, j) - dTdx0 * dx;
                T(i, j) = T(i, j+1) + dTdyW * dy;
            end 
        end
    end

    error   = sqrt(sumsqr((T-T0)./T));                      % Calculating Error

    clf;
    [x, y]  = meshgrid(linspace(0, L, nx+1),linspace(0, W, ny+1));

    contourf(x, y, flip(T',1), 200, 'LineColor', 'none')    % contour plot (Since contourf, flip and plot the Matrix, So we had flipped it to get desired output)
    colorbar;
    colormap(jet(256))
    title("Temperature distribution of given plate")
    xlabel("x-coordinate")
    ylabel("y-coordinate")
    pause(0.000001);
end

Final_Temperatures = T'
