% Absolute path of the model directory.
current_dir = [pwd(),'/'];

% Open the COMSOL model.
model = mphopen('model.mph');



% Set the growth rate as S = 2*F(u)
model.func("an2").set("expr", "0*.001*(1+tanh(10*u))/2");

% -----------------------
% Ensure that the model is set up to solve from init conditions.
% Build from parameterised boundary curve in initBoundary.txt
model.geom('geom2').feature('ic1').set('filename', [current_dir,'boundaries/initBoundary.txt']);
model.geom('geom2').feature('ic1').importData();
model.geom('geom2').runAll();

% Build the mesh.
model.mesh('mesh2').run()

% Disable the custom init condition.
model.physics('uvPDE').feature('init2').active(false);

% -----------------------
% Set up paths for exporting.
model.result.export('data3').set('filename', [current_dir,'temp/UpdatedDomainU.txt']);

% -----------------------
% We'll run the model in blocks.
num_iterations = 1;

% Length, in units of time, of each iteration.
iter_length = 10000;

% Number of points to sample at in space for solution.
num_samples = 401 - 1;

model.study('std1').feature('time').set('plot', 'on');

for iter = 1 : num_iterations

    % Set the range of t in each simulation.
    ts = ((iter-1)*iter_length:10000:iter*iter_length)'; % start:step:stop
    model.study('std1').feature('time').set('tlist', ts);

    % Display number of elements.
    disp([num2str(iter),' / ',num2str(num_iterations),'. Number of elements: ',num2str(model.component('comp2').mesh('mesh2').getNumElem),'.'])

    % Run the model.
    model.study('std1').run();
    
    % -----------------------
    % Export the results on a regular grid.
    % First, find the max extent of the domain.
    lims = model.geom('geom2').getBoundingBox();
    xmin = lims(1); xmax = lims(2); ymin = lims(3); ymax = lims(4);
    xrange = xmax - xmin; yrange = ymax - ymin;
    model.result.export('data1').set('gridx2', ['range(',num2str(xmin),',',num2str(xrange/num_samples),',',num2str(xmax),')']);
    model.result.export('data1').set('gridy2', ['range(',num2str(ymin),',',num2str(yrange/num_samples),',',num2str(ymax),')']);
    model.result.export('data1').set('filename', [current_dir,'csvs/',num2str(iter),'.csv']);
    model.result.export('data1').run();
    
    % -----------------------
    % Export the boundary.
    if iter == 1
        % Load in the original boundary in initBoundary.txt.
        model.result.export('data2').set('coordfilename', [current_dir,'boundaries/initBoundary.txt']);
        
    else
        % Load in the updated boundary from the last iteration.
        model.result.export('data2').set('coordfilename', [current_dir,'boundaries/',num2str(iter - 1),'.txt']);
    end
    model.result.export('data2').set('filename', [current_dir,'boundaries/',num2str(iter),'.txt']);
    model.result.export('data2').run();
    
    % -----------------------
    % Export u and v for initialising the next block.
    model.result.export('data3').run();
    %model.result.export('data4').run();
    
    % -----------------------
    % Trim the exported data.
    fname = ['./boundaries/',num2str(iter),'.txt'];
    dat = importdata(fname); dat = dat(:,3:end); 
    % We want to resample the boundary uniformly in arclength.
    arclengths = [0;cumsum(sum(diff(dat).^2,2).^0.5)];
    uniform_arclengths = linspace(0,arclengths(end),length(arclengths));
    dat = interp1(arclengths, dat, uniform_arclengths, 'linear');
    writematrix(dat,fname);
    
    fname = './temp/UpdatedDomainU.txt';
    dat = importdata(fname); dat = dat(:,3:end); writematrix(dat,fname);
    
    fname = './temp/UpdatedDomainV.txt';
    dat = importdata(fname); dat = dat(:,3:end); writematrix(dat,fname);
    
    % -----------------------
    % Set up the model for the next iteration.
    % First, refresh the data stored in the interpolated functions for u
    % and v.
    if iter == 1
        % Set up paths for importing.
        model.func('int1').set('filename', [current_dir,'temp/UpdatedDomainU.txt']);
        % Activate functions.
        model.func('int1').active(true);
    end
    model.func('int1').refresh()
    
    % Next, load in the new boundary curve.
    model.geom('geom2').feature('ic1').set('filename', [current_dir,'boundaries/',num2str(iter),'.txt']);
    model.geom('geom2').feature('ic1').importData();
    model.geom('geom2').runAll();
    
    % Enable the custom init condition.
    model.physics('uvPDE').feature('init2').active(true); 
    
    % Build the mesh.
    model.mesh('mesh2').run();
    
end
disp("Done!")