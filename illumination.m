function [I] = illumination(V, F, VN)
    I = [];

    % Intensity
    Ia = 0.7;
    Ii = 0.5;
    % Reflection coefficients
    Ka = [0.5, 0.2, 0.3];
    Kd = [0.2, 0.3, 0.7];
    Ks = [0.1, 0.1, 0.1];

    % Light position
    L = [10, 10, 10];
    L = L / norm(L);
    
    % View position
    cam = [3, 3, 3];
    cam = cam / norm(L);
    
    % Specular distribution
    sd = 20;
        
    % Loop through vertices
    Vs = size(V);
    
    for num_rows = 1:Vs(1)
        Nc = VN(num_rows, :);
        Nc = Nc / norm(Nc);
        
        % Ambient Term
        ambient = Ia * Ka;
        
        % Diffuse Term
        dots = dot(Nc, L);
        diffuse = Ii * Kd * dot(Nc, L);
        
        % Specular Term
        R = L - 2.0 * dot(L, Nc) * Nc;
        R = R / norm(R);
        specular = Ii * Ks * (dot(R, cam))^sd;
        specular = 0;
      
        Ic = ambient + diffuse + specular;
        I = [I; Ic];
    end
end