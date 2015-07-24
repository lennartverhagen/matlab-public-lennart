function y = sem(varargin)

if length(varargin) < 3;
    [m,n] = size(varargin{1});
    if m == 1;
        dim = 2;
    else
        dim = 1;
    end
else
    dim = varargin{3};
end

if length(varargin) < 2;
    flag = 0;
else
    flag = varargin{2};
end

if length(varargin) <1;
    error('??? Input argument "x" is undefined.')
else
    x = varargin{1};
end

y = std(x,flag,dim) / sqrt(size(x,dim));