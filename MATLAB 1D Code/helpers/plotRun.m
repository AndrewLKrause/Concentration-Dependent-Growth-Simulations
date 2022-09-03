function f = plotRun(filepath,centred,onlyLines)
if(nargin < 2)
    centred = 1;
end

if nargin < 3
    onlyLines = false;
end

% Load output structure.
load([filepath,filesep,'output.mat']);
us = output.us;
vs = output.vs;
xs = output.xs;
ts = output.ts;
S = output.growthParams.S;
N = output.simulationOptions.N;

if ~onlyLines
    f = figure('Visible','off');
    Ts = repmat(ts,1,N);
    if(centred == 1)
        Xs = xs - xs(:,end)/2;
    else
        Xs = xs;
    end
    surfir(Xs(:),Ts(:),us(:),1);
    xlabel('$x$', 'Interpreter', 'latex')
    ylabel('$t$', 'Interpreter', 'latex')
    c = colorbar;
    colormap(viridis)
    c.TickLabelInterpreter = 'latex';
    c.Label.String = '$u$';
    c.Label.Interpreter = 'latex';
    set(gca,'FontSize',24,'TickLabelInterpreter','latex')
    axis tight;
    view(0,90)
    box on
    exportgraphics(f, [filepath,filesep,'kymograph.png'])

    if nargout < 1
        close(f)
    else
        f.Visible = 'on';
    end

end



% -----
% Line plots.
% -----

g = figure('Visible','off');
g.Position(3) = 2*g.Position(3);
g.Position(4) = 1.5*g.Position(4);
g.Position(1:2) = 0.5*g.Position(1:2);

samples = round([0.3,0.6,0.9]*length(ts));

ymax = max(max(max(us(min(samples):max(samples),:))),max(max(S(ts(min(samples):max(samples),:),us(min(samples):max(samples),:),vs(min(samples):max(samples),:)))));
ymin = min(min(min(us(min(samples):max(samples),:))),min(min(abs(S(ts(min(samples):max(samples),:),us(min(samples):max(samples),:),vs(min(samples):max(samples),:))))));
Xs = xs - xs(:,end)/2;
xmax = max(max(Xs(min(samples):max(samples),:)));
xmin = min(min(Xs(min(samples):max(samples),:)));

for i = samples
    clf
    hold on
    plot(Xs(i,:),us(i,:),'linewidth',2, 'Color','black')
    xline(Xs(i,1),'--k','linewidth',2);xline(Xs(i,end),'--k','linewidth',2)
    Si = S(ts(i),us(i,:),vs(i,:)) > 0; 
    Sin = S(ts(i),us(i,:),vs(i,:)) < 0;
    plot(Xs(i,Si),S(ts(i),us(i,Si),vs(i,Si)),'g*','linewidth',2)
    plot(Xs(i,Sin),-S(ts(i),us(i,Sin),vs(i,Sin)),'r*','linewidth',2)
    axis([xmin xmax ymin ymax])
    box on
    set(gca,'FontSize',48,'TickLabelInterpreter','latex')
    exportgraphics(g, [filepath,filesep,'line_',num2str(i),'.eps'])
end

end


% clf
% i = round(size(Xs,1)*1);
% plot(Xs(i,:),us(i,:),'linewidth',2); hold on

% Si = S(ts(i),us(i,:),vs(i,:))>=0; Sin = S(ts(i),us(i,:),vs(i,:))<=0;
% plot(Xs(i,Si),S(ts(i),us(i,Si),vs(i,Si)),'g','linewidth',2);
% plot(Xs(i,Sin),-S(ts(i),us(i,Sin),vs(i,Sin)),'r','linewidth',2);
% axis tight;
% xlabel('$x$', 'Interpreter', 'latex')
% ylabel('$u$', 'Interpreter', 'latex')
% set(gca,'FontSize',24)