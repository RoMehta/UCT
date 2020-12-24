%This code covers Question 2 and its sub-questions
%When the program is run it produces 4 plots
%Each plot corresponds to a time step dt
%The first plot is a time step dt = 0.8
%The last plot is a time step = 0.1

time_step = [0.1,0.2,0.4,0.8];

for p = time_step %This part runs through each time step dt
    [t,y] = euler1stOrder(1,@deriv,p,8);%Calls function to integrate given ODE
    [t,g] = runge_kutta_4(1,@deriv,p,8);%Calls function to integrate given ODE
    
    figure()
    plot(t,y,'b--');%Plot Numerical solution (Euler) 
    hold on
    
    z = exp(-t); %Analytical solution
    plot(t,z,'g');%Plot analytical solution
    
    plot(t,g,'r--');%Plot Numerical solution (RK4) 
    hold off
    
    xlabel('t');
    ylabel('y');
    legend('euler','Analytic','RK4');
end

%The function that Numerically integrates the ODE using Euler method
function [t,y] = euler1stOrder(y0, f, dt, t_final)
steps = round((t_final)/dt); %Number of steps to take
y = zeros(1,steps+1); %Sets up an array to hold Numerical solution
y(1)=y0; %Initial condition
t = 0:dt:t_final;
x = exp(-t);
dy = feval(f,t,x); %Evaluates function at given point

for i=1:steps
    
    y(i+1)= y(i)+dt*dy(i); %Integration
end
end

function dy = deriv(time,y)
dy = zeros(length(y));
dy = -y; %Obtains derivative at specific value for t
end

function [t, g] = runge_kutta_4(y0, f, dt, t_final)
y = y0;%Initial condition
steps = round((t_final)/dt); %Number of steps to take
g = zeros(1,steps+1);  %Sets up an array to hold Numerical solution
g(1)=y0; %Initial condition
t = 0:dt:t_final;
x = y0;

for i= 1:steps
    %The following are the four terms used in the RK4 method
    k1 = -x;
    h_ts = dt/2;
    k2 = feval(f,t(i),exp(-t(i)- h_ts) + dt*k1/2);
    k3 = feval(f,t(i),exp(-t(i)-h_ts) + dt*k2/2);
    k4 = feval(f,t(i),exp(-t(i)-dt)+ dt*k3);

    g(i+1) = g(i) + dt*((k1+2*k2+2*k3+k4)/6); %Integration
    x = g(i+1); %Updates the current value of y
end
end