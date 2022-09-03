function funcs = GMKineticFuncs(params)
    funcs = struct();
    funcs.f = @(t,u,v) params.a+u.^2./v-params.b*u;
    funcs.g = @(t,u,v) u.^2-params.c*v;
end