% Set per_fragment to 1 for per fragment lighiting.
function [image] = rasterize(VP, F, I, VN, per_fragment)
    camera = [0, -1, 0];

    % 1 unit = 1 pixel...
    % Draw in top right corner.
    pix = 800;
    
    %Image buffer
    image = zeros(pix, pix, 3);
    
    %Z Buffer
    zbuffer = zeros(pix, pix, 1);
    zbuffer(:, :) = pix*10;
    
    Fs = size(F);
    for num_rows = 1:Fs(1)
        zface = [0, 0, 0];
        
        % Attempt to position the object somewhere vaguely useful.        
        points = [];
        normals = [];
        light = [];
        for i = 1:3
            offset = max([abs(min(min(VP))), max(max(VP))]);
            
            point = VP(F(num_rows, i), :);
            points = [points; point];
          
            % Get normal
            cnorm = VN(F(num_rows, i), :);
            normals = [normals; cnorm];
            
            if per_fragment ~= 1
                % Get lighting numbers
                light = [light; I(F(num_rows, i), :)];
            end
        end
        
        %Calculate bounding box.
        biggestX = -1000000000;
        smallestX = 1000000000;
        biggestY = -1000000000;
        smallestY = 1000000000;
        
        for i = 1:3
            % Get biggest and smallest values
            if points(i, 1) > biggestX
                biggestX = points(i, 1);
            end
            if points(i, 1) < smallestX
                smallestX = points(i, 1);
            end
            if points(i, 2) > biggestY
                biggestY = points(i, 2);
            end
            if points(i, 2) < smallestY
                smallestY = points(i, 2);
            end
        end
        
        %Round up/down
        biggestX = ceil(biggestX);
        biggestY = ceil(biggestY);
        smallestX = floor(smallestX);
        smallestY = floor(smallestY);
        %Loop through x coords
        for i = smallestX:biggestX
            for j = smallestY:biggestY
                % Take the mid point of the pixel
                icheck = i + 0.5;
                jcheck = j + 0.5;
                % Gets us our edge functions.
                [bary, triArea] = barycentric([icheck, jcheck, 1], points(1, :), points(2, :), points(3, :));
                
                if min(bary) > 0
                    % Interpolate z value for buffer.
                    pixzval = ((bary(1) * zface(1)) + (bary(2) * zface(2)) + (bary(3) * zface(3)));
                    % Check against ZBuffer
                    % Do occlusion culling / backface cull
                    if pixzval < zbuffer(i, j)
                        % Update zbuffer
                        zbuffer(i, j) = pixzval;
                        
                        if per_fragment == 1
                            % Per fragment lighting.
                            % Interpolate normal
                            pixnorm = ((bary(1) * (normals(1, :))) + (bary(2) * normals(2, :)) + (bary(3) * normals(3, :)));
                            pixnorm = pixnorm / norm(pixnorm);

                            % Compute colour
                            colour = fragment_illumination(pixnorm);
                            image(i, j, :) = colour;
                        else
                            pixlight = ((bary(1) * (light(1, :))) + (bary(2) * light(2, :)) + (bary(3) * light(3, :)));
                            image(i, j, :) = pixlight;
                        end

                    end
                end
            end
        end
    end
    image = rot90(image);
end