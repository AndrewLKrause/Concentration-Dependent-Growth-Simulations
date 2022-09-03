function [x_x, x_y, u, xlims, ylims, ulims, X_x, X_y] = loadOutput(fname)
%% loadOutput(fname) - Load the COMSOL output file given by fname. Data will
% be read as a table, structured by fixed Lagrangian coordinates. Outputs will
% be cell arrays of Eulerian x, Eulerian y, and corresponding activator
% concentration u. Data is assumed to be at uniform timesteps, which must be
% specified after the fact. Data must also be specified on a regular grid,
% with NaN values being acceptable. The input file should be structured with
% columns: [X, Y, u, x, y]. Output is [x, y, u, xlims, ylims, X, Y].

    if nargin < 1
        fname = 'output.nosync/ActualConcentrationDepLarger0_2000.csv';
    end

    % Import data (a slow process in general).
    T = readtable(fname);
    D = table2array(T);

    % Constant Lagrangian coordinates in mesh form. 
    % X_x = [X0, X1, ...; X0, X1, ...;...]
    X_x_vec = D(:, 1);
    X_y_vec = D(:, 2);
    num_X = length(unique(X_x_vec));
    num_Y = length(unique(X_y_vec));

    X_x = reshape(X_x_vec, num_X, num_Y)';
    X_y = reshape(X_y_vec, num_X, num_Y)';

    X_x_vec = X_x(1, :)';
    X_y_vec = X_y(:, 1);

    % Number of timesteps.
    num_t = (size(D, 2) - 2)/3; % replace denominator with 3 if 2 species are output.

    % Initialise Eulerian domain and u,W.
    x_x = cell(num_t,1);
    x_y = cell(num_t,1);
    u = cell(num_t,1);

    % u as a function of Lagrangian coordinate.
    min_u = Inf;
    max_u = -Inf;
    for i = 1 : num_t
        u{i} = reshape(D(:, 3*(i-1)+3), num_X, num_Y)';
        min_u = min(min_u, min(u{i}(:)));
        max_u = max(max_u, max(u{i}(:)));
    end

    % x_x as a function of Lagrangian coordinate.
    min_x_x = Inf;
    max_x_x = -Inf;
    for i = 1 : num_t
        x_x{i} = reshape(D(:, 3*(i-1)+4), num_X, num_Y)';
        min_x_x = min(min_x_x, min(x_x{i}(:)));
        max_x_x = max(max_x_x, max(x_x{i}(:)));
    end

    % x_y as a function of Lagrangian coordinate.
    min_x_y = Inf;
    max_x_y = -Inf;
    for i = 1 : num_t
        x_y{i} = reshape(D(:, 3*(i-1)+5), num_X, num_Y)';
        min_x_y = min(min_x_y, min(x_y{i}(:)));
        max_x_y = max(max_x_y, max(x_y{i}(:)));
    end

    xlims = [min_x_x, max_x_x];
    ylims = [min_x_y, max_x_y];
    ulims = [min_u, max_u];

end