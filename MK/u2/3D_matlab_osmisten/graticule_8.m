function [XM, YM, XP, YP] = graticule_8(umin, umax, vmin, vmax, Du, Dv, du, dv, R, uk, vk, polyX, polyY)
% Build graticule (meridians and parallels) for an 8-fold gnomonic face

% Minimum s to avoid gnomonic singularity
sMin = 5 * pi/180;

% Meridians: initialize output lists
XM = [];
YM = [];

% Loop over longitudes
for v = vmin:Dv:vmax
    % Sample latitudes for this meridian
    um = umin:du:umax;
    % Constant longitude array
    vm = ones(size(um)) * v;

    % Convert (u,v) to (s,d)
    [sm, dm] = uvTosd_8(um, vm, uk, vk);

    % Keep points away from singularity
    valid = sm > sMin;

    % Prepare projected coordinates filled with NaN
    xm = NaN(size(sm));
    ym = NaN(size(sm));

    % Project valid points to gnomonic plane
    if any(valid)
        [xv, yv] = gnom_8(R, sm(valid), dm(valid));
        xm(valid) = xv;
        ym(valid) = yv;
    end

    % Clip meridian to face polygon
    [xm, ym] = clipLineToPolygon_8(xm, ym, polyX, polyY);

    % Append this meridian to outputs
    XM = [XM; xm];
    YM = [YM; ym];
end

% Parallels: initialize output lists
XP = [];
YP = [];

% Loop over latitudes
for u = umin:Du:umax
    % Sample longitudes for this parallel
    vp = vmin:dv:vmax;
    % Constant latitude array
    up = ones(size(vp)) * u;

    % Convert (u,v) to (s,d)
    [sp, dp] = uvTosd_8(up, vp, uk, vk);

    % Keep points away from singularity
    valid = sp > sMin;

    % Prepare projected coordinates filled with NaN
    xp = NaN(size(sp));
    yp = NaN(size(sp));

    % Project valid points to gnomonic plane
    if any(valid)
        [xv, yv] = gnom_8(R, sp(valid), dp(valid));
        xp(valid) = xv;
        yp(valid) = yv;
    end

    % Clip parallel to face polygon
    [xp, yp] = clipLineToPolygon_8(xp, yp, polyX, polyY);

    % Append this parallel to outputs
    XP = [XP; xp];
    YP = [YP; yp];
end

end
