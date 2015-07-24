function name = dimname(dims,dim)

% convert dims to a cell array of dimension names if isn't already
if ~iscell(dims)
    dims = regexpi(dims,'_','split');
end

% select dimension name
name = dims{dim};