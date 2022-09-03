% Assuming these are called by runAndPlot.m - uncomment if not.
% Absolute path of the model directory.
%current_dir = [pwd(),'/'];

% Open the COMSOL model.
%model = mphopen('model.mph');

% -----------------------
% Ensure that the model is set up to solve from init conditions.
% Build from geometry from initBoundary.txt

% Load in LHS,RHS params from file in MATLAB, then set in COMSOL and build.
% NOTE: Overwritten in runAndPlot
%domain_params = importdata([current_dir,'boundaries/initBoundary.txt']);
%model.param.set('domLeft', domain_params(1));
%model.param.set('domRight', domain_params(2));
model.geom('geom1').runAll();

% Build the mesh.
model.mesh('mesh1').run()

% Disable the custom init condition.
model.func('int1').active(false);
model.func('int2').active(false);
model.physics('uvPDE').feature('init2').active(false);

% -----------------------
% Set up paths for exporting.
model.result.export('data2').set('filename', [current_dir,'temp/UpdatedDomainU.txt']);
model.result.export('data3').set('filename', [current_dir,'temp/UpdatedDomainV.txt']);


% -----------------------
% Assuming these are called by runAndPlot.m - uncomment if not.
% We'll run the model in blocks.
%num_iterations = 10;

% Length, in units of time, of each iteration.
%iter_length = 80;

% Number of points to sample at in space for solution.
%num_samples = 801 - 1;

% Time step to record data.
%iter_step

model.study('std1').feature('time').set('plot', 'on');

for iter = 1 : num_iterations

    % Set the range of t in each simulation.
    %ts = ((iter-1)*iter_length:iter_step:iter*iter_length)'; % start:step:stop
    %Testing if setting t=0 initially changes things...
    ts = (0:iter_step:iter_length)'; % start:step:stop
    model.study('std1').feature('time').set('tlist', ts);

    % Display number of elements.
    disp([num2str(iter),' / ',num2str(num_iterations),'. Number of elements: ',num2str(model.component('comp1').mesh('mesh1').getNumElem),'.'])

    % Run the model.
    model.study('std1').run();
    
    % -----------------------
    % Export the results on a regular grid.
    % First, find the max extent of the domain.
    lims = model.geom('geom1').getBoundingBox();
    xmin = lims(1); xmax = lims(2);
    xrange = xmax - xmin;
    model.result.export('data1').set('gridx1', ['range(',num2str(xmin),',',num2str(xrange/num_samples),',',num2str(xmax),')']);
    model.result.export('data1').set('filename', [current_dir,'csvs/',num2str(iter),'.csv']);
    model.result.export('data1').run();
    
    % -----------------------
    % Export the boundary. The range of points is already set as [domLeft, domRight].
    model.result.export('data4').set('filename', [current_dir,'boundaries/',num2str(iter),'.txt']);
    model.result.export('data4').run();
    
    % -----------------------
    % Export u and v for initialising the next block.
    model.result.export('data2').run();
    model.result.export('data3').run();
    
    % -----------------------
    % Trim the exported data.
    fname = ['./boundaries/',num2str(iter),'.txt'];
    dat = importdata(fname); dat = dat(:,2:end);
    writematrix(dat,fname);
    
    fname = './temp/UpdatedDomainU.txt';
    dat = importdata(fname); dat = dat(:,2:end); writematrix(dat,fname);
    
    fname = './temp/UpdatedDomainV.txt';
    dat = importdata(fname); dat = dat(:,2:end); writematrix(dat,fname);
    
    % -----------------------
    % Set up the model for the next iteration.
    % First, refresh the data stored in the interpolated functions for u
    % and v.
    if iter == 1
        % Set up paths for importing.
        model.func('int1').set('filename', [current_dir,'temp/UpdatedDomainU.txt']);
        model.func('int2').set('filename', [current_dir,'temp/UpdatedDomainV.txt']);
        % Activate functions.
        model.func('int1').active(true);
        model.func('int2').active(true);
    end
    model.func('int1').refresh()
    model.func('int2').refresh()
    
    % Next, load in the new boundary positions.
    domain_params = importdata([current_dir,'boundaries/',num2str(iter),'.txt']);
    model.param.set('domLeft', domain_params(1));
    model.param.set('domRight', domain_params(2));
    model.geom('geom1').runAll();
    
    % Enable the custom init condition.
    model.physics('uvPDE').feature('init2').active(true); 
    
    % Build the mesh.
    model.mesh('mesh1').run();
    
end
disp("Done!")
