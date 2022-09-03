
numSamples = 1e4;
L = 3;
%Below lines give a parametric star-shaped domain.
%gamma = 0.6;
%x = @(s) L * cos(s) .* (1 + gamma * sin(6*s)).^0.5;
%y = @(s) L * sin(s) .* (1 + gamma * sin(6*s)).^0.5;
%s = linspace(0,2*pi,10*numSamples); s = s(:);
%xs = x(s);ys = y(s);
%Below lines give a parametric disc-shaped domain.
x = @(s) L * cos(s);
y = @(s) L * sin(s);
s = linspace(0,2*pi,10*numSamples); s = s(:);
xs = x(s);ys = y(s);

% Resample in arclength.
arclengths = [0;cumsum(sum(diff([xs,ys]).^2,2).^0.5)];
uniform_arclengths = linspace(0,arclengths(end),numSamples);
dat = interp1(arclengths, [xs, ys], uniform_arclengths, 'linear');
writematrix(dat,'./boundaries/initBoundary.txt')

plot(xs,ys);