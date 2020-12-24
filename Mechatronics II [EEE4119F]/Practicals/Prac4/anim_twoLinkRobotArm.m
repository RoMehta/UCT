%% This function will animate the two mass sliding problem
% 2 April 2019 update on 17 March 2020: made compatible with Octave

close all;
disp('This runs slightly slower so that you can see the animation')
disp('Make sure the rod length L is defined in your workspace')
%% Positions

%tempAlpha = alpha.signals.values; % uncomment if you simulated in Simulink

temppsi = y(:, 1); %y values generated from simulateRobotDynamics
tempphi = y(:,3);  %y values generated from simulateRobotDynamics
% [x,y,z] positions
L1=0.5;
L2=0.25;
pos1= [zeros(length(temppsi),1),zeros(length(temppsi),1),L1/2.*ones(length(temppsi),1)]; %joint between link 1 and 2
pos2=[-(L2.*cos(tempphi).*sin(temppsi))./2, (L2.*cos(tempphi).*cos(temppsi))./2, L1/2 + (L2.*sin(tempphi))./2]; %tip on link 2
pos3=[zeros(length(temppsi),1),zeros(length(temppsi),1),zeros(length(temppsi),1)];%base
%% Create Figure Handles

figure
%axis([0 0.6 0 0.6 0 0.6])
grid on
hold on;

% rods
h1 = line('Color', 'b', 'LineWidth', 1); %link 2 actually
h2 = line('Color', 'b', 'LineWidth', 1); %link 1 actually, messed up naming convention...

% Mass plots
p1 = plot3(pos1(1,1),pos1(1,2),pos1(1,3),'o','MarkerFaceColor','red','MarkerSize',12);
p2 = plot3(pos2(1,1),pos2(1,2),pos2(1,3),'o','MarkerFaceColor','blue','MarkerSize',12);
p3 = plot3(pos3(1,1),pos3(1,2),pos3(1,3),'o','MarkerFaceColor','green','MarkerSize',12); %co-ords of masses

% general plot setup
xlabel({'X Position (m)'},'FontSize',14,'FontName','AvantGarde');
ylabel({'Y Position (m)'},'FontSize',14,'FontName','AvantGarde');
zlabel({'Z Position (m)'},'FontSize',14,'FontName','AvantGarde');

title({'Two-link robot arm'},'FontWeight','bold','FontSize',20,...
    'FontName','AvantGarde');
%% Update the rod and masses in the plot in a loop

for i = 1:length(temppsi)
    % Rod
    % have to do the line below instead of h1.XData = [pos1(i,1), pos2(i,1)]
    % to maintain octave compatibilty, for whatever reason
    set(h1, 'XData', [pos1(i,1), pos2(i,1)]);
    set(h1, 'YData', [pos1(i,2), pos2(i,2)]);
    set(h1, 'ZData', [pos1(i,3), pos2(i,3)]);
    set(h2, 'XData', [pos1(i,1), pos3(i,1)]);
    set(h2, 'YData', [pos1(i,2), pos3(i,2)]);
    set(h2, 'ZData', [pos1(i,3), pos3(i,3)]); %properties of links

    % Mass Positions
    set(p1, 'XData', pos1(i,1));
    set(p1, 'YData', pos1(i,2));
    set(p1, 'ZData', pos1(i,3));
    set(p2, 'XData', pos2(i,1));
    set(p2, 'YData', pos2(i,2));
    set(p2, 'ZData', pos2(i,3));
    set(p3, 'XData', pos3(i,1));
    set(p3, 'YData', pos3(i,2));
    set(p3, 'ZData', pos3(i,3)); %update point data
    
    pause(0.1);  % the time per loop is (calculation/render time) + (pause)
                 % this doesn't need to be done properly -- we'll work on
                 % that in part 2 of this prac
    drawnow 
   
    xlim('manual')
    ylim('manual')
    %zlim('manual')
    view(20,20) %needed this to allow 3d plot to show for some reason...
end