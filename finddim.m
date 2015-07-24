function idx = finddim(dims,dim)

% convert dims to a cell array of dimension names if isn't already
if ~iscell(dims)
    dims = regexpi(dims,'_','split');
end

% convert dim to a cell array if the character array contains multiple
% items
if ~iscell(dim) && ~isempty(regexp(dim,'_','once'))
    dim = regexpi(dim,'_','split');
end

% find the indeces of dim in dims
if ~iscell(dim)
    idx = find(strcmpi(dims,dim));
else
    [~, idx] = ismember(dims,dim);
end