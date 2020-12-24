%qn.11a
%data = uiimport('prac.csv');
gndspeed = data.GndSpeed;
time = 0:99;
plot(time, gndspeed); xlabel('Seconds'); ylabel('GndSpeed');
grid on;

%qn.11b
maxSpeed = max(gndspeed);
index = find(gndspeed == maxSpeed);
time4max = time(index);

%qn.11c
minSpeed = min(gndspeed);
index2 = find(gndspeed == minSpeed);
time4min = time(index2);

acc1 = (gndspeed(20)-gndspeed(1)) / (time(20)-time(1));
acc2 = (gndspeed(49)-gndspeed(20)) / (time(49)-time(20));
acc3 = (gndspeed(80)-gndspeed(49)) / (time(80)-time(49));

acc_total = acc1 + acc2 + acc3;
    