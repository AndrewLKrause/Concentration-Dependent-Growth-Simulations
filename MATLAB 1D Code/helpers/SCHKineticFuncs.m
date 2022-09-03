function funcs = SCHKineticFuncs(params)
    funcs = struct();
    funcs.f = @(t,u,v) params.a-u+u.^2.*v;
    funcs.g = @(t,u,v) params.b - u.^2.*v;
end