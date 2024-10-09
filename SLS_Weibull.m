clear; clc; close all;
c = distinguishable_colors(20);

%% data preparation
% Times
t = 1:12;
t_pre = 1:2;
t_post = [2:7 12];
labels = {"Before Straightening", "0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "10"};

% Tube Diameters (mm)
OD = [3.3, 2.64, 1.98];

% Number of speciments per tube OD
n = 5;

% Curvature at given times
cbefore = [12.31509	9.35317	10.77079	8.97755	9.02948	10.93576	9.84198	11.35067	9.77144	7.76711	10.94743	10.89157	9.79995	13.80976	6.81244];
c0 = [10.99898	8.19979	8.8425	7.47346	7.34607	9.73037	8.43095	9.25481	8.37001	6.67386	9.67951	9.474	8.28616	11.68277	5.187355556];
c1 = [11.79913	8.84982	9.79127	8.10242	8.10905	10.471	9.26085	9.92032	9.07589	7.01026	10.45108	10.32932	8.87705	12.84899	5.63338];
c2 = [11.90246	8.97262	10.0623	8.24921	8.24762	10.56746	9.48005	10.05565	9.25702	7.0776	10.54447	10.39176	8.94338	12.93974	5.8217];
c3 = [11.96266	9.1217	10.17534	8.29336	8.34552	10.628	9.5002	10.16504	9.30938	7.11074	10.66663	10.49045	9.03873	13.16328	5.870277778];
c4 = [12.11279	9.13063	10.26544	8.39123	8.40418	10.64723	9.57359	10.21155	9.44372	7.24567	10.78294	10.64165	9.14143	13.27489	5.88544];
c5 = [12.11887	9.12957	10.27113	8.45179	8.52718	10.68106667	9.628825	10.3199	9.42408	7.262511111	10.81308889	10.70586	9.21806	13.32345	6.16668];
c10 = [12.29036	9.19655	10.47074	8.58639	8.58677	10.7699	9.67647	10.45208	9.61727	7.35244	10.84498	10.74436	9.32265	13.38594	6.22791];

% Calculate the Bending Radius: Nominal and at t+0hr, t+0.5hr, and t+4hr (mm)
rbefore = 1./cbefore * 1000;
r0 = 1./c0 * 1000;
r1 = 1./c1 * 1000;
r2 = 1./c2 * 1000;
r3 = 1./c3 * 1000;
r4 = 1./c4 * 1000;
r5 = 1./c5 * 1000;
r10 = 1./c10 * 1000;

%%
c = [c0; c1; c2; c3; c4; c5; c10];
k = [];
for i = 1:15
    temp1 = c(:, i);
    temp2 = temp1./temp1(1);
    k = [k, temp2'];
end
time = [0, 1, 2, 3, 4, 5, 10];
tt = [time, time, time, time, time, time, time, time, time, time, time, time, time, time, time];


% Initial Guess
p0 = [2, 1, 5];

k_pred = @(p) 1./ (p(1) + p(2)*exp(-tt/p(3)));

% Objective/Cost Function
% k = reshape(tube1, [1, 40]);
objective = @(p) sum((k_pred(p) - k).^2);

[p, fval] = fmincon(objective, p0, [], [], [], [], [], [], []);

disp('Ee, E1, t1, and fval:')
disp([p , fval])
error = rmse(k, k_pred(p));
disp(['RMSE = ', num2str(error)])

% Calculate the mean of the actual values
mean_actual = mean(k);

% Calculate the sum of squares of residuals
SS_res = sum((k - k_pred(p)).^2);

% Calculate the total sum of squares
SS_tot = sum((k - mean_actual).^2);

% Compute the R-squared value
R_squared = 1 - (SS_res / SS_tot);

% Display the result
disp(['R-squared value: ', num2str(R_squared)]);

%%
curvature = k_pred(p);
figure(1)
hold on;
scatter(tt, k, 'filled')
plot(time, curvature(1:7))
grid on;
ylim([0.85, 1.25])
set(gca, "FontName", 'CMU Serif', 'FontSize', 16)
title('3 Parameter Solid fit to Scaled Data from Unloading Response Experiment')
xlabel('Time Since Straightening [min]')
ylabel('$$\kappa/\kappa_0$$', Interpreter='latex')
