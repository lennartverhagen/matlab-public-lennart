function x = qchisq(P,n)
% QCHISQ(P,N) - quantile of the chi-square distribution.
if nargin<2
    n=1;
end

% give immediate answers for common combinations (using a lookup table)
[check,idx] = ismember(P,[0.50 0.683 0.9 0.95 0.99]);
if all(check)
    table = [	0.45493292554816	1.38629436111989    2.36597417213509
                1.00128337342664	2.29770701020971    3.52915931280502
                2.70553910716604	4.60517018598809     6.2513938583449
                3.84144792925059	5.99146454710798    7.81474218186117
                6.63482056759025	9.21034037197619    11.3449878348602];
	x = table(idx,n);
    return
end

% fill in extremes
s0 = P==0;
s1 = P==1;
s = P>0 & P<1;
x = 0.5*ones(size(P));
x(s0) = -inf;
x(s1) = inf;
x(~(s0|s1|s))=nan;

% find chi-square quantile using the chi-square probability distribution
for ii=1:14
    dx = -(pchisq(x(s),n)-P(s))./dchisq(x(s),n);
    x(s) = x(s)+dx;
    if all(abs(dx) < 1e-6)
        break;
    end
end
%--------------------------------------------------------------------------


function F = pchisq(x,n)
% PCHISQ(X,N) - Probability function of the chi-square distribution.
if nargin<2
    n=1;
end
F=zeros(size(x));

% if iseven(n)
if rem(n,2) == 0
    s = x>0;
    k = 0;
    for jj = 0:n/2-1;
        k = k + (x(s)/2).^jj/factorial(jj);
    end
    F(s) = 1-exp(-x(s)/2).*k;
else
    for ii=1:numel(x)
        if x(ii) > 0
            F(ii) = quadl(@dchisq,0,x(ii),1e-6,0,n);
        else
            F(ii) = 0;
        end
    end
end
%--------------------------------------------------------------------------


function f = dchisq(x,n)
% DCHISQ(X,N) - Density function of the chi-square distribution.
if nargin<2
    n=1;
end
f=zeros(size(x));
s = x>=0;
f(s) = x(s).^(n/2-1).*exp(-x(s)/2)./(2^(n/2)*gamma(n/2));
%--------------------------------------------------------------------------