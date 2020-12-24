v_x = [50:0.5:100];
v_y = [100:200];

dist = [sqrt((my_function.x(v_x')).^2 + (my_function.y(v_y)).^2)];

surf(v_x,v_y,dist);
xlabel('v_x');
ylabel('v_y');
zlabel('miss');

[x,y]=find(dist==min(min(dist)));

x_v = v_x(y)
x_y = v_y(x)