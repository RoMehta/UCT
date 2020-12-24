function [t, y] = simulate_robotDynamics(func, tspan, y0)
    options = odeset('MaxStep', 0.05);

    [t, y] = ode45(func, tspan, y0, options);
end
