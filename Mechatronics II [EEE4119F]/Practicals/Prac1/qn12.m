u = 500;     %car's control force
m = 1000;    %car's mass
b = 50;      %damping force
h = 0.1;     %integration stepsize
a = 0;
c = 120;
n = (c-a)/h; %total number of integration steps
v = zeros(1, n+1);
v(1) = 0;    %initial velocity
t = a:h:c;   %time vector

%perfoming the integration
for i = 1:n
    v(i+1) = v(i) + h*((u/m)-((b/m)*v(i)));
end

plot(t,v); xlabel('Seconds'); ylabel('System Velocity');
grid on;