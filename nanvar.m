function y = nanvar(x,flag,dim)
narginchk(1,3);

% unbiased or biased variance calculation
if nargin < 2 || isempty(flag)
    flag = 0;
end

% dimension and size
sz = size(x);
if flag > 1
    dim = flag;
    if isempty(dim), dim = find(sz ~= 1, 1); end
    flag = 0;
elseif nargin < 3 || isempty(dim)
    dim = find(sz ~= 1, 1);
end
if isempty(dim), dim = 1; end
rsz = ones(1,ndims(x));
rsz(dim) = sz(dim);

% find nans
idx_nan = isnan(x);
x(idx_nan) = 0;
% number of non-NaNs
n = sum(~idx_nan,dim);
idx_allnan = n==0;
n(idx_allnan) = NaN;
% mean
mu = sum(x,dim)./n;
mu = repmat(mu,rsz);
% deviation from mean
dev = abs(x-mu);
dev(isnan(dev)) = 0;

% variance = (x-mu).^2 ./ n-1
y = sum((dev.^2),dim) ./ (n-abs(flag-1));