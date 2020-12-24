x = 0:0.1:(3*pi);
y = sin(x);
y(y<=0) = 0;

plot(x, y);