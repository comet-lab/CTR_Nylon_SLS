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
stress = (F/A)/1e6; % stress OD 1.98mm (MPa)
strain = (17.5-17.3)/17.3;

%% Compare p0/p1 for 3 tubes


plot(t, stress)
xlabel('time [s]')
ylabel('stress [MPa]')
grid on;

%% solver functions


