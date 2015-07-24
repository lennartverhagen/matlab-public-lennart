function varargout = getbasiscond(cond,bcond,i)
%--------------------------------------------------------------------------
% get names requested conditions and their parts
%
% See also FTW_GETCONDIDX, FTW_GETIDX, FTW_PLOT
%
% This file was developed as part of the FieldTripWrapper toolbox
% Copyright (C) 2010, Lennart Verhagen
% L.Verhagen@donders.ru.nl
% version 2010-02-01
%--------------------------------------------------------------------------

% initialize counter
if nargin < 3,  i = 1;          end

% initialize variable
if nargin < 2
    bcond = struct('name',[],'type',[]);
end

% loop over conditions
for c = 1:length(cond)
    
    % continue if basis condition already exists
    if isempty(cond(c).name) || ...
        ~isempty(bcond(1).name) && ismember(spellout(cond(c).name),{bcond.name})
        continue
    end
    
    switch lower(cond(c).type)
        case 'main'
            bcond(i).name   = cond(c).name;
            bcond(i).type   = cond(c).type;
            i = i + 1;
        case 'comb'
            bcond(i).name	= spellout(cond(c).name);
            bcond(i).type	= cond(c).type;
            bcond(i).parts	= cond(c).names;
            bcond(i).ops	= cond(c).ops;
            i = i + 1;
        case 'contrast'
            [bcond i] = ftw_getbasiscond(cond(c).parts,bcond,i);
        case 'empty'
            % do nothing
        otherwise
            error('what are you doing here? go home, get some sleep')
    end
end

% sort output
varargout = {bcond,i};