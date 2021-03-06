function [I] = fragment_illumination(N)
    I = 0;

    % Intensity
    Ia = 0.7;
    Ii = 0.5;
    % Reflection coefficients
    Ka = [0.5, 0.1, 0.1];
    Kd = [0.1, 0.5, 0.1];
    Ks = [0.1, 0.1, 0.5];

    % Light position
    L = [0, -1, 0];
    L = L / norm(L);
    
    % View position
    cam = [0, -1, 0];
    cam = cam / norm(cam);
    
    % Specular distribution
    sd = 20;
        
    Nc = N;
    Nc = Nc / norm(Nc);

    % Ambient Term
    ambient = Ia * Ka;

    % Diffuse Term
    diffuse = Ii * Kd * dot(Nc, L);

    % Specular Term
    R = L - (2.0 * dot(Nc, L) * Nc);
    R = R / norm(R);
    specular = Ii * Ks * (dot(R, cam))^sd;

    Ic = ambient + diffuse + specular;
    I = Ic;
end
