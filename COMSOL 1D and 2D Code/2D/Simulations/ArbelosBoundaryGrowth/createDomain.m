
numSamples = 1e4;
L = 1;
close all;
% %Below lines give a parametric star-shaped domain.
% gamma = 0;
% x = @(s) L * cos(s) .* (1 + gamma * sin(5*s)).^0.5;
% y = @(s) L * sin(s) .* (1 + gamma * sin(5*s)).^0.5;
% s = linspace(0,2*pi,10*numSamples); s = s(:);
% xs = x(s);ys = y(s);
%Below lines give a parametric disc-shaped domain.
c= pi/20;
x = @(s) (L * cos(s+c)).*(s<=pi-2*c)+(2*L/5 *cos(s+4*c)-3/5).*(s>pi-2*c).*(s<=2*pi-5*c)+(-3*L/5 *cos(s+6*c)+2/5).*(s>2*pi-5*c);
y = @(s) (L * sin(s+c)).*(s<=pi-2*c)+(-2*L/5 * sin(s+4*c)).*(s>pi-2*c).*(s<=2*pi-5*c)+(3*L/5 * sin(s+6*c)).*(s>2*pi-5*c);
s = linspace(0,3*pi-7.5*c,10*numSamples); s = s(:);
xs = x(s);ys = y(s);
ys(end+1) = ys(1); xs(end+1) = xs(1);
Xs =ys<0.1; xs(Xs) = []; ys(Xs) = [];
% Resample in arclength.
arclengths = [0;cumsum(sum(diff([xs,ys]).^2,2).^0.5)];
uniform_arclengths = linspace(0,arclengths(end),numSamples);
dat = interp1(arclengths, [xs, ys], uniform_arclengths, 'linear');
writematrix(dat,'./boundaries/initBoundary.txt')

plot(xs,ys);