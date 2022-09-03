function modelParams = getModelParams(selector)
modelParams = struct();
switch selector
    case 'FHN 1'
        % FitzHugh-Nagumo Kinetic Functions.
        % Parameter set 1.
        modelParams.a = 0.6; modelParams.b = 1; modelParams.c = 0.99;
        modelParams.D1 = 1; modelParams.D2 = 3; modelParams.i0 = 0.6;
        funcs = FHNKineticFuncs(modelParams);
        steadyStates = FHNSteadyStates(modelParams);
    case 'FHN 2'
        % FitzHugh-Nagumo Kinetic Functions.
        % Parameter set 1.
        modelParams.a = 1.01; modelParams.b = 1; modelParams.c = 1;
        modelParams.D1 = 1; modelParams.D2 = 2.5; modelParams.i0 = 1;
        funcs = FHNKineticFuncs(modelParams);
        steadyStates = FHNSteadyStates(modelParams);
    case 'SCH 1'
        modelParams.a = 0.01; modelParams.b = 1.1; modelParams.D1 = 1;
        modelParams.D2 = 40;
        funcs = SCHKineticFuncs(modelParams);
        steadyStates = SCHSteadyStates(modelParams);

    case 'GM 1'
        modelParams.a = 0.01; modelParams.b = 0.5;modelParams.c = 5.5;
        modelParams.D1 = 1; modelParams.D2 = 200;
        funcs = GMKineticFuncs(modelParams);
        steadyStates = GMSteadyStates(modelParams);
    case 'Scalar FKPP'
        modelParams.K=1; modelParams.r=1;
        modelParams.D1 = 1; modelParams.D2 = 0;
        funcs = FKPPKineticFuncs(modelParams);
        steadyStates = FKPPSteadyStates(modelParams);
        modelParams.initType = 'wave';

    case 'Scalar FKPP Compact IC'
        modelParams.K=1; modelParams.r=1;
        modelParams.D1 = 1; modelParams.D2 = 0;
        funcs = FKPPKineticFuncs(modelParams);
        steadyStates = FKPPSteadyStates(modelParams);
        modelParams.initType = 'compact wave';
    otherwise
        error('Invalid kinetic selector')
end

modelParams.funcs = funcs;
modelParams.steadyStates = steadyStates;

if(~isfield(modelParams,'initType'))
    modelParams.initType = 'rand';
end


end