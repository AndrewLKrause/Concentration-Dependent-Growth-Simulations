
numSamples = 1e4;
L = 1;
%Below lines give a parametric star-shaped domain.
%gamma = 0.6;
%x = @(s) L * cos(s) .* (1 + gamma * sin(6*s)).^0.5;
%y = @(s) L * sin(s) .* (1 + gamma * sin(6*s)).^0.5;
%s = linspace(0,2*pi,10*numSamples); s = s(:);
%xs = x(s);ys = y(s);
%Below lines give a parametric dumbbell-shaped domain.
x = @(s) L * s;
yu = @(s) L * (s.^8+.01).*sqrt(1-s.^8);
yl = @(s) -L *( s.^8+.01).*sqrt(1-s.^8);
s = linspace(-1,1,10*numSamples); s = s(:);
xs = [x(s);flip(x(s(1:end-1)))];ys = [yu(s);flip(yl(s(1:end-1)))];


% Resample in arclength.
arclengths = [0;cumsum(sum(diff([xs,ys]).^2,2).^0.5)];
uniform_arclengths = linspace(0,arclengths(end),numSamples);
dat = interp1(arclengths, [xs, ys], uniform_arclengths, 'linear');
writematrix(dat,'./boundaries/initBoundary.txt')

plot(xs,ys);