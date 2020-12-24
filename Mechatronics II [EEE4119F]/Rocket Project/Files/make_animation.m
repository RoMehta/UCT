function make_animation(t, x, y, th, ast_x, ast_y, ast_th, ast_dx, ast_dy, fps)
% warning: this is a crude animation - don't take it too seriously!
%
% It expects t, x, y, etc as regular arrays (pass as x.signals.values)
% and a constant step size, which is likely what you want when doing
% control
%
% fps is the number of frames per second the animation should run at
%
% There are two timings happening here: one to make the animation run in
% roughly real time, and one to set the number of frames shown per second
% The path that the asteroid would take in the absence of gravity or drag
% forces is shown, mainly to make you aware of the fact that predicting
% the asteroid's path is not trivial
%
% Lastly, there is a small line to help you keep track of the asteroid's
% angle

    define_constants;

    dt = t(2) - t(1);
    
    figure; hold all; shg
    coords = [XMIN XMAX YMIN YMAX];

    cur_t = 0;
    tic;
    
    tempX = x.signals.values;
    tempY = y.signals.values;
    tempTh = th.signals.values;
    tempAST_X = ast_x.signals.values;
    tempAST_Y = ast_y.signals.values;
    tempAST_Th = ast_th.signals.values;
    tempAST_dX = ast_dx.signals.values;
    tempAST_dY = ast_dy.signals.values;

    % Position of thruster
    pos = [tempX + (WIDTH*sin(tempTh))/2, tempY - (WIDTH*cos(tempTh))/2];
    
    for i = 1:length(tempX)
        % only make a frame every 1/fps seconds
        cur_t = cur_t + dt;
        if cur_t < 1/fps
            continue  % skip to the next for loop iteration
        else
            cur_t = 0;
        end
        
        clf
        
        
        % a horizontal line for the ground
        plot([coords(1) coords(2)], [0, 0])
        hold on
        
        % a landing pad at x = y = 0 = 0
        plot([  -10   -10   10   10], [0 50 50 0]) % the launch pad
        plot([ 2200  2200 2800 2800], [0 50 50 0]) % the city
        
        add_rocket(tempX(i), tempY(i), tempTh(i), WIDTH, HEIGHT)
        add_asteroid(tempAST_X(i), tempAST_Y(i), tempAST_Th(i))
        add_asteroid_dxdy_line(tempAST_X(i), tempAST_Y(i), tempAST_dX(i), tempAST_dY(i))
        add_asteroid_angle_line(tempAST_X(i), tempAST_Y(i), tempAST_Th(i))
        
        title(['t = ', num2str(i*dt), 's'])

        axis(coords)
        grid on
        
        % make the plot update in real time, ish
        t_loop = toc;
        t_loop = t_loop*2;  % uncomment this to speed animation by
                              % roughly 2
        if t_loop < 1/fps
            pause(1/fps - t_loop)
        end
        tic;
    end
end


function add_rocket(tempX, tempY, tempTh, WIDTH, HEIGHT)
    % this is a total hack. I really just don't know matlab's plotting
    % facilities very well, though I think it's annotation bits just
    %  aren't very good
    x_coords = [tempX tempX-sin(tempTh)*WIDTH];
    y_coords = [tempY tempY+cos(tempTh)*HEIGHT];

    ha = annotation('arrow');  % store the arrow information in ha
    ha.Parent = gca;           % associate the arrow the the current axes
    ha.X = x_coords;           % the location in data units
    ha.Y = y_coords;

    ha.LineWidth  = 1;         % make the arrow bolder for the picture
    ha.HeadWidth  = 10;
    ha.HeadLength = 10;
end

function add_asteroid(tempAST_X, tempAST_Y, tempAST_Th)
    radius = 100;
    t = transpose(-pi:0.01:pi);
    rot = [ cos(tempAST_Th) -sin(tempAST_Th)
            sin(tempAST_Th)  cos(tempAST_Th)];
    rough_edges = [radius * (sin(t) + sin(7*t)/5 + cos(4*t)/7),...
                   radius * (cos(t) + cos(9*t)/4 + cos(5*t)/8)];
    rough_edges = (rot * rough_edges')';
    plot(tempAST_X + rough_edges(:,1), ...
         tempAST_Y + rough_edges(:,2))
end

function add_asteroid_dxdy_line(tempAST_X, tempAST_Y, tempAST_dX, tempAST_dY)
    plot([tempAST_Y; tempAST_X + 100*tempAST_dX], [tempAST_Y; tempAST_Y + 100*tempAST_dY])
end

function add_asteroid_angle_line(tempAST_X, tempAST_Y, tempAST_Th)
    length = 300;
    rot = [ cos(tempAST_Th) -sin(tempAST_Th)
            sin(tempAST_Th)  cos(tempAST_Th)];
    pts = length/2 * (rot * [1 -1; 0 0])';
    plot(tempAST_X + pts(:,1), tempAST_Y + pts(:,2))
end
