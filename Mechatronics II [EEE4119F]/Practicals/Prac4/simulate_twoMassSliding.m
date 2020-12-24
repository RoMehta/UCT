% simulates the system described in question 1 practical 1
% call as follows:
%     [t, y] = simulate_twoMassSliding(@f, [0; 10], [alpha0; dalpha0]);
function [t, y] = simulate_twoMassSliding(func, tspan, y0)
    options = odeset('Events', @eventFcn, 'MaxStep', 0.005);

    [t,y,~,~,~] = ode45(func, tspan, y0, options);
end

function [position,isterminal,direction] = eventFcn(~, y)
    position = y(1) - pi/2; % The value that we want to be zero
    isterminal = 1;  % Halt integration
    direction = 0;   % The zero can be approached from either direction
end
