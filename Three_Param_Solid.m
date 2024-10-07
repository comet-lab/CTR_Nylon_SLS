clear; clc; close all;

c = distinguishable_colors(20);

%% data preparation (OD 1.98mm)
data = readtable("Run1_1_98.csv");

time = data.Sensor_sTimeStamp;
raw_t = round((time - time(1))/1000, 2); % time in s

Fz = data.filteredFz; % filtered force along Z-axis (losspass)

index_max = find(Fz == max(Fz));

F = Fz(index_max:end); 
t = raw_t(index_max:end) - 15.9;
A = pi * (1.98e-3/2)^2 - pi * (1.73e-3/2)^2; % cross-sectional area OD 1.98 
stress = F/A; % stress OD 1.98mm
strain = (17.5-17.3)/17.3;

%%
p0 = [1, 0.1, 01];  % initial guess of the parameters [q0, p0, p1]
stress_pred = @(p) 0.0116 * (p(1) + p(2)*exp(-t/p(3)));

objective = @(p) sum((stress_pred(p) - stress).^2);

[p, fval] = fmincon(objective, p0, [], [], [], [], [], [], [])

%%
figure(1);
plot(t, stress, 'LineWidth', 1.5, 'Color', c(10,:));
% plot(t, sp, 'LineWidth', 1.5, 'Color', c(11,:))
xlabel('Time [s]');
ylabel('Stress [Pa]');
set(gca, 'FontName', 'CMU Serif', 'FontSize', 16);
grid on;
title('Stress Relaxation of OD 1.98 mm Tube');

