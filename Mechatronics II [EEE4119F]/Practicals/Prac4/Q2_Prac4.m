
disp('Defining symbols')

syms g m1 m2 'real'       % gravity, masses
syms Ix1 Iy1 Iz1 Ix2 Iy2 Iz2 'real' % inertias
syms psi1 phi2 'real'     % angles
syms dpsi1 dphi2 'real'   % derivatives of angles
syms ddpsi1 ddphi2 'real'
syms L1 L2 'real'         % link lengths
syms t1 t2 'real'         % input/control torques


% Generalised coordinates for the system (each link can only rotate in one
% direction, so only two angles are needed to describe the system)
q = [psi1; phi2];
dq = [dpsi1; dphi2];
ddq = [ddpsi1; ddphi2];
mass = [m1 m2];

I1_1 = diag([Ix1 Iy1 Iz1]);
I2_2 = diag([Ix2 Iy2 Iz2]);
%% KINEMATICS - POSITIONS

disp('Kinematics: Positions')

% for this section - YES the following section could be simplified, but
% trying to be sneaky with simplifications will stop working when you start
% looking at more complicated systems with more degrees of freedom. It's
% best to just get used to thinking about offsets and rotations in a more
% general way. Once you can do these two links, adding a third link or
% another degree of freedom will be fairly straightforward

% First link is defined in Frame 1 coordinates
p1_1 = [0;...
        0;...
        L1/2];

% Rotation from Inertial (0) to frame-1
R0_1 = RotZ(psi1);
R1_0 = transpose(R0_1);
% p1_0 is the position of the first link in frame 0 coordinates (ie,
% position in the world frame)
p1_0 = R1_0 * p1_1;

% Position of link 2 COM in frame 2
p2_2 = [0;...
        L2/2;...
        0];

% Rotation from frame 1 to frame-2
R1_2 = RotX(phi2);
R2_1 = transpose(R1_2);

% Rotation from frame 0 to frame-2
R0_2 = R1_2 * R0_1;
R2_0 = transpose(R0_2);

p2_0 = p1_0+R2_0*p2_2 %Our answer
%% KINEMATICS - VELOCITIES

disp('Kinematics: Velocities')

% LINEAR (fairly simple)
% Link 1
dp1_0 = jacobian(p1_0, q) * dq;
% Link 2
dp2_0 = jacobian(p2_0, q) * dq;

% ANGULAR (this is where things get a bit more complex)
% Link 1 - express in Frame 1
% Derivative of Rotation Matrix
dR1_0 = sym(zeros(3, length(R1_0)));
for i = 1:length(R1_0)
    dR1_0(:,i) = jacobian(R1_0(:,i), q)*dq; 
end
dR1_0 = simplify(dR1_0);

% Skew Symetric Matrix property to express angular rotation in inertial
sOmega_R1_T_1 = simplify(transpose(R1_0) * dR1_0);

omega1_T_1 = [sOmega_R1_T_1(3,2)
              sOmega_R1_T_1(1,3)
              sOmega_R1_T_1(2,1)]; 
omega1_T_1 = simplify(omega1_T_1, 'IgnoreAnalyticConstraints', true);

% Link 2 - express in Frame 2
% Derivative of Rotation Matrix
dR2_0 = sym(zeros(3, length(R2_0)));
for i=1:length(R2_0)
    dR2_0(:,i) = jacobian(R2_0(:,i), q) * dq; 
end
dR2_0 = simplify(dR2_0);

sOmega_R2_T_2 = simplify(transpose(R2_0)*dR2_0);

omega2_T_2 = [sOmega_R2_T_2(3,2)
              sOmega_R2_T_2(1,3);
              sOmega_R2_T_2(2,1)]; 
omega2_T_2 = simplify(omega2_T_2, 'IgnoreAnalyticConstraints', true);
%% KINETIC ENERGY

disp('Kinetic Energy')

% try do this with matrix/vector ops
T1 = 0.5*m1*dp1_0'*dp1_0+ (0.5*omega1_T_1)'*I1_1*omega1_T_1;  %Our answer combo of linear and rot energy 
T2 = 0.5*m2*(dp2_0)'*dp2_0+ (0.5*omega2_T_2)'*I2_2*omega2_T_2; %Our answer

