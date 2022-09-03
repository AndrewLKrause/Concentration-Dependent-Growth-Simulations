addpath(genpath('.'))
addpath(genpath('plottingCodes'))

% Clear CSV data for cleanliness - be careful!
delete csvs/*;

% Absolute path of the model directory.
current_dir = [pwd(),'/'];

% Get the parameters for the current run.
parameters;

% Open the COMSOL model.
model = mphopen('model.mph');

% Set the geometric length of the domain
model.param.set('domLeft', domLeft);
model.param.set('domRight', domRight); %USE 40

% Set the kinetic parameters and diffusion ratio
model.param.set('a', a);
model.param.set('b', b);
model.param.set('d', d);

% This sets the growth rate S. 
% Note that I've replaced 'epsil' by a fixed number.
model.func("an1").set("expr", S);

% Run the model with the above parameters.
tic; runModel; toc;

% Plot a kymograph
uKymographEulerian('.',0);