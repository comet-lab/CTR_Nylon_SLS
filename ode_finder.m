clear; clc; close all;
% Define symbolic variables
syms p0 p1 q0 q1 sigma(t) epsilon0 sigma0

% Substitute epsilon(t) with a constant epsilon0
epsilon_val = epsilon0;

% Define the differential equation with the given constraints
eqn = p0 * sigma(t) + p1 * diff(sigma(t), t) == q0 * epsilon_val + q1 * 0;

% Specify the initial condition
initialCond = sigma(0) == sigma0;

% Solve the differential equation symbolically
solution = dsolve(eqn, initialCond);

% Display the solution
disp(solution);


stress = @(t) (epsilon0*q0 - exp(-(p0*t)/p1)*(epsilon0*q0 - p0*sigma0))/p0;
disp(stress(0));