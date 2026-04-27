function exportOBJ_8(filename, V, F, lineSet)
% Export octahedron mesh V/F and polyline set (cell array of Nx3 arrays) to OBJ.

fid = fopen(filename, 'w');
if fid == -1
    error('Nepodarilo se otevrit soubor pro zapis: %s', filename);
end
% Ensure file is closed on function exit or error
c = onCleanup(@() fclose(fid));

fprintf(fid, '# Osmisten + lines exported from MATLAB\n');
fprintf(fid, '# vertices: %d  faces: %d  polylines: %d\n\n', size(V,1), size(F,1), numel(lineSet));

% Mesh vertices
for i = 1:size(V,1)
    fprintf(fid, 'v %.8f %.8f %.8f\n', V(i,1), V(i,2), V(i,3));
end

% Mesh object and faces (1-based indices)
fprintf(fid, '\no base_octahedron\n');
for i = 1:size(F,1)
    fprintf(fid, 'f %d %d %d\n', F(i,1), F(i,2), F(i,3));
end

% Polylines: append vertices and write line elements
vertexOffset = size(V,1); % base index for subsequent appended vertices

if ~isempty(lineSet)
    for k = 1:numel(lineSet)
        P = lineSet{k};
        if isempty(P)
            continue;
        end

        % named object/group for each line
        fprintf(fid, '\no line_%04d\n', k);

        % vertices for this polyline
        for i = 1:size(P,1)
            fprintf(fid, 'v %.8f %.8f %.8f\n', P(i,1), P(i,2), P(i,3));
        end

        % Write line element referencing the newly added vertices
        fprintf(fid, 'l');
        for i = 1:size(P,1)
            fprintf(fid, ' %d', vertexOffset + i);
        end
        fprintf(fid, '\n');

        % Update offset for next polyline
        vertexOffset = vertexOffset + size(P,1);
    end
end

% File closed automatically by onCleanup when function exits
end
