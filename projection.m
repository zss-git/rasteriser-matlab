function [Vp] = projection(V)
    Vs = size(V);
    Vp = [];
    %proj = [1, 0, 0, 0; 0, 1, 0, 0; 0, 0, 1, 0; 0, 0, 1/10, 0]
    
    % Project for each vertex
    for num_rows = 1:Vs(1)
        C = V(num_rows, :) * 10000;
        C(3) = 1;
        % C = C / C(3);
        Vp = [Vp; C];
    end
end