function varargout = getaxrange(varargin)
%--------------------------------------------------------------------------
% GETAXRANGE determines a slightly more optimal range for an axis than
% matlab automatically does.
%
% Copyright (C) 2010, Lennart Verhagen
% L.Verhagen@donders.ru.nl
% version 2010-02-01
%--------------------------------------------------------------------------

% sort input
idx_str = find(cellfun(@ischar,varargin),1,'first');
idx_dat = find(~cellfun(@ischar,varargin));
if isempty(idx_str)
    flg = 'auto';
else
    flg = varargin{idx_str};
end
if isempty(idx_dat)
    error('no data input given');
elseif length(idx_dat) == 1
    y = varargin{idx_dat}(:);
    if iscell(y),   y = [y{:}];     y = y(:);       end
else
    dat = varargin{idx_dat(1)}(:);
    err = varargin{idx_dat(2)}(:);
    % get values out of cells
    if iscell(dat), dat = [dat{:}]; dat = dat(:);   end
    if iscell(err), err = [err{:}]; err = err(:);   end
    % replace NaN values of err with zeros
    err(isnan(err)) = 0;
    y = [dat-err;dat+err];
end

% possible tick steps (repeated on a log10 base)
%step = [0.5 1 2 5 10];

% determine data descriptives
medy = nanmedian(y(:));
maxy = max(y(:));
miny = min(y(:));
dy = maxy-miny;

% find step order for medy and dy
n_medy = invstepfun(abs(medy))-5;
n_dy = invstepfun(dy/2);

% determine order based on flg
if strcmpi(flg,'tight')
    n = n_dy;
else
    n = max([n_medy n_dy]);
end

% determine the limits
st = stepfun(n);
maxylim = ceil((maxy+st/5)/st)*st;
minylim = floor((miny-st/5)/st)*st;
dlim = maxylim - minylim;

% check if the order is low enough
while dlim < stepfun(n)*1.2
    % lower the order
    n = n - 1;
    st = stepfun(n);
    
    % make sure the new step fits in the range
    if rem(dlim,st) > 10e-6
        tmpmaxylim = floor(maxylim/st)*st;
        if tmpmaxylim > maxy+st/5
            maxylim = tmpmaxylim;
        else
            minylim = floor((minylim-st/5)/st)*st;
        end
        dlim = maxylim - minylim;
    end
end
    
% arrange the output
axlim = [minylim maxylim];
axrange = minylim:st:maxylim;
if nargout == 1
    varargout = {axrange};
elseif nargout == 2
    varargout = {axlim,st};
elseif nargout == 3
    varargout = {minylim,maxylim,st};
else
    varargout = {minylim,maxylim,st,flg};
end
%--------------------------------------------------------------------------



%% function stepfun
%----------------------------------------
function y = stepfun(x)
%x = [ -2  -1   0 1 2 3  4  5  6   7   8   9   10];
%y = [0.1 0.2 0.5 1 2 5 10 20 50 100 200 500 1000];

y = exp((x-1).*log(10)./3);
sc = 10.^floor(log10(y));
y = round(y./sc) .* sc;


%% function invstepfun
%----------------------------------------
function x = invstepfun(y)
%y = [0.1 0.2 0.5 1 2 5 10 20 50 100 200 500 1000];
%x = [ -2  -1   0 1 2 3  4  5  6   7   8   9   10];

x = 3.*log(y)./log(10) + 1;
x = round(x);

%--------------------------------------------------------------------------
