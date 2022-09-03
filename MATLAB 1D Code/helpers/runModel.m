function output = runModel(modelSimulation, verbFlag)

if nargin < 2
    verbFlag = true;
end

%% Extract parameters and functions from modelSimulation for notational
%% simplicity.
N = modelSimulation.simulationOptions.N;
dX = modelSimulation.growthParams.L / (N-1);
odeParams = modelSimulation.odeParams;

uI = modelSimulation.uIndices;
vI = modelSimulation.vIndices;
muI = modelSimulation.muIndices;
xI = modelSimulation.xIndices;

uInit = modelSimulation.initialConditions();

numIter = modelSimulation.growthParams.numIter;
iterLength = modelSimulation.growthParams.iterLength;
outputsPerIter = modelSimulation.growthParams.outputsPerIter;

S = modelSimulation.growthParams.S;
f = modelSimulation.modelParams.funcs.f;
g = modelSimulation.modelParams.funcs.g;
D1 = modelSimulation.modelParams.D1;
D2 = modelSimulation.modelParams.D2;

us = reshape(uInit(uI), 1, []);
vs = reshape(uInit(vI), 1, []);
xs = reshape(cumtrapz(ones(N,1)), 1, []) * dX;
ts = [0];
tCurrent = 0;

%% Solve and iterate.
tic
for iter = 1 : numIter
    % Display iteration count.
    fprintf(['\r',repmat(' ',1,length(num2str(numIter))*2 + 3)])
    fprintf(['\r',num2str(iter),' / ',num2str(numIter)])

    % Times at which to generate the solution during this iteration.
    T = linspace(tCurrent, tCurrent+iterLength, outputsPerIter);

    % RHS of the system. Note dX changes each iteration.
    F = @(t,U)[f(t,U(uI),U(vI))-S(t,U(uI),U(vI)).*U(uI)+D1*(1/dX)^2*Lap(U(uI),U(muI));...
        g(t,U(uI),U(vI))-S(t,U(uI),U(vI)).*U(vI)+D2*(1/dX)^2*Lap(U(vI),U(muI));...
        S(t,U(uI),U(vI)).*U(muI); S(t,U(uI),U(vI))];

    % Solve the system using a stiff solver and low tolerances.
    sol = ode15s(F, T, uInit, odeParams);
    % Evaluate the solution on T.
    U = deval(sol,T)';

    % Extract the solution.
    u = U(:,uI);
    v = U(:,vI);
    mu = U(:,muI);

    % Form the Eulerian domain.
    x = cumtrapz(exp(U(:,xI)),2)*dX;

    % Store the output.
    us = [us; u(2:end,:)];
    vs = [vs; v(2:end,:)];
    xs = [xs; x(2:end,:)];
    ts = [ts; T(2:end)'];
    tCurrent = T(end);

    % Prepare for the next iteration.
    % Compute the current domain length.
    Ln = xs(end,end);
    % Compute a uniform Lagrangian domain and dX.
    X = linspace(0, Ln, N);
    dX = Ln / (N-1);


    % Construct the initial condition from the final timepoint.
    u0 = reshape(interp1(x(end,:), u(end,:), X), [], 1);
    v0 = reshape(interp1(x(end,:), v(end,:), X), [], 1);
    uInit = [u0; v0; ones(N,1); zeros(N,1)];

    %plot(u0); drawnow;

    % Display the total time elapsed, along with the current domain length.
    if verbFlag
        fprintf(['. Cumulative time taken: ',num2str(toc,4), '; Domain length: ', num2str(Ln,4)])
    end

end
fprintf('\n')
% Package the output and parameters.
output = struct();
output.xs = xs;
output.us = us;
output.vs = vs;
output.ts = ts;
output.modelParams = modelSimulation.modelParams;
output.growthParams = modelSimulation.growthParams;
output.simulationOptions = modelSimulation.simulationOptions;

end

% 1D Laplacian incorporating local volume form mu.
% This looks like: D*(D*u_x)_x, where D=1/mu.
% Division by dX does not occur here!
function u = Lap(u,mu)
% u(i-1)-2*u(i)+u(i+1)
D = 1./mu; D2 = D.^2;
u = [(D2(1)+D(1)*D(2)).*(u(2)-u(1));...
    D2(2:end-1).*(u(1:end-2)-2*u(2:end-1)+u(3:end))+D(2:end-1).*(D(3:end).*(u(3:end)-u(2:end-1)) +D(1:end-2).*(u(1:end-2)-u(2:end-1)));...
    (D2(end)+D(1)*D(2)).*(u(end-1)-u(end))]./2;
end