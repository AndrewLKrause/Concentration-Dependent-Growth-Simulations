%% Sweep over different simulations.
addpath(genpath('helpers'))

simsToDo = {};

%The commented out lines below correspond to individual Figure panels in
%the paper. 

%  simsToDo{end+1} = {'SCH 1', '0.25(1+tanh(100(u-1.2))'};
%  simsToDo{end+1} = {'SCH 1', '0.05(1+tanh(100(u-1.2))'};
  %simsToDo{end+1} = {'SCH 1', '0.005(1+tanh(100(u-1.2))'}; 
%  simsToDo{end+1} = {'SCH 1', '0.02u'};
%  simsToDo{end+1} = {'SCH 1', '0.1u'};
%  simsToDo{end+1} = {'SCH 1', '0.15u'};
%  simsToDo{end+1} = {'SCH 1', '0.01(u-1.3v)'};
%  simsToDo{end+1} = {'SCH 1', '0.05(u-1.3v)'};
%  simsToDo{end+1} = {'SCH 1', '0.161(u-1.3v)'};
%  simsToDo{end+1} = {'SCH 1', '0.162(u-1.3v)'};
%  simsToDo{end+1} = {'SCH 1', '0.163(u-1.3v)'};
%  simsToDo{end+1} = {'SCH 1', '0.163(u-1.3v)L5'};
% simsToDo{end+1} = {'SCH 1', '0.1635(u-1.3v)'};
% simsToDo{end+1} = {'SCH 1', '0.165(u-1.3v)'};
% simsToDo{end+1} = {'SCH 1', '0.166(u-1.3v)'};
% simsToDo{end+1} = {'SCH 1', '0.167(u-1.3v)'};
% simsToDo{end+1} = {'SCH 1', '0.164(u-1.3v)'};
% simsToDo{end+1} = {'SCH 1', '0.259(u-1.3v)'};
% simsToDo{end+1} = {'SCH 1', '0.26(u-1.3v)'};
%simsToDo{end+1} = {'GM 1', '0.0005(6v-u^2)'};
%simsToDo{end+1} = {'GM 1', '0.0004(6v-u^2)'};
%simsToDo{end+1} = {'GM 1', '0.0003(6v-u^2)'};
%simsToDo{end+1} = {'GM 1', '0.0002(6v-u^2)'};
%simsToDo{end+1} = {'GM 1', '0.0001(6v-u^2)'};
%simsToDo{end+1} = {'GM 1', '0.00001(6v-u^2)'};
%simsToDo{end+1} = {'Scalar FKPP', '0.005(1-u)TW'};
%simsToDo{end+1} = {'Scalar FKPP', '0.005uTW'};
%simsToDo{end+1} = {'Scalar FKPP', '0TW'};
%simsToDo{end+1} = {'Scalar FKPP', '0.0025(1-2u)TW'};
%simsToDo{end+1} = {'FHN 2', '0.01uFHN'};
%simsToDo{end+1} = {'FHN 2', '0.05uFHN'};
%simsToDo{end+1} = {'FHN 2', '0.2uFHN'};
%simsToDo{end+1} = {'FHN 2', '0.3uFHN'};
%simsToDo{end+1} = {'Scalar FKPP', '0.0025(1-2u)TW'};
%simsToDo{end+1} = {'Scalar FKPP', '0.005(1-2u)TW'};
%simsToDo{end+1} = {'Scalar FKPP', '0.01(1-2u)TW'};



failedSims = zeros(length(simsToDo),1);
parfor simInd = 1 : length(simsToDo)
    simSels = simsToDo{simInd};
        try 
            % Get the current selectors.
            modelParamsSelector = simSels{1};
            growthParamsSelector = simSels{2};
            disp([modelParamsSelector, '; ', growthParamsSelector])

            % Retrieve the parameters.
            modelParams = getModelParams(modelParamsSelector);
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
                modelSimulation.growthParams.S = @(t,u,v)log(output.xs(end,end)/growthParams.L)/(growthParams.iterLength*growthParams.numIter)+0*u;
                output = runModel(modelSimulation);
                saveOutput({'output',modelParamsSelector,growthParamsSelector,'uniform'},output);
            end

        catch exception
            exception
            disp('FAILED')
            failedSims(simInd) = 1;

        end
    disp('------')
end
disp("Sweep complete!")

if any(failedSims)
    disp([num2str(sum(failedSims)), ' simulation(s) failed:'])
    for simInd = 1 : length(simsToDo)
        if failedSims(simInd)
            simSels = simsToDo{simInd};
            modelParamsSelector = simSels{1};
            growthParamsSelector = simSels{2};
            disp([modelParamsSelector, '; ', growthParamsSelector])
        end
    end
end