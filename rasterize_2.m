% Set per_fragment to 1 for per fragment lighiting.
function [image] = rasterize_2(VP, F, I, VN, per_fragment)
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
        points = [];
        normals = [];
        light = [];
        zvals = [0, 0, 0];
        for i = 1:3
            offset = abs(min(min(VP)));
            point = VP(F(num_rows, i), :);
            point(1) = ((point(1) + offset) * pix*5) + 200;
            point(2) = ((point(2) + offset) * pix*5) + 200;
            point(3) = ((point(3) + offset) * pix*5) + 200;
            
            % Store z value
            zvals(i) = point(3);
            
            % Store point for rasterizing this triangle.
            point = [point(1), point(2), point(4)];
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
        % Used for interpolation and edge functions - as per Olano Greer
        % 1997
        M = [points(1, 1), points(1, 2), points(1, 3);
             points(2, 1), points(2, 2), points(2, 3);
             points(3, 1), points(3, 2), points(3, 3)].';
             
        if det(M) == 0
            continue;
        end
        M = inv(M);
        
        %Loop through x coords
        for i = smallestX:biggestX
            for j = smallestY:biggestY
                % Take the mid point of the pixel
                icheck = i + 0.5;
                jcheck = j + 0.5;
                
                % Get edge functions - as per Olano Greer 1997         
                coeff1 = [1 0 0] * M;
                coeff2 = [0 1 0] * M;
                coeff3 = [0 0 1] * M;
                eq1 = (coeff1(1) * icheck) + (coeff1(2) * jcheck) + coeff1(3);
                eq2 = (coeff2(1) * icheck) + (coeff2(2) * jcheck) + coeff2(3);
                eq3 = (coeff3(1) * icheck) + (coeff3(2) * jcheck) + coeff3(3);
                
                if eq1 > 0 && eq2 > 0 && eq3 > 0
                    % Interpolate 1/w
                    wcoeff = [1 1 1] * M;
                    weq = (wcoeff(1) * icheck) + (wcoeff(2) * jcheck) + wcoeff(3);
                    
                    % Interpolate z value for buffer.
                    % Taking some liberties here... if this was in
                    % perspective, we would check against 1/w...
                    % But it isn't - so instead interpolate a zvalue across
                    % the triangle - which works ok.
                    zcoeff = [zvals(1), zvals(2), zvals(3)] * M;
                    zeq = (zcoeff(1) * icheck) + (zcoeff(2) * jcheck) + zcoeff(3);
                    zval = zeq * weq;
                    % Check against ZBuffer
                    % Do occlusion culling / backface cull
                    if zbuffer(i, j) > zval
                        % Update zbuffer
                        zbuffer(i, j) = zval;
                        
                        if per_fragment == 1
                            % Per fragment lighting.
                            % Interpolate normal
                            norm = [0 0 0];
                            
                            %X
                            normcoeffx = [normals(1, 1), normals(2, 1), normals(3, 1)] * M;
                            normeqx = (normcoeffx(1) * icheck) + (normcoeffx(2) * jcheck) + normcoeffx(3);
                            norm(1) = normeqx * weq;
                            
                            %Y
                            normcoeffy = [normals(1, 2), normals(2, 2), normals(3, 2)] * M;
                            normeqy = (normcoeffy(1) * icheck) + (normcoeffy(2) * jcheck) + normcoeffy(3);
                            norm(2) = normeqy * weq;
                            
                            %Z
                            normcoeffz = [normals(1, 3), normals(2, 3), normals(3, 3)] * M;
                            normeqz = (normcoeffz(1) * icheck) + (normcoeffz(2) * jcheck) + normcoeffz(3);
                            norm(3) = normeqz * weq;

                            % Compute colour
                            colour = fragment_illumination(norm);
                            image(i, j, :) = colour;
                        else
                            % Else we're interpolating colour from each
                            % vertex
                            pixlight = [0 0 0];
                            
                            %red
                            pixcoeffr = [light(1, 1), light(2, 1), light(3, 1)] * M;
                            pixeqr = (pixcoeffr(1) * icheck) + (pixcoeffr(2) * jcheck) + pixcoeffr(3);
                            pixlight(1) = pixeqr * weq;
                            
                            %green
                            pixcoeffg = [light(1, 2), light(2, 2), light(3, 2)] * M;
                            pixeqg = (pixcoeffg(1) * icheck) + (pixcoeffg(2) * jcheck) + pixcoeffg(3);
                            pixlight(2) = pixeqg * weq;
                            
                            %blue
                            pixcoeffb = [light(1, 3), light(2, 3), light(3, 3)] * M;
                            pixeqb = (pixcoeffb(1) * icheck) + (pixcoeffb(2) * jcheck) + pixcoeffb(3);
                            pixlight(3) = pixeqb * weq;
                            
                            image(i, j, :) = pixlight;
                        end
                    end
                end
            end
        end
    end
end