Ttot = simplify(T1 + T2)
%% POTENTIAL ENERGY

disp('Potential Energy')
V1 = 0.5*m1*g'*p1_0(3); %Our answer...only considered z co-ord
V2 = 0.5*m2*g'*p2_0(3); %Our answer...only considered z co-ord

Vtot = simplify(V1 + V2)
%% Mass Matrix

disp('Mass Matrix')

% there is a single one-function command which is the same as the
% loops below. It's similar to how a Jacobian does something which
% might otherwise take a few loops/lines. Calculate M using the mystery
% function

% M = sym([length(q) length(q)]);
% for i = 1:length(q)
%     for j = 1:length(q)
%         M(i,j) = diff(diff(Ttot,dq(i)),dq(j));
%     end
% end
% M = simplify(M);

M = simplify(hessian(Ttot,dq)) %Our answer
%% Derivative of Mass Matrix

disp('Derivative of mass matrix')

dM = sym(size(M));
for i = 1:length(M)
    for j = 1:length(M)
        dM(i,j) = jacobian(M(i,j),q)*dq;
    end
end
dM = simplify(dM);
%% C Matrix -- contains the centrifugal and coriolis accelerations

disp('Coriolis and Centrifugal Matrix')

C = dM * dq - jacobian(Ttot, q)';
C = simplify(C);
%% G Matrix --> Contains the potential energy

disp('Gravity Matrix')

% use a single command which the same as:
% G = sym(zeros(length(q),1));
% for i = 1:length(q)
%     G(i) = diff(Vtot, q(i));
% end
% G = simplify(G);

G = transpose(jacobian(Vtot,q)) %our answer
%% B input matrix - Torque acts on relative angles! - Velocity formulation!!!

disp('Input Torques')
B = [t1; t2];
%B=[0;0]
%% Make this an equation equal to zero, and then simplify it by subbing in values

disp('Equations of Motion')

eqn = simplify(M*ddq + C + G - B);

m1_ = 10;
m2_ = 1;
L1_ = 0.3;
L2_ = 0.25;
g_ = 9.81;
rc_ = 0.1;
eqn = subs(eqn, {m1, m2, L1, L2, g}, {m1_, m2_, L1_, L2_, g_});
%eqn = subs(eqn, {Ix1, Iy1, Iz1}, {1/3*m1*L1,...  %Assumed rod
                                 % 1/3*m1*L1,...
                                 % 0});
%eqn = subs(eqn, {Ix2, Iy2, Iz2}, {1/3*m2*L2*R2_0,...
                                  %0*R2_0,...             %Rotate to frame 0
                                  %1/3*m2*L2*R2_0});
% ... but don't forget which frame the inertias should be in

%inertias when considered as cylinders instead of rods
eqn=subs(eqn,{Ix1,Iy1,Iz1},{1/12*m1*(3*rc_^2+L1^2),(1/12)*m1*(3*rc_^2+L1^2),(1/2)*m1*rc_^2});
eqn=subs(eqn,{Ix2,Iy2,Iz2},{1/12*m2*(3*rc_^2+L2^2), (1/2)*m2*rc_^2         ,(1/12)*m2*(3*rc_^2+L2^2)});
eqn = subs(eqn, {m1, m2, L1, L2, g}, {m1_, m2_, L1_, L2_, g_});



%% solve the equation for accelerations

sol = solve(eqn, ddq);
ddpsi1_eqn = simplify(sol.ddpsi1);
ddphi2_eqn = simplify(sol.ddphi2);

disp('acceleration of psi1 = '); disp(ddpsi1_eqn)
disp('acceleration of phi2 = '); disp(ddphi2_eqn)
%% convert to a regular function (as opposed to a symbolic expression)
% 'vars' corresponds to the order of the arguments that the function accepts

ddpsi1_f = matlabFunction(ddpsi1_eqn,...
    'vars', [psi1, dpsi1, phi2, dphi2, t1, t2]);

ddphi2_f = matlabFunction(ddphi2_eqn,...
    'vars', [psi1, dpsi1, phi2, dphi2, t1, t2]);

