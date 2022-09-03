ep = 0.002;
figure
nexttile
plot(t,gradient(L,t) ./ L)
xlabel('$t$')
ylabel('$S_{eff}$','Interpreter','latex')
set(gca,'FontSize',24)
nexttile
plot(t,(gradient(L,t) ./ L) .* (1+ep*t)/ep)
xlabel('$t$')
ylabel('$S_{eff}$ / $(\epsilon / (1+\epsilon t))$','Interpreter','latex')
set(gca,'FontSize',24)