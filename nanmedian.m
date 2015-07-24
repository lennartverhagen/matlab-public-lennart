function y = nanmedian(x, dim)
%NANMEDIAN   median value, ignoring NaN values.
%
%   NANMEDIAN(X) and NANMEDIAN(X,DIM) behave as MEDIAN(X) and MEDIAN(X,DIM). Please
%   see below for the manual of MEDIAN:
%
%   For vectors, MEDIAN(a) is the median value of the elements in a.
%   For matrices, MEDIAN(A) is a row vector containing the median
%   value of each column.  For N-D arrays, MEDIAN(A) is the median
%   value of the elements along the first non-singleton dimension
%   of A.
%
%   MEDIAN(A,DIM) takes the median along the dimension DIM of A.
%
%   Example: If A = [1 2 4 4; 3 4 6 6; 5 6 8 8; 5 6 8 8];
%
%   then median(A) is [4 5 7 7] and median(A,2) 
%   is [3 5 7 7].'
%
%   Class support for input A:
%      float: double, single
%
%   See also NANMEAN, NANVAR, NANSTD, NANSEM.

%   Copyright 1984-2009 The MathWorks, Inc.
%   $Revision: 5.15.4.7 $  $Date: 2009/09/03 05:19:03 $

%   Calculation method for even lists: b - (b-a)/2.
%   This method reduces the likelihood of rounding errors.


if ~any(isnan(x(:)))
    % use median if no NaNs are present
    y = median(x);

elseif isvector(x)
    % if x is a vector, you can simple leave out the NaNs
    y = median(x(~isnan(x)));

else
    % otherwise x is a matrix and the NaNs might occur at different places
    % over the search dimension dim.
    try
        % First try to use the statistics toolbox.
        if nargin == 1
            y = prctile(x, 50);
        else
            y = prctile(x, 50,dim);
        end
    catch
        % then go for an unstable approach where you hope you have more
        % real values than NaNs and run the median function twice
        warning('PUBLIC:nanmedian:Unstable','Unstable use of nanmedian due to lack of programming skills and statistics toolbox.');
        idx_nan = isnan(x);
        nnans = ceil(sum(idx_nan(:))/2);
        filler = [inf(1,nnans); -inf(1,nnans)];
        xa = x; xb = x;
        xa(idx_nan) = filler(:);
        xb(idx_nan) = -filler(:);
        if nargin == 1
            ya = median(xa);
            yb = median(xb);
        else
            ya = median(xa,dim);
            yb = median(xb,dim);
        end
        y = (ya+yb)./2;
    end
end