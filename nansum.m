function y = nansum(x,dim)

% Find NaNs and set them to zero. 
x(isnan(x)) = 0;

% Then sum up non-NaNs.
if nargin == 1 % let sum figure out which dimension to work along
    y = sum(x);
else           % work along the explicitly given dimension
    y = sum(x,dim);
end