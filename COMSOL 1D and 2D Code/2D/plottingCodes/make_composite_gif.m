sample_points = 400;
delayTime = 1/15;
skip = 1;
dt = 10;
forceLoad = false;

% Bad practice - disable warnings
warning('off','all');


% Files to load, in chronological order.
num_csv = 167;
fnames = {};
for i = 1 : num_csv
    fnames{end+1} = ['csvs/', num2str(i), '.csv'];
end


% Check if we need to reload the data.
if exist('oldFnames','var')
  newDataFlag = false;
  % If there are different numbers of files, reload.
  if length(fnames) ~= length(oldFnames)
    newDataFlag = true;
  else
    for i = 1 : length(fnames)
      newDataFlag = newDataFlag | ~strcmp(fnames{i}, oldFnames{i});
    end
  end
else
  newDataFlag = true;
end

output_fnameGif = 'output.gif'; 
output_fnameMp4 = 'output.mp4'; 

% Do the files overlap at the last/first frame?
overlap = true;

if newDataFlag | forceLoad
  % Load the datafiles.
  x = {};
  y = {};
  u = {};
  xlims = [Inf,-Inf];
  ylims = [Inf,-Inf];
  ulims = [Inf,-Inf];
  disp("Loading...")
  for f_ind = 1 : length(fnames)
    disp([num2str(f_ind), ' / ', num2str(length(fnames))])

    fname = fnames{f_ind};
    [new_x, new_y, new_u, xRange, yRange, uRange] = loadOutput(fname);

    % Update the max/min limits of the values.
    xlims(1) = min([xlims(1);xRange(1)]);
    xlims(2) = max([xlims(2);xRange(2)]);
    ylims(1) = min([ylims(1);yRange(1)]);
    ylims(2) = max([ylims(2);yRange(2)]);
    ulims(1) = min([ulims(1);uRange(1)]);
    ulims(2) = max([ulims(2);uRange(2)]);

    % If the files overlap and this isn't the first file...
    if overlap & (f_ind > 1)
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
end

% Store the names of the loaded files to avoid reloading them in the future.
oldFnames = fnames;

video_writer(output_fnameMp4, delayTime, x, y, u, xlims, ylims, ulims, dt, skip)
disp("Done!")
