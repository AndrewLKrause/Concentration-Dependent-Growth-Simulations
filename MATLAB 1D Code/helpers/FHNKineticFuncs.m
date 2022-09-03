function funcs = FHNKineticFuncs(params)
    funcs = struct();
    funcs.f = @(t,u,v) params.c * (u - u.^3/3 + v - params.i0);
    funcs.g = @(t,u,v) (params.a - u - params.b*v) / params.c;
end