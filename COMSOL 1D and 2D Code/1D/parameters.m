% Set the geometric length of the domain
domLeft=0;
domRight=10;

% Set the kinetic parameters and diffusion ratio
a = 0.01;
b = 1.1;
d = 100; 

% This sets the growth rate S. 

S = ".001*0+0.05*u";
% We'll run the model in blocks.
num_iterations = 15;

% Length, in units of time, of each iteration.
iter_length = 5;

% Number of points to sample at in space for solution.
num_samples = 500;


% Time step to record data.
iter_step = min(iter_length/2,iter_length*num_iterations/500);