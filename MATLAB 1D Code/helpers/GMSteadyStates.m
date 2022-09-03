function steadyStates = GMSteadyStates(params)
%% Compute the steady state directly.
    steadyStates.uSteady = (params.a + params.c)/params.b;
    steadyStates.vSteady = steadyStates.uSteady^2/params.c;
end