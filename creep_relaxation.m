clear; clc; close all;
c = distinguishable_colors(20);

%%
data = readtable("Run1_1_98.csv");

time = data.Sensor_sTimeStamp;
raw_t = round((time - time(1))/1000, 2); % time in s

Fz = data.filteredFz; % filtered force along Z-axis (losspass)

index_max = find(Fz == max(Fz));

F = Fz(index_max:end); 
t = raw_t(index_max:end) - 15.9;

A = pi * (1.98e-3/2)^2 - pi * (1.73e-3/2)^2; % cross-sectional area OD 1.98 
% A = pi * (2.64e-3/2)^2 - pi * (2.39e-3/2)^2; % cross-sectional area OD 2.64 
% A = pi * (3.3e-3/2)^2 - pi * (3.05e-3/2)^2; % cross-sectional area OD 3.3 

stress = F/A/1e6; % stress OD 1.98mm [MPa]
strain = (17.5-17.3)/17.3; 

%%
p0 = [800, 220, 440];  % initial guess of the parameters [Ee, E1, t1]
stress_pred = @(p) 0.014 * (p(1) + p(2)*exp(-t/p(3)));

objective = @(p) sum((stress_pred(p) - stress).^2);
% objective = @(p) rmse(stress, stress_pred(p));

[p, fval] = fmincon(objective, p0, [], [], [], [], [], [], []);
disp('Ee, E1, t1, and fval:')
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

%% Creep Modulus
% creep_pred = @(p) 1/stress_pred(p);
G = @(p) stress_pred(p)/0.014; % Relaxation Modulus
J = @(p) 1./G(p); % Creep Modulus


%% Stress Relaxation Parameter Fitting
figure(1);
hold on;
plot(t, stress, 'LineWidth', 1.5, 'Color', c(10,:));
plot(t, stress_pred(p), 'LineWidth', 1.5, 'Color', c(11,:))
xlabel('Time [s]');
ylabel('Stress [MPa]');
xlim([0, 1800])
set(gca, 'FontName', 'CMU Serif', 'FontSize', 16);
grid on;
title('Stress Relaxation of OD 1.98 mm Tube');
legend({'Collected Relaxation', 'Predicted Relaxation'})

%% Compare Modulus
GG = G(p);
JJ = 1./(GG./1000);

figure(2);
hold on;
plot(t, GG./1000, 'LineWidth', 1.5)
plot(t, JJ, 'LineWidth', 1.5)
grid on;
legend({'Normalized Relaxation Modulus', 'Normalized Creep Modulus'}, 'Location', 'southwest')
set(gca, 'FontName', 'CMU Serif', 'FontSize', 16);
title('Modulus Comparison')