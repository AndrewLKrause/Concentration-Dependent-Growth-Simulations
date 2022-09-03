function materialFlow(num_csv)

    if nargin < 1
        num_csv = 4;
    end

    % Bad practice - disable warnings
    warning('off','all');

    % Files to load, in chronological order.
    fnames = {};
    for i = 1 : num_csv
        fnames{end+1} = ['csvs/', num2str(i), '.csv'];
    end

    % Do the files overlap at the last/first frame?
    overlap = true;

    % Load the datafiles.
    X = {};
    x = {};
    u = {};
    disp("Loading...")
    for f_ind = 1 : length(fnames)
        disp([num2str(f_ind), ' / ', num2str(length(fnames))])

        fname = fnames{f_ind};
        [new_X, new_x, new_u] = loadOutput(fname);

        % If the files overlap and this isn't the first file...
        if overlap & (f_ind > 1)
          % Remove the first frame.
          new_X = new_X(2:end);
          new_x = new_x(2:end);
          new_u = new_u(2:end);
        end

        if f_ind == 1
            X_samples = linspace(min(new_X{1}), max(new_X{1}), 1e3);
            material_points = zeros(length(X_samples),1);
            counter = 0;
        else
            % If we've processed a file before, we need the final locations of
            % the material points from the previous file as these are the
            % Lagrangian coordinates of these material points in the new file.
            X_samples = material_points(:,end);
        end

        for i = 1 : length(new_x)
            material_points(:,i + counter) = interp1(new_X{i}, new_x{i}, X_samples);
        end
        counter = counter + length(new_x);

        % Stack the data into a single cell array.
        X = [X; new_X];
        x = [x; new_x];
        u = [u; new_u];
    end

    num_t = length(x);
    ts = 0:1:num_t-1;

    figure
    plot(material_points(1:10:end,:)',ts,'Color','black')
    set(gca,'FontSize',24)
    xlabel('$x(X,t)$','Interpreter','latex')
    ylabel('$t$','Interpreter','latex')
    axis tight

end

% We're going to track material points as they move. This is simple, apart
    % from between sections of a simulation.
