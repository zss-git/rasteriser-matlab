% Load in and renders the Stanford Bunny obj file.
% Set 'per_fragment' to 1 for per fragment lighting.
function [] = render_bunny(per_fragment)
    % Load bunny
    [V, F] = obj_read('StanfordBunny.obj');
    
    % Calculate normals and do projection.
    N = calculate_normals(V, F);
    VN = calculate_vertex_normals(V, F, N);
    VP = projection(V);
    
    % Calculate illumination if approprioate
    I = [];
    if per_fragment ~= 1
        I = illumination(V, F, VN);
    end
    
    % Draw and show
    imagex = rasterize_2(VP, F, I, VN, per_fragment);
    imagex = rot90(imagex);
    imshow(imagex);
end