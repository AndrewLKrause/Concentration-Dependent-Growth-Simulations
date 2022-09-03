%% Main script used to generate a single simulation.
addpath(genpath('helpers'))

% Select and retrieve the kinetics and associated parameters.
modelParamsSelector = 'Scalar FKPP Compact IC';
modelParams = getModelParams(modelParamsSelector);

% Select and retrieve the growth rate and simulation-specific metaparameters.
growthParamsSelector = '0.05TWLin';
growthParams = getGrowthParams(growthParamsSelector);

% Solver options - grid size, internal timestep size controls.
simulationParams = setupSimulationOptions();

% Setup model to be simulated.
modelSimulation = setupModel(modelParams, growthParams, simulationParams);

% Run the model, getting the output as a structure.
output = runModel(modelSimulation);

% Save the output structure. Filepath is given as a cell array of folders of
% decreasing level.
saveOutput({'output',modelParamsSelector,growthParamsSelector},output);


% If the runUniform flag is 1, run a uniform simulation with the same 
% growth lengthscale change over the same timescale.
if (output.growthParams.runUniform)
    disp('Running equivalent dynamics with uniform growth:')
    modelSimulation.growthParams.S = @(t,u,v)log(output.xs(end,end)/growthParams.L)/(growthParams.iterLength*growthParams.numIter)+0*u;
    output = runModel(modelSimulation);
    saveOutput({'output',modelParamsSelector,growthParamsSelector,'uniform'},output);
end
