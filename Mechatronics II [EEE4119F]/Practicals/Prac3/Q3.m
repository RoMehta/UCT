%This code covers Question 3 and its sub-questions
%When the program is run it produces 1 plot

options = odeset('AbsTol',1e-6);%set the absolute tolerance of the option solver 
tspan = [0,30]; % Time span
y0 = [1,1,1]; %Initial condition

[t, y] = ode45(@Lorenz, tspan, y0, options); %Call ODE45 function

plot3(y(:,1),y(:,2),y(:,3)); %plot solution
xlabel('x');
ylabel('y');
zlabel('z');
grid on;

function [dy] = Lorenz(time,y) %Lorenz function
dy = zeros(3)'; %Sets up an array to hold Lorenz ODE's
dy = [10*(y(2)-y(1)),y(1)*(27-y(3))-y(2),y(1)*y(2)-(8*y(3))/3]';
end