function growthParams = getGrowthParams(selector)
growthParams = struct();
switch selector
    case '0.25(1+tanh(100(u-1.2))'
        % Fig1(f); uniform is (c)
        S = @(t,u,v)0.25*(1+tanh(100*(u-1.2)));
        numIter = 25; iterLength = 4;
        L = 5;
        runUniform = 1;
    case '0.05(1+tanh(100(u-1.2))'
        % Fig1(e); uniform is (b)
        S = @(t,u,v)0.05*(1+tanh(100*(u-1.2)));
        numIter = 24; iterLength = 5.5;
        L = 5;
        runUniform = 1;
    case '0.005(1+tanh(100(u-1.2))'
        % Fig1(d); uniform is (a)
        S = @(t,u,v)0.005*(1+tanh(100*(u-1.2)));
        numIter = 25; iterLength = 50;
        L = 5;
        runUniform = 1;
    case '0.02u'
        % Fig1(g)
        S = @(t,u,v)0.02*u;
        numIter = 46; iterLength = 5;
        L = 5;
        runUniform = 0;
    case '0.1u'
        % Fig1(h)
        S = @(t,u,v)0.1*u;
        numIter = 428; iterLength = 0.125;
        L = 5;
        runUniform = 0;
    case '0.15u'
        % Fig1(i)
        S = @(t,u,v)0.15*u;
        numIter = 162; iterLength = 0.25;
        L = 5;
        runUniform = 0;
    case '0.01(u-1.3v)'
        % Fig3(a)
        S = @(t,u,v)0.01*(u-1.3*v);
        numIter = 200; iterLength = 10;
        L = 10;
        runUniform = 0;
    case '0.05(u-1.3v)'
        % Fig3(b)
        S = @(t,u,v)0.05*(u-1.3*v);
        numIter = 122; iterLength = 4;
        L = 10;
        runUniform = 0;
    case '0.161(u-1.3v)'
        % Fig3(c)
        S = @(t,u,v)0.161*(u-1.3*v);
        numIter = 350; iterLength = 4;
        L = 10;
        runUniform = 0;
    case '0.162(u-1.3v)'
        % Fig3(d)
        S = @(t,u,v)0.162*(u-1.3*v);
        numIter = 350; iterLength = 4;
        L = 10;
        runUniform = 0;
    case '0.163(u-1.3v)'
        % Fig3(e)
        S = @(t,u,v)0.163*(u-1.3*v);
        numIter = 350; iterLength = 4;
        L = 10;
        runUniform = 0;
    case '0.163(u-1.3v)L5'
        % Fig3(f)
        S = @(t,u,v)0.163*(u-1.3*v);
        numIter = 350; iterLength = 4;
        L = 5;
        runUniform = 0;
    case '0.164(u-1.3v)'
        % Fig3(g)
        S = @(t,u,v)0.164*(u-1.3*v);
        numIter = 500; iterLength = 4;
        L = 10;
        runUniform = 0;
    case '0.1635(u-1.3v)'
        % Fig3(g)
        S = @(t,u,v)0.1635*(u-1.3*v);
        numIter = 500; iterLength = 4;
        L = 10;
        runUniform = 0;

    case '0.1645(u-1.3v)'
        % Fig3(g)
        S = @(t,u,v)0.1645*(u-1.3*v);
        numIter = 500; iterLength = 4;
        L = 10;
        runUniform = 0;
    case '0.165(u-1.3v)'
        % Fig3(g)
        S = @(t,u,v)0.165*(u-1.3*v);
        numIter = 200; iterLength = 4;
        L = 10;
        runUniform = 0;
    case '0.166(u-1.3v)'
        % Fig3(g)
        S = @(t,u,v)0.166*(u-1.3*v);
        numIter = 200; iterLength = 4;
        L = 10;
        runUniform = 0;
    case '0.167(u-1.3v)'
        % Fig3(g)
        S = @(t,u,v)0.167*(u-1.3*v);
        numIter = 200; iterLength = 4;
        L = 10;
        runUniform = 0;
    case '0.258(u-1.3v)'
        % Fig3(h)
        S = @(t,u,v)0.258*(u-1.3*v);
        numIter = 200; iterLength = 4;
        L = 10;
        runUniform = 0;
    case '0.259(u-1.3v)'
        % Fig3(h)
        S = @(t,u,v)0.259*(u-1.3*v);
        numIter = 200; iterLength = 4;
        L = 10;
        runUniform = 0;
    case '0.26(u-1.3v)'
        % Fig3(i)
        S = @(t,u,v)0.26*(u-1.3*v);
        numIter = 200; iterLength = 4;
        L = 10;
        runUniform = 0;


    case '0.00001(6v-u^2)'
        % WORK IN PROGRESS - does Weird things for GM 1!
        S = @(t,u,v)0.00001*(6*v-u.^2); 
        numIter = 400; iterLength = 100;
        L = 10;
        runUniform = 1;
    case '0.0001(6v-u^2)'
        % WORK IN PROGRESS - does Weird things for GM 1!
        S = @(t,u,v)0.0001*(6*v-u.^2); 
        numIter = 400; iterLength = 10;
        L = 10;
        runUniform = 1;
    case '0.0002(6v-u^2)'
        % WORK IN PROGRESS - does Weird things for GM 1!
        S = @(t,u,v)0.0002*(6*v-u.^2); 
        numIter = 400; iterLength = 5;
        L = 10;
        runUniform = 1;
    case '0.0003(6v-u^2)'
        % WORK IN PROGRESS - does Weird things for GM 1!
        S = @(t,u,v)0.0003*(6*v-u.^2); 
        numIter = 500; iterLength = 0.6;
        L = 10;
        runUniform = 1;
    case '0.0004(6v-u^2)'
        % WORK IN PROGRESS - does Weird things for GM 1!
        S = @(t,u,v)0.0004*(6*v-u.^2); 
        numIter = 500; iterLength = 0.5;
        L = 10;
        runUniform = 1;
    case '0.0005(6v-u^2)'
        % WORK IN PROGRESS - does Weird things for GM 1!
        S = @(t,u,v)0.0005*(6*v-u.^2); 
        numIter = 500; iterLength = 0.8;
        L = 10;
        runUniform = 1;

    case '0.0025(1-2u)TW'
        S = @(t,u,v)0.0025*(1-2*u); 
        numIter = 1000; iterLength = 0.2;
        %numIter = 2000; iterLength = 0.1;
        L = 300;
        runUniform = 0;
    case '0.005(1-2u)TW'
        S = @(t,u,v)0.005*(1-2*u); 
        numIter = 1000; iterLength = 0.2;
        %numIter = 2000; iterLength = 0.1;%TESTING SOMETHING
        L = 300;
        runUniform = 0;
    case '0.01(1-2u)TW'
        S = @(t,u,v)0.01*(1-2*u); 
        numIter = 1000; iterLength = 0.5;
        L = 300;
        runUniform = 0;

    case '0.005(1-u)TW'
        S = @(t,u,v)0.005*(1-u); 
        numIter = 200; iterLength = 1;
        L = 300;
        runUniform = 0;
        %growthParams.outputsPerIter = max(ceil(1000/numIter+1),3);
    case '0.005uTW'
        S = @(t,u,v)0.005*u; 
        numIter = 200; iterLength = 1;
        L = 300;
        runUniform = 0;
        %growthParams.outputsPerIter = max(ceil(1000/numIter+1),3);

    case '0TW'
        S = @(t,u,v)0.*(1-u); 
        numIter = 1; iterLength = 130;
        L = 300;
        runUniform = 0;
        %growthParams.outputsPerIter = max(ceil(1000/numIter+1),3);



    case '0.01(1-u)TW'
        S = @(t,u,v)0.01*(1-u); 
        numIter = 200; iterLength = 3;
        L = 300;
        runUniform = 0;
        %growthParams.outputsPerIter = max(ceil(1000/numIter+1),3);
    case '0.012(1-u)TW'
        S = @(t,u,v)0.012*(1-u); 
        numIter = 200; iterLength = 3;
        L = 300;
        runUniform = 0;
        %growthParams.outputsPerIter = max(ceil(1000/numIter+1),3);
    case '0.014(1-u)TW'
        S = @(t,u,v)0.014*(1-u); 
        numIter = 200; iterLength = 3;
        L = 300;
        runUniform = 0;
        %growthParams.outputsPerIter = max(ceil(1000/numIter+1),3);
    case '0.016(1-u)TW'
        S = @(t,u,v)0.016*(1-u); 
        numIter = 200; iterLength = 3;
        L = 300;
        runUniform = 0;
        %growthParams.outputsPerIter = max(ceil(1000/numIter+1),3);
    case '0.018(1-u)TW'
        S = @(t,u,v)0.018*(1-u); 
        numIter = 200; iterLength = 3;
        L = 300;
        runUniform = 0;
        %growthParams.outputsPerIter = max(ceil(1000/numIter+1),3);
    case '0.02(1-u)TW'
        S = @(t,u,v)0.02*(1-u); 
        numIter = 200; iterLength = 3;
        L = 300;
        runUniform = 0;
        %growthParams.outputsPerIter = max(ceil(1000/numIter+1),3);
    case '0.05TW'
        S = @(t,u,v)0.05+0*u; 
        numIter = 100; iterLength = 1;
        L = 300;
        runUniform = 0;
        %growthParams.outputsPerIter = max(ceil(1000/numIter+1),3);
   case '0.05TWLin'
       r = 1.484131591010761;
        S = @(t,u,v)r/(1+t*r)+0*u; 
        numIter = 100; iterLength = 1;
        L = 300;
        runUniform = 0;
        %growthParams.outputsPerIter = max(ceil(1000/numIter+1),3);

    case '0.01uFHN'
        % FHNFIG
        S = @(t,u,v)0.01*u;
        numIter = 100; iterLength = 15;
        L = 5;
        runUniform = 1;
    case '0.05uFHN'
        % FHNFIG
        S = @(t,u,v)0.05*u;
        numIter = 100; iterLength = 5;
        L = 5;
        runUniform = 1;
    case '0.2uFHN'
        % FHNFIG
        S = @(t,u,v)0.2*u;
        numIter = 300; iterLength = 0.5;
        L = 5;
        runUniform = 1;
    case '0.3uFHN'
        % FHNFIG
        S = @(t,u,v)0.3*u;
        numIter = 50; iterLength = 0.5;
        L = 5;
        runUniform = 0;


    otherwise
        error('Invalid growth and params selector')
end


growthParams.S = S;
growthParams.numIter = numIter;
growthParams.iterLength = iterLength;
if(~isfield(growthParams,'outputsPerIter'))
    growthParams.outputsPerIter = max(ceil(300/numIter+1),3); % THIS DETERMINES FINAL SIZE OF STRUCTURES ETC
    % THIS DETERMINES FINAL SIZE OF STRUCTURES ETC
end
growthParams.L = L;
growthParams.runUniform = runUniform;

end