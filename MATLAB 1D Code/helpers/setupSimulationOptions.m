function simulationParams = setupSimulationOptions()
simulationParams = struct();

simulationParams.N = 10000;
simulationParams.relativeTolerance = 1e-11;
simulationParams.absoluteTolerance = 1e-11;
simulationParams.maxStep = 1;

end