% now, if I were good at octave/matlab, I'd give you a nifty solution to
% evaluate the functions derived above in the dynamics function f below.
% But despite it seeming like a simple thing to do I honestly can't figure
% out how to do it because of some silly thing about global variables being
% converted to matrices in some weird way!
% So, just copy-paste the displayed equations (ddpsi1_eqn and ddphi2_eqn)
% into f below to manually calculate it. See the 'create a simulink
% function block' cell below for how it's usually done in Simulink (which
% is why I haven't had to do this myself)

[t,y] = simulate_robotDynamics(@f, [0; 3], [0; 0; 0; 0]);

% quick visualization (comment this out when animating)
%close all;
figure(1)
plot(y);

% for the legend, if using matlab, use:
legend('$\psi_1$', '$\dot{\psi}_1$', '$\phi_2$', '$\dot{\phi}_2$', ...
    'FontSize', 14, 'Interpreter', 'latex');
% if using octave, use:
% h = legend('\psi_1', 'd\psi_1', '\phi_2', 'd\phi_2');

grid on;

% afterwards, just run `anim_robotDynamics`


%%
function [out] = f(t, y)
   %set reference 
    psi1_ref = (1/4)*pi; % 45deg
    phi2_ref = (1/4)*pi; %45 deg
    dpsi1_ref = 0; % 
    dphi2_ref = 0;
    % you have to do this over two lines for unknown reasons
    ycell = num2cell(y);
    [psi1, dpsi1, phi2, dphi2] = ycell{:};
    
    % calculate the input torques, t1 and t2 (control theory)
    % if both are zero, link 2 should just swing back and forth (we didn't
    % add friction)
    % if t1 = 0.1, it should rotate (as well as swing due to gravity)
    % if t2 = 1 and t1 = 0, link 2 should oscillate around some non-zero angle
    %t1 = 0;
    %t2 = 0;
    
     % PD controller for torque actuation
    t1 = 10*(psi1_ref - psi1) + 1*(dpsi1_ref - dpsi1);
    t2 = 100*(phi2_ref - phi2) + 1*(dphi2_ref - dphi2);
   

    % doing this doesn't work:
    %ddpsi1 = ddpsi1_f(psi1, dpsi1, phi2, dphi2, t1, t2);
    %ddphi2 = ddphi2_f(psi1, dpsi1, phi2, dphi2, t1, t2);
    % so, copy-paste the equations here:
    
   %eqns for acceleration 
   ddpsi1=(2*(600*t1 + 11*dphi2*dpsi1*sin(2*phi2)))/(11*(cos(2*phi2) + 7));
   ddphi2= - (11*sin(2*phi2)*dpsi1^2)/28 + (300*t2)/7 - (2943*cos(phi2))/112;
   

    out = [dpsi1; ddpsi1; dphi2; ddphi2];
end

function [t, y] = simulate_robotDynamics(func, tspan, y0)
    options = odeset('MaxStep', 0.05);

    [t, y] = ode45(func, tspan, y0, options);
end
%% [optional] create a simulink function block
% I'm leaving the following code here but commented out so you can see what 
% solving this problem would have been like if we were using Simulink. Feel free 
% to try it out if you have access to it. BUT since we're doing this in matlab 
% only/octave, let's move on!

% new_system('prac4_Q2')  % create a simulink model called 'Q2'
% open_system('prac4_Q2')  % open it
% matlabFunctionBlock('prac4_Q2/ddpsi1_block', sol.ddpsi1)  % add blocks
% matlabFunctionBlock('prac4_Q2/ddphi2_block', sol.ddphi2)
%% utility functions
% writing the matrix like this as a fix for an odd octave bug: <https://savannah.gnu.org/bugs/?45423 
% https://savannah.gnu.org/bugs/?45423>

function rot = RotZ(th)
    rot = [[ cos(th) sin(th) 0]
           [-sin(th) cos(th) 0]
           [       0       0 1]];
end

function rot = RotX(th)
    rot = [[ 1        0       0]
           [ 0  cos(th) sin(th)]
           [ 0 -sin(th) cos(th)]];
end