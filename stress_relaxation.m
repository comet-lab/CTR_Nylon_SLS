clear; clc; close all;

c = distinguishable_colors(20);

%% data preparation (OD 1.98)
data = readtable("Run1_1_98.csv");

time = data.Sensor_sTimeStamp;
raw_t = round((time - time(1))/1000, 2); % time in s

Fz = data.filteredFz; % filtered force along Z-axis (losspass)

index_max = find(Fz == max(Fz));
F = Fz(index_max:end); 
t1 = raw_t(index_max:end) - 15.9;
A1 = pi * (1.98e-3/2)^2 - pi * (1.73e-3/2)^2; % cross-sectional area OD 1.98 
stress1 = F/A1/1e6; % stress OD 1.98mm

figure(1);
plot(t1, stress1', "LineWidth", 1.5)
set(gca, 'fontName', 'CMU Serif', 'fontSize', 16)
xlabel('time [s]')
ylabel('stress [MPa]')
title('Tube Stress (OD 1.98 mm)')
% ylim([0, 20])
xlim([0, 1800])
grid on;

data = readtable("Run2_1_98.csv");

time = data.Sensor_sTimeStamp;
raw_t = round((time - time(1))/1000, 2); % time in s

Fz = data.filteredFz; % filtered force along Z-axis (losspass)

index_max = find(Fz == max(Fz));
F = Fz(index_max:end); 
t01 = raw_t(index_max:end) - 15.9;
A = pi * (1.98e-3/2)^2 - pi * (1.73e-3/2)^2; % cross-sectional area OD 1.98 
stress01 = F/A/1e6; % stress OD 1.98mm

figure(5);
% plot(t01, F)
plot(t01, stress01', "LineWidth", 1.5)
set(gca, 'fontName', 'CMU Serif', 'fontSize', 16)
xlabel('time [s]')
ylabel('stress [MPa]')
title('Tube Stress (OD 1.98 mm)')
% ylim([0, 20])
xlim([0, 1800])
grid on;

%% data prep (OD 2.64)
data = readtable("FT_Sensor_Data03_10_2024_10_52_57.csv");

time = data.Sensor_sTimeStamp;
raw_t = round((time - time(1))/1000, 2); % time in s

Fz = data.filteredFz; % filtered force along Z-axis (losspass)

index_max = find(Fz == max(Fz));
F = Fz(index_max:end); 
t2 = raw_t(index_max:end) - 11.6;
A2 = pi * (2.64e-3/2)^2 - pi * (2.39e-3/2)^2; % cross-sectional area OD 1.98 
stress2 = F/A2/1e6; % stress OD 1.98mm

figure(2);
plot(t2, stress2', "LineWidth", 1.5)
set(gca, 'fontName', 'CMU Serif', 'fontSize', 16)
xlabel('time [s]')
ylabel('stress [MPa]')
title('Tube Stress (OD 2.64 mm)')
% ylim([0, 20])
xlim([0, 1800])
grid on;

%% data prep (OD 3.3)
data = readtable("FT_Sensor_Data03_10_2024_11_32_57.csv");

time = data.Sensor_sTimeStamp;
raw_t = round((time - time(1))/1000, 2); % time in s

Fz = data.filteredFz; % filtered force along Z-axis (losspass)

index_max = find(Fz == max(Fz));
F = Fz(index_max:end); 
t3 = raw_t(index_max:end)-29.1;
A3 = pi * (3.3e-3/2)^2 - pi * (3.05e-3/2)^2; % cross-sectional area OD 1.98 
stress3 = F/A3/1e6; % stress OD 1.98mm

figure(3);
plot(t3, stress3', "LineWidth", 1.5)
set(gca, 'fontName', 'CMU Serif', 'fontSize', 16)
xlabel('time [s]')
ylabel('stress [MPa]')
title('Tube Stress (OD 3.3 mm)')
% ylim([0, 20])
xlim([0, 1800])
grid on;

%%

stress11 = stress1 - max(stress1);
stress22 = stress2 - max(stress2);
stress33 = stress3 - max(stress3);
stress011 = stress01 - max(stress01);
figure(4)
hold on;
plot(t1, stress11, 'LineWidth', 1.5);
plot(t2, stress22, 'LineWidth', 1.5);
plot(t3, stress33, 'LineWidth', 1.5);
% plot(t01, stress011, 'LineWidth', 1.5)
set(gca, 'FontName', 'CMU Serif', 'FontSize', 16)
xlabel('time [s]')
ylabel('stress [MPa]')
grid on;
legend({'OD1.98mm after treatment', 'OD2.64mm', 'OD3.3mm'})