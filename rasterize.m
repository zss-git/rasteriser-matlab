function [image] = rasterize(VP, F, I)
    % 1 unit = 1 pixel...
    % Draw in top right corner.
    
    VP = VP / 10;
    VP(:, 3) = 1;
    pix = 800;
    image = zeros(pix, pix, 3);
    image(:, :, 1) = 1;
    image(:, :, 2) = 1;
    image(:, :, 3) = 1;
    
    Fs = size(F);
    for num_rows = 1:Fs(1)
        %Get the lighting numbers
        light = [];
        light = [light; I(F(num_rows, 1), :)];
        light = [light; I(F(num_rows, 2), :)];
        light = [light; I(F(num_rows, 3), :)];
        
        %Calculate bounding box.
        %Find the furthest four points.
        points = [];
        points = [points; VP(F(num_rows, 1), :)];
        points = [points; VP(F(num_rows, 2), :)];
        points = [points; VP(F(num_rows, 3), :)];
        
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
        
        points;
        
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
                bary = barycentric([icheck, jcheck, 1], points(1, :), points(2, :), points(3, :));
                if min(bary) > 0
                    image(i+500, j+500, 1) = light(1);
                    image(i+500, j+500, 2) = light(2);
                    image(i+500, j+500, 3) = light(3);
                end
            end
        end
        %break;
    end
    image = rot90(image);
end