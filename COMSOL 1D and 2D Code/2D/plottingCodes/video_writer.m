function video_writer(fname, delayTime, x, y, u, xlims, ylims, ulims, dt, skip)
    if nargin < 12
        skip = 1;
    end

    if nargin < 11
        dt = 10;
    end

    h = figure;
    t = 0;
    num_t = length(x);

    v = VideoWriter(fname, 'MPEG-4');
    % v = VideoWriter(fname);
    v.FrameRate = 1/delayTime;
    v.Quality = 70;
    open(v)
    for t_ind = 1 : skip : num_t
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
      
      % Capture the plot as an image 
      frame = getframe(h); 
      writeVideo(v,frame);
      t = t + skip*dt;

    end

    close(v)
    close(h)

end