clear; clc; close all; format long g;

c = distinguishable_colors(20);

%% data preparation 
% load table
data = readtable("Run1_OD_2_64.csv");

time = data.Sensor_sTimeStamp;
raw_t = round((time - time(1))/1000, 2); % time in s

Fz = data.filteredFz; % filtered force along Z-axis (losspass)

% zero the highest Force to t=0
index_max = find(Fz == max(Fz));
F = Fz(index_max:end); 
t = raw_t(index_max:end) - (raw_t(index_max)-0.1);

% Cross-sectional area
% A = pi * (1.98e-3/2)^2 - pi * (1.47e-3/2)^2; % cross-sectional area OD 1.98 
A = pi * (2.64e-3/2)^2 - pi * (2.13e-3/2)^2; % cross-sectional area OD 2.64 
% A = pi * (3.3e-3/2)^2 - pi * (2.79e-3/2)^2; % cross-sectional area OD 3.3 

stress = F/A/1e6; % stress OD 1.98mm [MPa]
strain = (17.5-17.3)/17.3; 

%%
% initial guess of the parameters [q0, p0, p1]
p0 = [1, 1, 50];  

% stress_pred = @(p) 0.012 * (p(1) + p(2)*exp(-t/p(3)));

% ODE IVP Solution
esp = 0.012;
stress_pred = @(p) (esp*p(1) - exp(-(p(2).*t)./p(3))*(esp*p(1) - p(2)*stress(1)))/p(2);


% Cost function: sum squared  error
% objective = @(p) sum((stress_pred(p) - stress).^2); 

% Cost function: RMSE
% objective = @(p) rmse(stress, stress_pred(p)); 

% for above 2 cost functions
% [p, fval] = fmincon(objective, p0, [], [], [], [], [], [], []); % for above 2 cost functions

% for R-squared as cost function
[p, fval] = fmincon(@(p)R2(p, stress, esp, t), p0, [], [], [], [], [], [], []); % for R-squared as cost function

disp('q0, p0, p1, and fval:')
disp([p , fval])
error = rmse(stress, stress_pred(p));
disp(['RMSE = ', num2str(error)])

% Calculate the mean of the actual values
mean_actual = mean(stress);

% Calculate the sum of squares of residuals
SS_res = sum((stress - stress_pred(p)).^2);

% Calculate the total sum of squares
SS_tot = sum((stress - mean_actual).^2);

% Compute the R-squared value
R_squared = 1 - (SS_res / SS_tot);

% Display the result
disp(['R-squared value: ', num2str(R_squared)]);


%% Plot the observed data and fitted data
figure(1);
hold on;
plot(t, stress, 'LineWidth', 1.5, 'Color', c(10,:));
plot(t, stress_pred(p), 'LineWidth', 1.5, 'Color', c(11,:))
xlabel('Time [s]');
ylabel('Stress [MPa]');
xlim([0, 1800])
set(gca, 'FontName', 'CMU Serif', 'FontSize', 16);
grid on;
title('Stress Relaxation of OD 2.64 mm Tube w/ ODE solution');
legend({'Collected', 'Prediction'})

%% R-spuared cost function
function value = R2(p, stress, esp, t)

    pred = @(p) (esp*p(1) - exp(-(p(2).*t)./p(3))*(esp*p(1) - p(2)*stress(1)))/p(2);
    
    % Calculate the mean of the actual values
    mean_actual = mean(stress);

    % Calculate the sum of squares of residuals
    SS_res = sum((stress - pred(p)).^2);
    
    % Calculate the total sum of squares
    SS_tot = sum((stress - mean_actual).^2);
    
    % Compute the R-squared value
    R_squared = 1 - (SS_res / SS_tot);

    % reported value for minimization
    value = 1 - R_squared;
end