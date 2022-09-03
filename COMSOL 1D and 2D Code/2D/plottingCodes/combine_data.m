function [x,y,u,xlims,ylims,ulims] = combine_data(fdir, saveFlag)

    if nargin < 2
        saveFlag = true;
    end

    % Do the files overlap at the last/first frame?
    overlap = true;
    % Load the datafiles.
    x = {};
    y = {};
    u = {};
    xlims = [Inf,-Inf];
    ylims = [Inf,-Inf];
    ulims = [Inf,-Inf];

    numCsv = num_files(fdir,'.csv');

    for fInd = 1 : numCsv
        fprintf(['\r', num2str(fInd), ' / ', num2str(numCsv)])

        % Load in the data from the next file.
        fname = [fdir, filesep, num2str(fInd), '.csv'];
        [new_x, new_y, new_u, xRange, yRange, uRange] = loadOutput(fname);

        % Update the max/min limits of the values.
        xlims(1) = min([xlims(1);xRange(1)]);
        xlims(2) = max([xlims(2);xRange(2)]);
        ylims(1) = min([ylims(1);yRange(1)]);
        ylims(2) = max([ylims(2);yRange(2)]);
        ulims(1) = min([ulims(1);uRange(1)]);
        ulims(2) = max([ulims(2);uRange(2)]);

        % If the files overlap and this isn't the first file...
        if overlap & (fInd > 1)
          % Remove the first frame.
          new_x = new_x(2:end);
          new_y = new_y(2:end);
          new_u = new_u(2:end);
        end

        % Stack the data into a single cell array.
        x = [x; new_x];
        y = [y; new_y];
        u = [u; new_u];
    end

    if saveFlag
        save('combined.mat','x','y','u','xlims','ylims','ulims')
    end
end