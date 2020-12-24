%% This function will animate the 2D quadcopter
% Amir Patel
% 4 June 2020
%%
close all;
L = 0.2;        %Length of quad
videoFlag = 0;   % Make this one if you want to make a video

if videoFlag == 1
    writerObj = VideoWriter('target','MPEG-4');
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
hT = plot(rT.signals.values(1,1), rT.signals.values(1,2), 'Color', 'k',...
    'Marker','o', 'MarkerSize', 5, 'MarkerFaceColor', 'k', 'LineWidth', 2);

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
title({'Quadcopter catching ball'},'FontWeight','bold','FontSize',20,...
    'FontName','AvantGarde');

% Set axis limits
axis([-15 5 0 20])
set(FigHandle, 'Position', [100, 100, 1000, 1000]);

for i = 1:length(tempX)
    clearpoints(h1)
    set(hT,'XData',rT.signals.values(i,1),'YData',rT.signals.values(i,2));
    
    % Rod
    addpoints(h1, [pos1(i,1), pos2(i,1)], [pos1(i,2), pos2(i,2)] );

    
    drawnow 
    if videoFlag ==1
        F = getframe(gcf) ;
        writeVideo(writerObj, F);
    end
    xlim('manual')
    ylim('manual')

end

% close the video writer object
if videoFlag ==1
    close(writerObj);
end

