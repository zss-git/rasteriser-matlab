function [N] = calculate_normals(V, F)
    Fs = size(F);
    N = [];
    % Calculate normal for each face
    for num_rows = 1:Fs(1)
        % Vectors for each vertex of a face
        P1 = V(F(num_rows, 1), :);
        P2 = V(F(num_rows, 2), :);
        P3 = V(F(num_rows, 3), :);
        
        X = P2 - P1;
        Y = P3 - P1;
       
        Nc = cross(X, Y);
        N = [N; Nc];
    end
end
