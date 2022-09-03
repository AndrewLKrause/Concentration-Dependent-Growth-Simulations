function [xs_mesh, ys_mesh, us_mesh, xlims, ylims, ulims] = make_uniform(x_x,x_y,u,sample_points)
    if nargin < 4
        sample_points = 200;
    end
    num_t = length(x_x);

    xs_mesh = cell(num_t,1);
    ys_mesh = cell(num_t,1);
    us_mesh = cell(num_t,1);

    xlims = [Inf,-Inf];
    ylims = [Inf,-Inf];
    ulims = [Inf,-Inf];
    for t_ind = 1 : num_t
        disp([num2str(t_ind),' / ',num2str(num_t)])
        xs = x_x{t_ind}; xs = xs(:);
        ys = x_y{t_ind}; ys = ys(:);
        us = u{t_ind}; us = us(:);

        mask = isnan(xs) | isnan(ys) | isnan(us);
        xs = xs(~mask);
        ys = ys(~mask);
        us = us(~mask);

        % Update the min/max axis limits.
        xlims(1) = min([xlims(1);xs]);
        xlims(2) = max([xlims(2);xs]);
        ylims(1) = min([ylims(1);ys]);
        ylims(2) = max([ylims(2);ys]);
        ulims(1) = min([ulims(1);us]);
        ulims(2) = max([ulims(2);us]);

        [xs_mesh{t_ind}, ys_mesh{t_ind}] = meshgrid(linspace(min(xs),max(xs),sample_points),linspace(min(ys),max(ys),sample_points));

        us_mesh{t_ind} = griddata(xs,ys,us,xs_mesh{t_ind},ys_mesh{t_ind});
    end

end