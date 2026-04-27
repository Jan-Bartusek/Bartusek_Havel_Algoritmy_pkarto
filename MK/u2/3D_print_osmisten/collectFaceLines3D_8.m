function lineSet = collectFaceLines3D_8(face, V, conts, umin, umax, vmin, vmax, Du, Dv, du, dv)
% Collect 3D line segments (continents + graticule) mapped onto one face
% Returns cell array of Nx3 arrays (each a 3D polyline)

R = 1;
sMin = 5 * pi/180;

lineSet = {};

% 2D face boundary in gnomonic projection
[~, ~, polyX, polyY] = boundary_8(R, face.uk, face.vk, face.ub, face.vb);

% 3D triangle of the face
tri3D = V(face.vertexIdx, :);

% Outward normal (unit) for small offset above the face
n = cross(tri3D(2,:) - tri3D(1,:), tri3D(3,:) - tri3D(1,:));
n = n / norm(n);
c = mean(tri3D,1);
if dot(n, c) < 0
    n = -n;
end

offset = 0.003;

% Continents: load, project, clip, and append segments
for k = 1:length(conts)
    pts = load(conts{k});

    u = pts(:,1)' * pi/180;
    v = pts(:,2)' * pi/180;

    [s, d] = uvTosd_8(u, v, face.uk, face.vk);

    valid = s > sMin;
    x = NaN(size(s));
    y = NaN(size(s));

    if any(valid)
        [xv, yv] = gnom_8(R, s(valid), d(valid));
        x(valid) = xv;
        y(valid) = yv;
    end

    [x, y] = clipLineToPolygon_8(x, y, polyX, polyY);
    lineSet = appendSegments(x, y, polyX, polyY, tri3D, n, offset, lineSet);
end

% Meridians: sample longitudes and process similarly
for v = vmin:Dv:vmax
    um = umin:du:umax;
    vm = ones(size(um)) * v;

    [sm, dm] = uvTosd_8(um, vm, face.uk, face.vk);

    valid = sm > sMin;
    x = NaN(size(sm));
    y = NaN(size(sm));

    if any(valid)
        [xv, yv] = gnom_8(R, sm(valid), dm(valid));
        x(valid) = xv;
        y(valid) = yv;
    end

    [x, y] = clipLineToPolygon_8(x, y, polyX, polyY);
    lineSet = appendSegments(x, y, polyX, polyY, tri3D, n, offset, lineSet);
end

% Parallels: sample latitudes and process similarly
for u = umin:Du:umax
    vp = vmin:dv:vmax;
    up = ones(size(vp)) * u;

    [sp, dp] = uvTosd_8(up, vp, face.uk, face.vk);

    valid = sp > sMin;
    x = NaN(size(sp));
    y = NaN(size(sp));

    if any(valid)
        [xv, yv] = gnom_8(R, sp(valid), dp(valid));
        x(valid) = xv;
        y(valid) = yv;
    end

    [x, y] = clipLineToPolygon_8(x, y, polyX, polyY);
    lineSet = appendSegments(x, y, polyX, polyY, tri3D, n, offset, lineSet);
end

end

function lineSet = appendSegments(x, y, polyX, polyY, tri3D, n, offset, lineSet)
% Split a (possibly NaN-separated) 2D polyline into segments, map each
% segment to 3D using barycentric mapping, offset above the face, and
% append to lineSet (cell array).

isn = isnan(x) | isnan(y);
idx = [0, find(isn), length(x)+1];

for seg = 1:length(idx)-1
    a = idx(seg) + 1;
    b = idx(seg+1) - 1;

    if b - a + 1 < 2
        continue;
    end

    xs = x(a:b);
    ys = y(a:b);

    P3 = zeros(length(xs), 3);
    for i = 1:length(xs)
        P3(i,:) = map2DTo3DTriangle_8(xs(i), ys(i), polyX, polyY, tri3D);
    end

    % Slightly raise the polyline above the face to avoid z-fighting
    P3 = P3 + offset * n;
    lineSet{end+1} = P3;
end

end
