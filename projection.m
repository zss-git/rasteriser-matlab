% Used the following resources for projection:
% https://research.ncl.ac.uk/game/mastersdegree/graphicsforgames/vertextransformation/Tutorial%202%20-%20Vertex%20Transformation.pdf
% http://www.codinglabs.net/article_world_view_projection_matrix.aspx
% https://www.scratchapixel.com/lessons/3d-basic-rendering/computing-pixel-coordinates-of-3d-point/mathematics-computing-2d-coordinates-of-3d-points
         
function [Vp] = projection(V)
    VH = get_homogenous(V);
    Vs = size(VH);
    Vp = [];
    
    % Project for each vertex
    for num_rows = 1:Vs(1)
        C = VH(num_rows, :);
        
        maxval = max(max(VH));
        minval = min(min(VH));
        val = max(abs(minval), abs(maxval));
        
        right = val;
        left = -val;
        top = val;
        bottom = -val;
        far = val;
        near = -val;
        
        C = C / norm(C);
        
         % I couldn't get this to work and I don't have the faintest idea
         % why - so I commented it out and did orthographic projection...
        f = 2 * cotd(30/2);
        aspect = 1;
        znear = 2;
        zfar = 12;

        O = [1, 0, 0, 0;
             0, 1, 0, 0;
             0, 0, 1, 0;
             0, 0, -1, 0;];

        C = O * C';
        C = C / norm(C);
        
        %C = D * C;
        
        %Normalise        
        Vp = [Vp; C'];
    end
end