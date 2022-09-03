function funcs = FKPPKineticFuncs(params)
    funcs = struct();
    funcs.f = @(t,u,v) params.r*u.*(1-u/params.K);
    funcs.g = @(t,u,v) 0*v;
end