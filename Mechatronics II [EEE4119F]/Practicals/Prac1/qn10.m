t = [0:0.02:10];
f = 1./t;
r = (0.2-(-0.2)).*randn(501,1) + -0.2;
y = sin(2*pi*t)+(r')

subplot(4,1,1);
plot(t,y);
title('Original')

j = sqrt(-1);
w = 2*pi.*f;
z = j.*w;
%h = (1./0.5).*exp(-(t/0.5))*0.02;
%H = fft(h);
H = 1./(1 + (1/0.02).*(z.^(-1)));

Y = fft(y);
G = H.*Y;
g = ifft(G);

subplot(4,1,2);
plot(t,g);
title('time constant = 0.02s')

H1 = 1./(1 + (1/0.5).*(z.^(-1)));

G1 = H1.*Y;
g1 = ifft(G1);

subplot(4,1,3);
plot(t,g1);
title('time constant = 0.5s')

H2 = 1./(1 + (1/1).*(z.^(-1)));

G2 = H2.*Y;
g2 = ifft(G2);

subplot(4,1,4);
plot(t,g2);
title('time constant = 1s')