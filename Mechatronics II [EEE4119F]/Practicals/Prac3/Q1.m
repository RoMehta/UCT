%This code covers Question 1 and its sub-questions
%When the program is run it produces 4 plots
%Each plot corresponds to a time step dt
%The first plot is a time step dt = 0.8
%The last plot is a time step = 0.1

time_step = [0.1,0.2,0.4,0.8]; %Time steps dt

for p = time_step %This part runs through each time step dt
    
    [t,y] = euler1stOrder(1,@deriv,p,8); %Calls function to integrate given ODE
    
    g = exp(-t); %Analytical solution
    figure()
    plot(t,y,'b--'); %Plot Numerical solution (Euler) 
    hold on
    
    plot(t,g,'g'); %Plot analytical solution
    hold off
    
    xlabel('t');
    ylabel('y');
    legend('euler','Analytic');
end

%The function that Numerically integrates the ODE
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
