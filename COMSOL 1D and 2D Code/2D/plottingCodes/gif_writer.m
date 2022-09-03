function gif_writer(fname, delayTime, xs_mesh, ys_mesh, us_mesh, xlims, ylims, ulims, dt, skip)
    if nargin < 9
        skip = 1;
    end

    if nargin < 8
        dt = 10;
    end

    h = figure;
    t = 0;
    num_t = length(xs_mesh);
    for t_ind = 1 : skip : num_t

      surf(xs_mesh{t_ind},ys_mesh{t_ind},us_mesh{t_ind},'LineStyle','none')
      view(0,90)
      shading interp
      set(gca,'DataAspectRatio',[1,1,1],'FontSize',24)
      xlabel('$x$','Interpreter','latex')
      ylabel('$y$','Interpreter','latex')
      xlim(xlims)
      ylim(ylims)
      c = colorbar;
      set(c,'TickLabelInterpreter','latex')
      caxis(ulims)
      title(['$t$ = ',num2str(t)],'Interpreter','latex')
      drawnow
      
      % Capture the plot as an image 
      frame = getframe(h); 
      im = frame2im(frame); 
      [imind,cm] = rgb2ind(im,256); 
      % Write to the GIF File 
      if t_ind == 1 
        imwrite(imind,cm,fname,'gif', 'Loopcount',inf,'DelayTime',delayTime); 
      else 
        imwrite(imind,cm,fname,'gif','WriteMode','append','DelayTime',delayTime); 
      end

      t = t + skip*dt;

    end

    close(h)

end