function steadyStates = FKPPSteadyStates(params)
%% Compute the steady state directly.
    steadyStates.uSteady = params.K;
    steadyStates.vSteady = 0;
end