function [Vn] = get_homogenous(V)
    Vs = size(V);
    Vn = [];
    % Add the 1...
    for num_rows = 1:Vs(1)
        Vn = [Vn; V(num_rows, :), 1];
    end
end
