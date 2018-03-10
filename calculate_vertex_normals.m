function [VN] = calculate_vertex_normals(V, F, N)
    % This is a really naive approach.
    Vs = size(V);
    VN = [];
    % Calculate normal for each vertex
    for num_rows = 1:Vs(1)
        [a ~] = find(F == num_rows);
        as = size(a);
        
        Nc = [0, 0, 0];
        for face = 1:as(1)
            Nc = Nc + N(a(face), :);
        end
        
        VN = [VN; Nc];
    end
end
