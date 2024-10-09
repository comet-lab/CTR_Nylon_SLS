clear; clc; close all;
E_e = [870.3319, 853.521, 727.9959];

A1_98 = pi * (1.98e-3/2)^2 - pi * (1.73e-3/2)^2; % cross-sectional area OD 1.98 
A2_64 = pi * (2.64e-3/2)^2 - pi * (2.39e-3/2)^2; % cross-sectional area OD 2.64
A3_3 = pi * (3.3e-3/2)^2 - pi * (3.05e-3/2)^2; % cross-sectional area OD 3.3 
A = [A1_98, A2_64, A3_3];

I1_98 = pi/64 * ((1.98e-3/2)^4 - (1.73e-3/2)^4);
I2_64 = pi/64 * ((2.64e-3/2)^4 - (2.39e-3/2)^4);
I3_3 = pi/64 * ((3.3e-3/2)^4 - (3.05e-3/2)^4);
I = [I1_98, I2_64, I3_3];

K = E_e./(A.^2./I);

figure(1)
scatter(A, K, 'filled', 'o', 'LineWidth', 1.5)
set(gca, 'FontName', 'CMU Serif', 'fontSize', 16)
xticks([A(1), A(2), A(3)])
xticklabels({'OD 1.98mm', 'OD 2.64mm', 'OD 3.3mm'})

grid on;