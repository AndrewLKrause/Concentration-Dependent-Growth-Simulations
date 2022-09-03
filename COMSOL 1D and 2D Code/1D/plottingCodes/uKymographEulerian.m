function uKymographEulerian(dir_csvs,centreing,num_csv)

if nargin < 1
    dir_csvs = '.';
end
if nargin < 2
    centreing=0;
end
% Get the parameters for the simulation we are plotting.
run([dir_csvs,'/parameters'])
if nargin < 3
    num_csv = num_iterations;
end

% Bad practice - disable warnings
warning('off','all');

% Files to load, in chronological order.
fnames = {};
for i = 1 : num_csv
    fnames{end+1} = [dir_csvs, '/csvs/', num2str(i), '.csv'];
end

% Do the files overlap at the last/first frame?
overlap = true;

% Load the datafiles.
X = {};
x = {};
u = {};
t = {};
disp("Loading...")
for f_ind = 1 : length(fnames)
    disp([num2str(f_ind), ' / ', num2str(length(fnames))])
    
    fname = fnames{f_ind};
    [new_X, new_x, new_u] = loadOutput(fname);
    
    % If the files overlap and this isn't the first file...
    if overlap && (f_ind > 1)
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
        t{i + counter,1} = (i+counter) * ones(length(new_x{i}),1);
        
        % CENTRED EDIT HERE - shift new material points.
        if(centreing)
            new_x{i} = new_x{i} - material_points(round(end/2),i+counter);
        end
    end
    counter = counter + length(new_x);
    
    % Stack the data into a single cell array.
        
    X = [X; new_X];
    x = [x; new_x];
    u = [u; new_u];
end
xs = cell2mat(x);
us = cell2mat(u);
ts = cell2mat(t);

mask = ~(isnan(xs(:)) | isnan(us(:)));
xs = xs(mask);
us = us(mask);
ts = ts(mask);

figure
surfir(xs(:),ts(:),us(:));
xlabel('$x$', 'Interpreter', 'latex')
ylabel('$t$', 'Interpreter', 'latex')
c = colorbar;
c.TickLabelInterpreter = 'latex';
c.Label.String = '$u$';
c.Label.Interpreter = 'latex';
set(gca,'FontSize',24)
axis tight;
view(0,90)
box on
colormap(viridis)
shading interp

% Correct t labels
ax = gca;
delY = (ax.YLim(end)-ax.YTick(end));
T = num_csv*iter_length;
Ts = linspace(T*delY/ax.YLim(end),T,length(ax.YTickLabels));
ax.YTick = ax.YTick+delY;
ax.YTickLabels = Ts;

exportgraphics(gcf,[dir_csvs,'/uKymographEulerian.png'])

end