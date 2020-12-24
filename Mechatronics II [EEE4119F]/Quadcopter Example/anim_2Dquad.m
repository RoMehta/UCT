%% This function will animate the 2D quadcopter
% Amir Patel
% 4 June 2020
%%
close all;
L = 0.2;        %Length of quad
videoFlag = 0;   % Make this one if you want to make a video

if videoFlag ==1
    writerObj = VideoWriter('pFL','MPEG-4');
    writerObj.FrameRate = 30;
    open(writerObj);
end

%% Positions
tempX = x.signals.values;
tempY = y.signals.values;
tempTh = th.signals.values;

% Position of each thruster
pos1 = [tempX + (L*cos(tempTh))/2, tempY + (L*sin(tempTh))/2];
pos2 =  [tempX - (L*cos(tempTh))/2, tempY - (L*sin(tempTh))/2];

% Plot the target point - COMMENT OUT WHEN DOING STABILIZATION
p1 =  plot(3,3, 'rx','MarkerFaceColor','white', 'MarkerSize', 10);

% Create Figure Handles - the rod
h1 = animatedline('LineWidth',5,'Marker','s','MarkerFaceColor','blue', 'MarkerSize', 7.5);

% Create figure
FigHandle = gcf;
grid on
hold on;

% Create xlabel
xlabel({'X Position (m)'},'FontSize',14,'FontName','AvantGarde');

% Create ylabel
ylabel({'Y Position (m)'},'FontSize',14,'FontName','AvantGarde');

% Create title
title({'Quadcopter'},'FontWeight','bold','FontSize',20,...
    'FontName','AvantGarde');

% Set axis limits
axis([-0.5 4 -0.5 4])

for i = 1:length(tempX)
    clearpoints(h1)
    
    % Rod
    addpoints(h1, [pos1(i,1), pos2(i,1)], [pos1(i,2), pos2(i,2)] );

    if videoFlag ==1
        F = getframe(gcf) ;
        writeVideo(writerObj, F);
    end
    drawnow 
   
    xlim('manual')
    ylim('manual')

end

% close the video writer object
if videoFlag ==1
    close(writerObj);

end

