function drawFaceContinents3D_8(face, V, conts)
% Draw continents directly on one 3D face of the octahedron

R = 1;
sMin = 5 * pi/180;

% 2D face boundary in gnomonic projection
[~, ~, polyX, polyY] = boundary_8(R, face.uk, face.vk, face.ub, face.vb);

% 3D vertices of the face triangle
tri3D = V(face.vertexIdx, :);

% Outward normal for a small offset
n = cross(tri3D(2,:) - tri3D(1,:), tri3D(3,:) - tri3D(1,:));
n = n / norm(n);

% Face centroid for normal orientation check
c = mean(tri3D, 1);
if dot(n, c) < 0
    n = -n;
end

% Small offset above the face
offset = 0.01;

for k = 1:length(conts)
    % Load continent point list
    pts = load(conts{k});

    % Latitude (radians)
    u = pts(:,1)' * pi/180;
    % Longitude (radians)
    v = pts(:,2)' * pi/180;

    % Convert (u,v) to (s,d) for this face
    [s, d] = uvTosd_8(u, v, face.uk, face.vk);

    % Keep points with sufficient s (avoid edges)
    valid = s > sMin;

    % Initialize projected 2D coordinates
    x = NaN(size(s));
    y = NaN(size(s));

    % Project valid points to gnomonic plane
    if any(valid)
        [xv, yv] = gnom_8(R, s(valid), d(valid));
        x(valid) = xv;
        y(valid) = yv;
    end

    % Clip the projected line to the face polygon
    [x, y] = clipLineToPolygon_8(x, y, polyX, polyY);

    % Split into segments at NaNs
    isn = isnan(x) | isnan(y);
    idx = [0, find(isn), length(x)+1];

    for seg = 1:length(idx)-1
        a = idx(seg) + 1;
        b = idx(seg+1) - 1;

        % Skip segments with fewer than 2 points
        if b - a + 1 < 2
            continue;
        end

        % Extract segment 2D coords
        xs = x(a:b);
        ys = y(a:b);

        % Preallocate 3D points for the segment
        P3 = zeros(length(xs), 3);

        % Map each 2D point back onto the 3D triangle
        for i = 1:length(xs)
            P3(i,:) = map2DTo3DTriangle_8(xs(i), ys(i), polyX, polyY, tri3D);
        end

        % Move points slightly above the face
        P3 = P3 + offset * n;

        % Plot the 3D segment
        plot3(P3(:,1), P3(:,2), P3(:,3), 'b', 'LineWidth', 1.25);
    end
end

end