function modelSimulation = setupModel(modelParams, growthParams, simulationOptions)

modelSimulation = struct();
modelSimulation.modelParams = modelParams;
modelSimulation.growthParams = growthParams;
modelSimulation.simulationOptions = simulationOptions;

N = simulationOptions.N;


switch modelSimulation.modelParams.initType
    case 'rand'
        %Initial random perturbation of homogeneous steady state
        rng(1);
        u0 = modelParams.steadyStates.uSteady * (1 + 1e-1*randn(N,1));
        v0 = modelParams.steadyStates.vSteady * (1 + 1e-1*randn(N,1));

    case 'wave'
        %For scalar models use 'travelling wave' initial data.
        x = linspace(0,growthParams.L, simulationOptions.N)';
        u0 = modelParams.steadyStates.uSteady*(1+tanh(growthParams.L/5-x))/2;
        v0 = zeros(N,1);

    case 'compact wave'
        %For scalar models use 'travelling wave' initial data.
        x = linspace(0,growthParams.L, simulationOptions.N)';
        u0 = modelParams.steadyStates.uSteady*(1+tanh(growthParams.L/20-x))/2;
        % Compact IC which is zero for u0<0.01.
        u0(x>(growthParams.L/20 + atanh(49/50))) = 0; 
        v0 = zeros(N,1);
        

end
modelSimulation.initialConditions = [u0; v0; ones(N,1); zeros(N,1)];

%Variable indices
modelSimulation.uIndices  = 1     : N;
modelSimulation.vIndices  = N+1   : 2*N;
modelSimulation.muIndices = 2*N+1 : 3*N;
modelSimulation.xIndices  = 3*N+1 : 4*N;

%Create Jacobian sparsity patern.
Is = speye(N);
LPs = spdiags(ones(N,3),[-1,0,1],N,N);

JPattern = sparse(4*N,4*N);
JPattern(modelSimulation.uIndices, modelSimulation.uIndices)  = LPs;
JPattern(modelSimulation.vIndices, modelSimulation.uIndices)  = Is;
JPattern(modelSimulation.muIndices,modelSimulation.uIndices)  = Is;
JPattern(modelSimulation.xIndices, modelSimulation.uIndices)  = Is;
JPattern(modelSimulation.uIndices, modelSimulation.vIndices)  = Is;
JPattern(modelSimulation.vIndices, modelSimulation.vIndices)  = LPs;
JPattern(modelSimulation.muIndices,modelSimulation.vIndices)  = Is;
JPattern(modelSimulation.xIndices, modelSimulation.vIndices)  = Is;
JPattern(modelSimulation.uIndices, modelSimulation.muIndices) = LPs;
JPattern(modelSimulation.vIndices, modelSimulation.muIndices) = LPs;
JPattern(modelSimulation.muIndices,modelSimulation.muIndices) = Is;
JPattern(modelSimulation.xIndices, modelSimulation.muIndices) = Is;

%ODE tolerances
modelSimulation.odeParams = odeset('RelTol', 1e-11, 'AbsTol', 1e-11, 'JPattern', JPattern, 'MaxStep', 1);

end