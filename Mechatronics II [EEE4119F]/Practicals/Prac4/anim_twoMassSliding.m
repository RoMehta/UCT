%% This function will animate the two mass sliding problem
% 2 April 2019
% update on 17 March 2020: made compatible with Octave
%RUN IMMEDIATELY AFTER PRAC4Q1
%%
close all;
disp('This runs slightly slower so that you can see the animation')
disp('Make sure the rod length L is defined in your workspace')

%% Positions
%tempAlpha = alpha.signals.values; % uncomment if you simulated in Simulink
tempAlpha = y(:, 1);
pos1 = [zeros(length(tempAlpha),1), L.*cos(tempAlpha)]; % [x, y] positions
pos2 = [L.*sin(tempAlpha), zeros(length(tempAlpha),1)];

%% Create Figure Handles
figure
axis([0 0.6 0 0.6])
grid on
hold on;

% The rod
h1 = line('Color', 'b', 'LineWidth', 1);

% Mass plots
p1 = plot(pos1(1,1),pos1(1,2),'o','MarkerFaceColor','red','MarkerSize',12);
p2 = plot(pos2(1,1),pos2(1,2),'o','MarkerFaceColor','red','MarkerSize',12);

% general plot setup
xlabel({'X Position (m)'},'FontSize',14,'FontName','AvantGarde');
ylabel({'Y Position (m)'},'FontSize',14,'FontName','AvantGarde');

title({'Two Sliding Masses'},'FontWeight','bold','FontSize',20,...
    'FontName','AvantGarde');

%% Update the rod and masses in the plot in a loop
for i = 1:length(tempAlpha)
    % Rod
    % have to do the line below instead of h1.XData = [pos1(i,1), pos2(i,1)]
    % to maintain octave compatibilty, for whatever reason
    set(h1, 'XData', [pos1(i,1), pos2(i,1)]);
    set(h1, 'YData', [pos1(i,2), pos2(i,2)]);

    % Mass Positions
    set(p1, 'XData', pos1(i,1));
    set(p1, 'YData', pos1(i,2));
    set(p2, 'XData', pos2(i,1));
    set(p2, 'YData', pos2(i,2));
    
    pause(0.1);  % the time per loop is (calculation/render time) + (pause)
                 % this doesn't need to be done properly -- we'll work on
                 % that in part 2 of this prac
    drawnow 
   
    xlim('manual')
    ylim('manual')
end
