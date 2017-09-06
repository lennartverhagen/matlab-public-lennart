function X = getbarx(varargin)
%--------------------------------------------------------------------------
% GETBARX gives you the x positions of the patch objects of a bar plot.
% Output X has the same structure as the input data Y in BAR(Y).
%
% These x positions are at the centre of the patch objects, making them
% especially useful if you want to add errorbars to your bar plot.
%
% In it's infinite wisdom Mathworks has decided to obscure the x-positions
% of the centres of vertical bars, created using BAR. Here is a dirty
% workaround.
%
% Damn, inputting a handle no longer works with MATLAB2014b. Sorry.
%
% Copyright (C) 2010, Lennart Verhagen
% L.Verhagen@donders.ru.nl
% version 2014-11-01
%--------------------------------------------------------------------------

% if input is a handle
if ishandle(varargin{1})
    h = varargin{1};
    Y = get(h,'Ydata');
    if iscell(Y), Y = cell2mat(Y); end
    Y = Y';
    
    % check matlab version
    if ~verLessThan('matlab', '8.4')
        X = bsxfun(@plus,vertcat(h.XData),vertcat(h.XOffset))';
    else
        % loop over bars
        X = nan(size(Y));
        for i = 1:length(h)
            % get x-positions from plot
            x = get(get(h(i),'Children'),'Xdata');
            X(:,i) = mean(x([1 3],:))';
        end
        
    end
    
    % ensure X is horizontal if a single dataset is provided
    if numel(X) == length(X), X = X(:)'; end
    
    % done!
    return
    
    % if you insist on calculating the x positions from scratch
    % X = get(h(1),'Xdata')';
    
% if only Y as input
elseif length(varargin) == 1
    Y = varargin{1};
    X = (1:size(Y,1))';
    
% both X and Y as input
else
    [X,Y] = varargin{1:2};
end

% do the calculations
step = min(diff(X));
ngroup = size(Y,1);
nbar = size(Y,2);
groupwidth = step*min(0.8, nbar/(nbar+1.5));
A = X - groupwidth/2;
B = (2*(1:nbar)-1) * groupwidth / (2*nbar);
X = repmat(A,1,nbar) + repmat(B,ngroup,1);
