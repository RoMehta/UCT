%% make an animation
close all;
define_constants;

% look at the source of make_animation if it doesn't work - you may need to
% lower the fps on slower computers. Otherwise you can uncomment a line to
% make the animation happen faster than real time
set_param(['AsteroidImpact', '/rngSeed'], 'Value', '123');
sim('AsteroidImpact');  % tell simulink to simulate the model
make_animation(simulation_time, x, y, th, ast_x, ast_y, ast_th, ast_dx, ast_dy, 10)

% 'simulation_time' is an array of time values, exported from the simulink
% simulation

%% Make a video animation and save it to rocket-animation.avi
% this is more useful if the animation script above gives you problems
% or if you want to share a video with anyone else
record_animation(simulation_time, x, y, th, ast_x, ast_y, ast_th, ast_dx, ast_dy)

%% check whether you succeeded
Scenario = 1;
mission_complete(x, y, ast_x, ast_y, ast_th, Scenario)

%% think about other ways of visualizing this system!