function [X, x, u] = loadOutput(fname)

    % Import data (a slow process in general).
    T = readtable(fname);
    D = table2array(T);

    % Number of timesteps.
    num_t = (size(D, 2) - 1)/2; % replace denominator with 3 if 2 species are output.

    % Initialise Lagrangian and Eulerian domain and u.
    X = cell(num_t,1);
    x = cell(num_t,1);
    u = cell(num_t,1);

    % X, the (constant) Lagrangian coordinate.
    for i = 1 : num_t
        X{i} = D(:, 1);
    end

    % u as a function of Lagrangian coordinate.
    min_u = Inf;
    max_u = -Inf;
    for i = 1 : num_t
        u{i} = D(:, 2*(i-1)+2);
        min_u = min(min_u, min(u{i}(:)));
        max_u = max(max_u, max(u{i}(:)));
    end

    % Gamma_X and x as a function of Lagrangian coordinate.
    for i = 1 : num_t
        x{i} = D(:, 2*(i-1)+3);
    end

end