function cond = parsecondstr(str,mode,str_orig)
%--------------------------------------------------------------------------
% parse the condition string
%
% See also FTW_PLOT
%
% This file was developed as part of the FieldTripWrapper toolbox
% Copyright (C) 2010, Lennart Verhagen
% L.Verhagen@donders.ru.nl
% version 2010-02-01
%--------------------------------------------------------------------------

% make str a cell structure
if iscell(str)
    tstr = str;
else
    tstr = {str};
end

% initiate cond structure
cond = struct(...
    'name',{},...
    'type',{},...
    'iscontr',{},...
    'names',{},...
    'ops',{},...
    'parts',{}...
    );

% loop over strings if str is a cell structure
for c = 1:length(tstr)
    
    % get string
    str = tstr{c};
    
    % continue if input str is already in the right format
    if ~ischar(str)
        if isstruct(str)
            cond = str;
            return
        else
            error('FTW:ParseCondstr','input ''str'' must be a character array');
        end
    end
    
    % set defaults
    if nargin < 3,  str_orig = str; end
    if nargin < 2,  mode = 'none';  end
    
    % correct condition naming conventions
    str = regexprep(str, '[', '(');     % replace square brackets by parentheses
    str = regexprep(str, ']', ')');     % replace square brackets by parentheses
    str = regexprep(str, '_', '&');     % replace underscore by logical AND (&)
    str = regexprep(str, '\&{2}', '&');	% replace double && by logical AND (&)
    str = regexprep(str, '\|{2}', '|');	% replace double || by logical OR (|)
    
    % remove unneccessary parentheses
    if isequal(regexp(str,'[()]'),[1 length(str)])
        str = str(2:end-1);
    end
    
    %% determine type of condition
    % empty, main effect, differential contrast, logical combination
    %----------------------------------------
    cond(c).iscontr    = false;
    % empty
    if isempty(str)
        cond(c).type	= 'empty';
        
        % contrast
    elseif ~isempty(regexp(str,'[+-]+|<|>','once'))
        if strcmpi(mode,'comb')
            error('Condition %s could not be correctly parsed. You requested to combine a contrast, that is not possible. A combination can be contrasted, however.',str_orig);
        elseif strcmpi(mode,'comb')
            error('Condition %s could not be correctly parsed. An erroneously subnested contrast was attempted to be parsed, but a contrast should be calculated in one go. Use parentheses to nest separate contrasts.',str_orig);
        end
        cond(c).type    = 'contrast';
        cond(c).iscontr = true;
        cond(c).name	= str;
        % find characters to parse the string
        tnames          = regexp(str,'[()|+-]|<|>','split');
        tops            = regexp(str,'[()|+-]|<|>','match');
        % re-combine combination-parts
        while ~isempty(regexp([tops{:}],'\(\)','once'))
            i       = regexp([tops{:}],'\(\)','once');
            tmp     = [tnames(i:i+2); tops(i:i+1) {''}];
            tmp     = {[tmp{:}]};
            tnames  = [tnames(1:i-1) tmp tnames(i+3:end)];
            tops    = [tops(1:i-1) tops(i+2:end)];
        end
        % store the correct names and operators
        cond(c).names	= tnames;
        cond(c).ops     = tops;
        for p = 1:length(cond(c).names)
            cond(c).parts(p) = ftw_parsecondstr(cond(c).names{p},'contrast',str);
        end
        
        % combination
    elseif ~isempty(regexp(str,'[&|]+','once'))
        if strcmpi(mode,'comb')
            error('Condition %s could not be correctly parsed. An erroneously subnested combination was attempted to be parsed, but a combination should be created in one go. Use parentheses to nest separate combinations.',str_orig);
        end
        cond(c).type	= 'comb';
        cond(c).name	= str;
        cond(c).names	= regexp(str,'[()\&\|]','split');
        cond(c).ops     = regexp(str,'[()\&\|]','match');
        for p = 1:length(cond(c).names)
            cond(c).parts(p) = ftw_parsecondstr(cond(c).names{p},'comb',str);
        end
        
        % error
    elseif isempty(regexp(str,'\w', 'once'))
        error('Condition %s could not be correctly parsed. Did you perhaps use illegal characters or unnecessary parentheses?',str);
        
        % main effect
    else
        cond(c).type = 'main';
        cond(c).name = str;
    end
    
end