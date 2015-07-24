function y = betapdfmaxcentered(a,b,fs,twin)

% input
if nargin < 2
    error('please specify the ''a'' and ''b'' parameters for the betapdf');
end
if nargin < 3,  fs      = 250;	end
if nargin < 4,  twin    = 1;    end

% get beta function
x = 0:(1/(fs*twin)):1;
y = betapdf(x,a,b);

% pad with zeros
n = length(x);
[maxy,J] = max(y);
y = y/maxy;
if J < n/2
    m = (n-J) - (J-1);
    y = [zeros(1,m) y];
elseif J > n/2
    m = (J-1) - (n-J);
    y = [y zeros(1,m)];
end