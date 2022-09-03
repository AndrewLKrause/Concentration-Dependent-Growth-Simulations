close all;

us = output.us;vs = output.vs; xs = output.xs; ts = output.ts; 
S = modelSimulation.growthParams.S;


umax = max(max(max(us)),max(max(S(ts,us,vs))));
umin = min(min(min(us)),min(min(abs(S(ts,us,vs)))));
Xs = xs - xs(:,end)/2;
xmax = max(max(Xs));
xmin = min(min(Xs));

f = figure;
f.Position(3) = 2*f.Position(3);
f.Position(4) = 1.5*f.Position(4);
f.Position(1:2) = 0.5*f.Position(1:2);
for i=1:length(ts)
    plot(Xs(i,:),us(i,:),'linewidth',2); hold on
    plot(Xs(i,:),vs(i,:),'linewidth',2);
    xline(Xs(i,1),'--k','linewidth',2);xline(Xs(i,end),'--k','linewidth',2);
    Si = S(ts(i),us(i,:),vs(i,:))>0; Sin = S(ts(i),us(i,:),vs(i,:))<0;
    plot(Xs(i,Si),S(ts(i),us(i,Si),vs(i,Si)),'g*','linewidth',2);
    plot(Xs(i,Sin),-S(ts(i),us(i,Sin),vs(i,Sin)),'r*','linewidth',2);
    axis([xmin xmax umin umax])
    drawnow;hold off;
    pause(0.1)
end