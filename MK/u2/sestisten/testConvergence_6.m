% Test script for meridian convergence in the gnomonic projection.
clear; clc;

R = 1;

u  = asin(1/3);
K  = [u, 60*pi/180];
I  = K;

Q = [-0,7, 20*pi/180];

gamma = meridianConvergence(Q(1), Q(2), I(1), I(2), R, @uvTosd_6, @gnom_6);
gamma_deg = gamma * 180/pi;

fprintf('Meridianova konvergence = %.6f°\n', gamma_deg);