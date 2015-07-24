function y = mc(x,dist)
% MC is a basic function that mean corrects and normalizes an input value.
% It assumes that the value x comes from a [0 1] distribution, unless
% otherwise specified. So mc(1) gives 1, and mc(0) gives -1. But mc(1,[0 2])
% gives 0, and mc(0,[0 2]) gives -1.
%
% FORMAT:   
%   full    - y = mc(x,dist);
%   minimal - mc(x);
%
% INPUT:
%   x       - integer or boolean 
%               example: x = 0;
%   dist    - distribution minimum and maximum
%               example: dist = [0 1];
%
% OUTPUT:
%   y      - mean corrected normalized value between -1 and 1
%
% created by Lennart Verhagen, jun-2009
% L.Verhagen@donders.ru.nl
% version 2009-06-09
%--------------------------------------------------------------------------

if nargin < 2
    dist = [0 1];
elseif numel(dist)>2
    warning('LENVER:meancorrect','The distribution minimum-maximum range may only contain 2 values, taking min and max.');
    dist = [min(dist) max(dist)];
end
    
avg = sum(dist)/2;
dev = (max(dist)-min(dist))/2;

y = (x-avg)/dev;