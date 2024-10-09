clear; clc; close all;
c = distinguishable_colors(20);

%% data
% Times
t = [0 0.5 1 1.5 2 4 24 48];

% Tube Diameters (mm)
OD = [3.3, 2.64, 1.98];

% Number of speciments per tube OD
n = 5;

% Nominal Curvature (m^-1)
c_nominal = 20;

% Curvature at given times
c0 = [17.30778	18.05598	17.62079	16.81997	16.81849	17.45415	18.44607	18.2113375	17.0247	16.92785	17.12467	18.69455	18.37444	16.49196	17.03821];
c0_5 = [13.92838	15.09799	14.17737	14.06741	12.88529	14.38639	15.38363	14.57354	13.37316	14.02309	15.45006	14.83171	16.86129	13.40585	14.02348];
c1 = [13.52451	14.51855	13.35047	13.37263	12.09968	NaN	14.81256	13.8754	12.54314	13.29897	14.56303	14.65816	16.74375	12.48317	13.23512];
c1_5 = [13.19151	14.02515	12.9556	13.01089	11.58462	13.29171	14.60376	13.56491	12.08651	12.8246	14.09424	14.01165	16.42812	11.89451	12.68456];
c2 = [12.80267	13.63128	12.73062	12.76704	11.14581	13.00526	14.17639	13.32311	11.76491	12.51925	13.95657	13.60454	16.12908889	11.6693	12.32655];
c4 = [12.25764	13.2703	12.08258	12.37369	10.47633	12.59474	13.852875	13.1974	11.08627	12.06393	13.4533	12.98155	16.1265	10.75319	11.29866];
c24 = [10.48561	11.83083	10.43835	11.12082	8.73663	11.07605	12.85178	11.47414	9.23158	11.13155	13.17908	11.64981	15.3303	8.67957	9.3492];
c48 = [10.12283	11.48116	9.97724	9.80391	7.939	10.72232	12.26865	10.93027	8.17978	9.90788	12.52505	10.72055	14.8445	7.60754	8.2595];

% Calculate the Bending Radius: Nominal and at t+0hr, t+0.5hr, and t+4hr (mm)
r_nominal = 1/c_nominal * 1000;
r0 = 1./c0 * 1000;
r0_5 = 1./c0_5 * 1000;
r1 = 1./c1 * 1000;
r1_5 = 1./c1_5 * 1000;
r2 = 1./c2 * 1000;
r4 = 1./c4 * 1000;
r24 = 1./c24 * 1000;
r48 = 1./c48 * 1000;

%% 
cc = [c0; c0_5; c1; c1_5; c2; c4; c24; c48];

tube1 = cc(:, 1:5);
tube2 = cc(:, 6:10);
tube3 = cc(:, 11:15);


% Initial Guess
p0 = [400, 100, 425];

% Curvature Prediction
% tt = [t, t, t, t, t];
tt = t;
k = tube1(:, 3)';

k_pred = @(p)  (p(1) + p(2)*exp(-tt/p(3)));

% Objective/Cost Function
% k = reshape(tube1, [1, 40]);
objective = @(p) sum((k_pred(p) - k).^2);

[p, fval] = fmincon(objective, p0, [], [], [], [], [], [], []);

disp('Ee, E1, t1, and fval:')
disp([p , fval])
error = rmse(k, k_pred(p));
disp(['RMSE = ', num2str(error)])

kk = reshape(tube1, [1,40]);
% Calculate the mean of the actual values
mean_actual = mean(kk);

% Calculate the sum of squares of residuals
SS_res = sum((k - k_pred(p)).^2);

% Calculate the total sum of squares
SS_tot = sum((k - mean_actual).^2);

% Compute the R-squared value
R_squared = 1 - (SS_res / SS_tot);

% Display the result
disp(['R-squared value: ', num2str(R_squared)]);

kk = k_pred(p);
figure(1)
hold on; grid on;
plot(t, tube1(:, 1), 'Marker','o');
plot(t, tube1(:, 2), 'Marker','o');
plot(t, tube1(:, 3), 'Marker','o');
plot(t, tube1(:, 4), 'Marker','o');
plot(t, tube1(:, 5), 'Marker','o');
plot(t, kk(1:8), 'Marker','o', 'Color', 'k', 'LineWidth', 1.5)
xlabel('time [hr]')
ylabel('\kappa')
set(gca, 'FontName', 'CMU Serif', 'FontSize', 16)
legend({'Tube 1', 'Tube 2', 'Tube 3', 'Tube 4', 'Tube 5', 'Prediction'})

%% figure 2: zoomed in version (0-2 hr)
tb1 = tube1(:,1)';
tb2 = tube1(:,2)';
tb3 = tube1(:,3)';
tb4 = tube1(:,4)';
tb5 = tube1(:,5)';

figure(2)
hold on; grid on;
plot(t(1:5), tb1(1:5), 'Marker','o')
plot(t(1:5), tb2(1:5), 'Marker','o')
plot(t(1:5), tb3(1:5), 'Marker','o')
plot(t(1:5), tb4(1:5), 'Marker','o')
plot(t(1:5), tb5(1:5), 'Marker','o')
plot(t(1:5), kk(1:5), 'Marker','o', 'Color', 'k', 'LineWidth', 1.5)
xlabel('time [hr]')
ylabel('\kappa')
set(gca, 'FontName', 'CMU Serif', 'FontSize', 16)
legend({'Tube 1', 'Tube 2', 'Tube 3', 'Tube 4', 'Tube 5', 'Prediction'})
title('Zoomed: Manufactured Repeatability')
