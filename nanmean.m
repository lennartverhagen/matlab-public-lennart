function y = nanmean(x, dim)
%MEAN   Average or mean value, ignoring NaN values.
%
%   NANMEAN(X) and NANMEAN(X,DIM) behave as MEAN(X) and MEAN(X,DIM). Please
%   see below for the manual of MEAN:
%
%   For vectors, MEAN(X) is the mean value of the elements in X. For
%   matrices, MEAN(X) is a row vector containing the mean value of
%   each column.  For N-D arrays, MEAN(X) is the mean value of the
%   elements along the first non-singleton dimension of X.
%
%   MEAN(X,DIM) takes the mean along the dimension DIM of X. 
%
%   Example: If X = [1 2 3; 3 3 6; 4 6 8; 4 7 7];
%
%   then mean(X,1) is [3.0000 4.5000 6.0000] and 
%   mean(X,2) is [2.0000 4.0000 6.0000 6.0000].'
%
%   Class support for input X:
%      float: double, single
%
%   See also NANMEDIAN, NANVAR, NANSTD, NANSEM.

if nargin < 2
    dim = find(size(x)>1,1,'first');
end
idx = isnan(x);
x(idx) = 0;
n = sum(~idx,dim);
n(n==0) = NaN;
y = sum(x, dim) ./ n;

