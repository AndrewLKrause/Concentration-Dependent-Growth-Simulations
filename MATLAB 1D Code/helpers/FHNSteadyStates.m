function steadyStates = FHNSteadyStates(params)
%% Compute the steady state via solving a cubic in u - worth checking there 
% is only 1 or use max of the 3.

    rts = roots([-1/3, 0, 1 - 1/params.b, params.a/params.b - params.i0]); 
    uSteady = real(rts(abs(imag(rts)) < 1e-11)); 
    uSteady = max(uSteady);
    vSteady = (params.a - uSteady) / params.b;

    steadyStates = struct();
    steadyStates.uSteady = uSteady;
    steadyStates.vSteady = vSteady;

end