function out = subset(x,n)

% some input is needed
if nargin < 1 || isempty(x)
    out = [];   return;
end

% only vectors can be divided into subsets
if ~isvector(x)
    warning('PUBLIC:subset','Only vectors can be divided into subsets.');
    out = [];   return;
end

% set default subset size
if nargin < 2
    n = min(length(x),2);
end

% x must have at least n elements
if length(x) < n
    out = [];   return;
end

% set x on the first dimension
x = x(:);

% return quickly if possible
if n == 1
    out = x;    return;
elseif length(x) == n
    out = x';   return;
end

% substitute x with indeces
i = (1:length(x))';

% use arraycomb to find all cross-combinations of x
A = num2cell(repmat(i,1,n),1);
A = arraycomb(A{:});
A = A(:,size(A,2):-1:1);

% remove replications in the combinations
idx = true(size(A,1),1);
for j = 2:n
    idx = idx & A(:,j-1) < min(A(:,j:end),[],2);
end
A = A(idx,:);

% substitute the indeces with the values from x
out = x(A);
