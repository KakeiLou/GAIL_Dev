function dt_integralNoPenalty_g()
%DT_integralNoPenalty_g small doctest for integralNoPenalty_g
%
%   >> f = @(x) exp(-(x-1).^2); q = integralNoPenalty_g(f,'a',1,'b',2,'nlo',100,'nhi',10000,'abstol',1e-5,'nmax',1e7)
%   q = 0.7468
%
% 
%   >> f = @(x) exp(-x.^2); q = integralNoPenalty_g(f,'abstol',1e-5,'nhi',52,'nmax',1e7)
%   q = 0.7468
%
%
%   >> f = @(x) exp(-x.^2); q = integralNoPenalty_g(f,'a',1,'b',2,'abstol',1e-5,'nhi',52,'nmax',1e7)
%   q = 0.1353
%
% 
%   >> f = @(x) exp(-x.^2); q = integralNoPenalty_g(f,'a',0,'b',2,'abstol',1e-5,'nhi',52,'nmax',1e7)
%   q = 0.8821
%
%
%   >> f = @(x) exp(-x.^2); q = integralNoPenalty_g(f,'a',0,'b',2,'nlo',100,'nhi',10000,'abstol',1e-5,'nmax',1e7)
%   q = 0.8821
%
%
%   >> f = @(x) exp(-x.^2); q = integralNoPenalty_g(f,'a',0,'b',3,'nlo',100,'nhi',10000,'abstol',1e-5,'nmax',1e7)
%   q = 0.8862 
%
%
%   >> f = @(x) exp(-x.^2); q = integralNoPenalty_g(f,'a',-1,'b',3,'nlo',100,'nhi',10000,'abstol',1e-5,'nmax',1e7)
%   q = 1.6330
%
%
%   >> f = @(x) exp(-x.^2); q = integralNoPenalty_g(f,'a',-4.5,'b',1.5,'nlo',100,'nhi',10000,'abstol',1e-5,'nmax',1e7)
%   q = 1.7424
%
%
%   When a equals b, the integral value has to be 0.
%   >> q = integralNoPenalty_g(@(x)x.^2,'a',1)
%   q = 0
%
%   
%   When b is Inf, it is corrected to default value 1.
%   >> q = integralNoPenalty_g(@(x)x.^2,'a',0,'b',Inf)
%   q = 0.3333
%  
%
%   When a is Inf, it is corrected to default value 0.
%   >> q = integralNoPenalty_g(@(x)x.^2,'a',Inf)
%   q = 0.3333
%
%
%   When a is NaN, it is corrected to default value 0.
%   >> q = integralNoPenalty_g(@(x)x.^2,'a',NaN)
%   q = 0.3333
%
%
%   When b is NaN, it is corrected to default value 1.
%   >> q = integralNoPenalty_g(@(x)x.^2,'a',0,'b',NaN)
%   q = 0.3333
%
%
%   When a > b, compute negative of the integral.
%   >> q = integralNoPenalty_g(@(x)x.^2,'a',1,'b',0)
%   q = -0.3333
%
%
%   >> q = integralNoPenalty_g(@(x)x.^2,'a',0,'b',2,'nlo',10,'nhi',100)
%   q = 2.6667
%
%
%  Example from Fred Hickernell's email on 20140206:
%   >>  inparam.a=0; inparam.b=3; inparam.abstol=1e-13; q=integralNoPenalty_g(@(x) exp(2*x),inparam)
%   q =  201.2144
%
%
%  Example from Fred Hickernell's email on 20131210:
%   >> q = integralNoPenalty_g(@(x) x.^2,'a',-1,'b',1)
%   q =  0.6667
%
% 
%  >> [~,out_param]=integralNoPenalty_g(@(x) x.^2) 
%         out_param = 
% 
%                    f: @(x)x.^2
%                    a: 0
%                    b: 1
%               abstol: 1.0000e-06
%                  nlo: 10
%                  nhi: 1000
%                ninit: 100
%                 nmax: 10000000
%                  tau: 197
%         exceedbudget: 0
%           conechange: 0
%              npoints: 793
%               errest: 6.8139e-07
%              VarfpCI: [1.9975 3.4193]
%          
%
%   >> f = @(x) exp(-x.^2); [~, out_param] = integralNoPenalty_g(f,'a',1,'b',2,'nlo',100,'nhi',10000,'abstol',1e-5,'nmax',1e7)
%     out_param = 
% 
%                    f: @(x)exp(-x.^2)
%                    a: 1
%                    b: 2
%               abstol: 1.0000e-05
%                  nlo: 100
%                  nhi: 10000
%                ninit: 1000
%                 nmax: 10000000
%                  tau: 1997
%         exceedbudget: 0
%           conechange: 0
%              npoints: 1999
%               errest: 6.2148e-08
%              VarfpCI: [0.6622 1.9848]
end