function [F] = barycentric(P, A, B, C)
    % Concept from:
    % https://gamedev.stackexchange.com/questions/23743/whats-the-most-efficient-way-to-find-barycentric-coordinates
    
    % https://www.scratchapixel.com/lessons/3d-basic-rendering/ray-tracing-rendering-a-triangle/barycentric-coordinates
    
    N = cross((B - A), (C - A));
    
    abc = dot(N, cross((B - A),(C - A)));
    pbc = dot(N, cross((B - P),(C - P)));
    pca = dot(N, cross((C - P),(A - P)));
    
    F = [pbc/abc, pca/abc, (1.0 - pbc/abc - pca/abc)];
end