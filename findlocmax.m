function varargout = findlocmax(data,flg)

% check input
if ~isvector(data), error('the data must be a vector'); end
if nargin < 2,      flg = 'peak';                       end
data = data(:)';

% get difference vector
switch lower(flg)
    case 'onset'
        d = [0 diff(data)>0];
        ds = [diff(data)<=0 0];
    case 'peak'
        d = [0 diff(data)>0];
        ds = [diff(data)<0 0];
    case 'offset'
        d = [diff(data)<0 0];
        ds = [0 diff(data)>=0];
end

% combine criteria
idx = d & ds;
pks = data(idx);

% sort output
if nargout == 1
    varargout = {pks};
elseif nargout > 1
    varargout = {pks,find(idx)};
end