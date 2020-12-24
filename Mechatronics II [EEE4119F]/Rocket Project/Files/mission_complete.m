function [success] = mission_complete(x, y, ast_x, ast_y, ast_th, Scenario)
% outputs success = true if the all requirements are achieved

success = true;

if any(y < 0)
    success = false;
    disp('Mission failed: the rocket hit the ground at some point')
end

if any(ast_y < 200)
    success = false;
    disp('Mission failed: the asteroid got too close to the city')
end

if norm([x(end); y(end)] - [ast_x(end); ast_y(end)]) > 150
    success = false;
    disp('Mission failed: the rocket didnt get close enough to the asteroid')
end

if Scenario == 3
    % angle that the rocket is approaching the asteroid from
    dx = x(end) - ast_x(end);
    dy = y(end) - ast_y(end);
    angle = rad2deg(atan2(dy, dx));
    
    % angle of the asteroid itself
    angle_ast = rad2deg(ast_th(end));
    
    % difference between the two angles = the approach angle error
    err = angle - angle_ast;
    
    % check if -30 < err < 30, or 150 < err < 210
    if ~((-30 < wrapTo180(err) && wrapTo180(err) < 30) ...
            || (150 < wrapTo360(err) && wrapTo360(err) < 210))
        success = false;
        disp('Mission failed: the rocket didnt hit the asteroid at the right angle')
    end
end

if success
    disp('Mission complete: well done! Make sure to test with multiple seeds')
end

end
