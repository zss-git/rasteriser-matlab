function [V, F] = obj_read(filename)
    file = fopen(filename);
    % Read line by line
    line = fgetl(file);
    % Vertices and faces
    V = [];
    F = [];
    while ischar(line)
        if (line(1) == 'v')     % Vertices
            line = erase(line, 'v ');
            C = strsplit(line, ' ');
            C = str2double(C);
            % Append new line
            V = [V; C];
        elseif (line(1) == 'f')     % Faces
            line = erase(line, 'f ');
            C = strsplit(line, ' ');
            C = str2double(C);
            % Append new line
            F = [F; C];
        end
        line = fgetl(file);
    end
end