clear; clc; close all;
c = distinguishable_colors(20);

%% Data Preparation
% Tube dimensions
OD = [2.64];

% Outer tube
OD_outer = 0.00264; % [m]
ID_outer = 0.002132; % [m]
k0_outer_0 = 1000 ./ [116.34571	111.79054	103.93466	111.18182	110.10815]; % [m^-1]
k0_outer_f = 1000 ./ [132.56567	124.58774	119.51005	128.29112	121.31294]; % [m^-1]

% Inner tube
OD_inner = 0.001980; % [m]
ID_inner = 0.001473; % [m] 
k0_inner = zeros([1 5]); % [m^-1]

% Moments of area
I_outer = pi/64 * (OD_outer ^ 4 - ID_outer ^ 4);
I_inner = pi/64 * (OD_inner ^ 4 - ID_inner ^ 4);

% Calc equilibrium curvature
k_eq_0 = (I_outer * k0_outer_0 + I_inner * k0_inner) / (I_outer + I_inner);
k_eq_f = (I_outer * k0_outer_f + I_inner * k0_inner) / (I_outer + I_inner);

% Calculate the Bending Radius: Nominal and at t+0hr, t+0.5hr, and t+4hr (mm)
r_expected_0 = 1./k_eq_0 * 1000;
r_expected_f = 1./k_eq_f * 1000;
r0 = [163.96829	152.60276	152.717	158.86293	151.43352];
r1 = [167.17217	158.14961	156.54795	164.59333	152.29993];
r2 = [171.12783	157.03563	158.00595	164.8651	153.03895];
r3 = [172.8245	158.60564	158.4371667	166.97496	152.45823];
r4 = [172.26807	160.08575	158.22185	167.71882	154.89371];
r5 = [172.98626	162.0468	160.93645	169.45387	152.59967];
r10 = [173.2665	161.89352	160.69986	170.34464	155.35012];
r15 = [176.89257	161.1974	160.89973	171.89173	155.45192];
r20 = [178.47626	161.64841	162.01341	171.51401	154.74017];
r25 = [178.77399	162.58633	162.20889	173.0765875	155.33082];
r30 = [179.00462	163.5390222	163.3554222	173.69946	156.4227125];

%% Constitutive Term
% p = [mean([416.1838, 456.9826]), mean([108.3145, 118.1388]), ... 
%     mean([440.6039, 425.7588])]; % parameters for 3 Parameter Solid

p0 = [10    6.2999    1];
t = [0 1 2 3 4 5 10 15 20 25 30];
rr = [r0; r1; r2; r3; r4; r5; r10; r15; r20; r25; r30];

CT = @(p) 1./( p(1) + p(2) .* exp(-t./p(3)) ); % for creep
objective = @(p) sum((rr(:,1)' - CT(p) .* r_expected_0(1)).^2);

[p, fval] = fmincon(objective, p0, [], []);
disp(['p = ', num2str([p(1), p(2), p(3)])])
disp(['fval = ', num2str(fval)])


%% Fitting Result (Trail 1)
% t = [0 1 2 3 4 5 10 15 20 25 30];
% rr = [r0; r1; r2; r3; r4; r5; r10; r15; r20; r25; r30];

r_ct = r_expected_0(1) * CT(p);

figure(1)
hold on; grid on;
plot(t, rr(:,1), 'Marker','o','MarkerSize',3, 'LineWidth', 1.5)
plot(t, r_ct, 'Marker','o','MarkerSize',3, 'LineWidth', 1.5)
plot(t, r_expected_0(1).*ones(1, 11) , 'LineWidth', 1.5, 'Color', 'r')
ylim([160, 185])
set(gca, 'FontName', 'CMU Serif', 'FontSize', 16)
ylabel('Equilibrium Bending Radius [mm]')
xlabel('Time Since Tube Insertion [min]')
legend({'Observed', 'Fitting (3 Parameter Solid)', 'Estimation (Linear Elasticity)'})
title('Fitting the Parameters')
%% Testing Case (Trail 3)
r_ct = r_expected_0(3) * CT(p);

figure(2)
hold on; grid on;
plot(t, rr(:,3), 'Marker','o','MarkerSize',3, 'LineWidth', 1.5)
plot(t, r_ct, 'Marker','o','MarkerSize',3, 'LineWidth', 1.5)
plot(t, r_expected_0(3).*ones(1, 11) , 'LineWidth', 1.5, 'Color', 'r')
ylim([140, 165])
set(gca, 'FontName', 'CMU Serif', 'FontSize', 16)
ylabel('Equilibrium Bending Radius [mm]')
xlabel('Time Since Tube Insertion [min]')
legend({'Observed', 'Estimation (3 Parameter Solid)', 'Estimation (Linear Elasticity)'})
title('Testing the Parameters')

%% Testing Case (Trail 4)
r_ct = r_expected_0(4) * CT(p);

figure(3)
hold on; grid on;
plot(t, rr(:,4), 'Marker','o','MarkerSize',3, 'LineWidth', 1.5)
plot(t, r_ct, 'Marker','o','MarkerSize',3, 'LineWidth', 1.5)
plot(t, r_expected_0(4).*ones(1, 11) , 'LineWidth', 1.5, 'Color', 'r')
ylim([150, 175])
set(gca, 'FontName', 'CMU Serif', 'FontSize', 16)
ylabel('Equilibrium Bending Radius [mm]')
xlabel('Time Since Tube Insertion [min]')
legend({'Observed', 'Estimation (3 Parameter Solid)', 'Estimation (Linear Elasticity)'})
title('Testing the Parameters')