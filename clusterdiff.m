function cl = clusterdiff(data,th)

% check input
if nargin < 1,      error('please provide a data vector');  end
if nargin < 2,      error('please difference threshold');   end
if ~isvector(data), error('the data must be a vector');     end
if isempty(data),   cl = []; return;                        end

% get the vector in horizontal shape
data = data(:)';

% sort data
[data,idx] = sort(data);

% get difference
d = diff(data)>th;

% get cluster on- and off-sets
con = find([1 d]);
coff = find([d 1]);

% assign clusters
n = length(con);
cl = nan(size(data));
for c = 1:n
    cl(idx(con(c):coff(c))) = c;
end

% % sort data into clusters
% n = length(con);
% cldat = cell(1,n);
% clidx = cell(1,n);
% for c = 1:n
%     clidx{c} = idx(con(c):coff(c));
%     cldat{c} = data(clidx{c});
% end
% 
% % sort output
% if nargout == 1
%     varargout = {cldat};
% elseif nargout > 1
%     varargout = {cldat,clidx};
% end