function y = abslog(x)
% ABSLOG gives the signed natural logarithm of the absolute values of x.
% So, ngative values of x give a negative natural logarithm of the absolute
% values.

% indeces where x is negative
idx_neg = x < 0;

% make x positive
xabs = abs(x);

% natural logarithm
y = log(xabs);

% make y negative where x was
y(idx_neg) = -y(idx_neg);

% disregard infinite values
y(~isfinite(y)) = NaN;