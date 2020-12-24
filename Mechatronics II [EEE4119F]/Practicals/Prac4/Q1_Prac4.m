%% Setup Symbolic variables

syms alpha beta dAlpha dBeta ddAlpha ddBeta m l g t

q = [alpha];
dq = [dAlpha];

%% Calculate Position Vector
p1 = [0 ; l*cos(alpha)];
p2 = [l*sin(alpha) ; 0];

%% Kinematics
v1 = jacobian(p1,q)*dq;
v2 = jacobian(p2,q)*dq;

%% Body Energy
% Kinetic
TBody = 0.5*m*transpose(v1)*v1 + 0.5*m*transpose(v2)*v2;
% Potential
VBody = m*g*p1(2);


%% Lagrange Equation: L = T-V
Lag = TBody - VBody;
Lag = simplify(Lag);

%% Calculate Equations of MOtion for each stat
dLAlpha=simplify(diff(Lag,alpha));
%dLBeta=simplify(diff(Lag,beta));

dLdAlpha=simplify(diff(Lag,dAlpha));
%dLdBeta=simplify(diff(Lag,dBeta));

%% Break into individual equations
% Time derivatives need to apply product rule
eqn1 = (diff(dLdAlpha,dAlpha)*ddAlpha + diff(dLdAlpha,alpha)*dAlpha) - dLAlpha
%eqn2 = (diff(dLdBeta,dBeta)*ddBeta +  diff(dLdBeta, beta)*dBeta + diff(dLdBeta,dAlpha)*ddAlpha + diff(dLdBeta,alpha)*dAlpha) - dLBeta

eqddAlpha = simplify(solve(eqn1,ddAlpha))
%eqddBeta = simplify(solve(eqn2,ddBeta))
%% Call Simulator
[t, y] = simulate_twoMassSliding(@f, [0; 10], [pi/12; 0]);
plot(t,y(:,1));
xlabel('t');ylabel('a')
L = 0.5;
%% Functions
function [dydt] = f(time,q)
 dxdt1 = q(2);
 dxdt2 = (9.8*sin(q(1)))/0.5;
 [dydt]= [dxdt1;dxdt2];
end