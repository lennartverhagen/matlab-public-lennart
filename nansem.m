function y = nansem(x,flag,dim)
narginchk(1,3);

if nargin < 2 || isempty(flag)
    flag = 0;
end

if flag > 1
    dim = flag;
    flag = 0;
elseif nargin < 3;
    [m,n] = size(x);
    if m == 1 && n > 1
        dim = 2;
    else
        dim = 1;
    end
end



y = nanstd(x,flag,dim) / sqrt(size(x,dim));