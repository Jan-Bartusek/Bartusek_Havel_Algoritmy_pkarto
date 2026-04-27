function gamma = meridianConvergence(uQ, vQ, uk, vk, R, uvTosd_fun, gnom_fun)
% meridianConvergence estimates the convergence angle at a point on the face.

h = 1e-6;

u1 = uQ - h;
u2 = uQ + h;

v1 = vQ;
v2 = vQ;

[s1, d1] = uvTosd_fun(u1, v1, uk, vk);
[s2, d2] = uvTosd_fun(u2, v2, uk, vk);

[x1, y1] = gnom_fun(R, s1, d1);
[x2, y2] = gnom_fun(R, s2, d2);

% Compute the local projected direction of the meridian.
dx = x2 - x1;
dy = y2 - y1;

alpha = atan2(dy, dx);
gamma = pi/2 - alpha;

end