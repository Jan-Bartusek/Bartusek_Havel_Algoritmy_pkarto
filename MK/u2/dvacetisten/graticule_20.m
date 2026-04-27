function [XM, YM, XP, YP] = graticule_20(umin, umax, vmin, vmax, Du, Dv, du, dv, R, uk, vk, polyX, polyY)
% Generates graticule lines (meridians and parallels) for a map face
sMin = 5 * pi/180;   % Protection against singularity in gnomonic projection

% =========================
% Meridians
% =========================
XM = [];
YM = [];

for v = vmin:Dv:vmax
    um = umin:du:umax;
    vm = ones(size(um)) * v;

    [sm, dm] = uvTosd_20(um, vm, uk, vk);

    valid = sm > sMin;

    xm = NaN(size(sm));
    ym = NaN(size(sm));

    if any(valid)
        [xv, yv] = gnom_20(R, sm(valid), dm(valid));
        xm(valid) = xv;
        ym(valid) = yv;
    end

    [xm, ym] = clipLineToPolygon_20(xm, ym, polyX, polyY);

    XM = [XM; xm];
    YM = [YM; ym];
end

% =========================
% Parallels
% =========================
XP = [];
YP = [];

for u = umin:Du:umax
    vp = vmin:dv:vmax;
    up = ones(size(vp)) * u;

    [sp, dp] = uvTosd_20(up, vp, uk, vk);

    valid = sp > sMin;

    xp = NaN(size(sp));
    yp = NaN(size(sp));

    if any(valid)
        [xv, yv] = gnom_20(R, sp(valid), dp(valid));
        xp(valid) = xv;
        yp(valid) = yv;
    end

    [xp, yp] = clipLineToPolygon_20(xp, yp, polyX, polyY);

    XP = [XP; xp];
    YP = [YP; yp];
end

end