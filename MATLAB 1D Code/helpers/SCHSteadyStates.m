function steadyStates = SCHSteadyStates(params)
%% Compute the steady state directly.
    steadyStates.uSteady = params.a+params.b;
    steadyStates.vSteady = params.b/steadyStates.uSteady^2;

end