function Plot_Frames(fname)

[x, y, u, xlims, ylims, ulims, X_x, X_y] = loadOutput(fname);
num_t = length(x);
for t_ind=1:num_t
    figure
    mask = ~(isnan(x{t_ind}) | isnan(y{t_ind}) | isnan(u{t_ind}));
    xs = x{t_ind}(mask);
    ys = y{t_ind}(mask);
    us = u{t_ind}(mask);
    surfir(xs(:),ys(:),us(:));
    view(0,90)
    shading interp
    set(gca,'DataAspectRatio',[1,1,1],'FontSize',24)
    xlabel('$x$','Interpreter','latex')
    ylabel('$y$','Interpreter','latex')
    xlim(xlims)
    ylim(ylims)
    axis off;
    %c = colorbar;
    %set(c,'TickLabelInterpreter','latex')
    caxis(ulims)
    %title(['$t$ = ',num2str(t)],'Interpreter','latex')
    axis off;
    drawnow
end