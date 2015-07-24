function val = fetchfield(S,varargin)
%--------------------------------------------------------------------------
% FETCHFIELD returns a field from a structure just like the standard
% Matlab GETFIELD function, except that you can also specify nested fields.
% If the target field is not present in the deepest nested field, than the
% function goes up one level in the branch and looks again. This is done
% iteratively until the target field is found or the root of the structure
% is reached. You can specify nested fields using a '.' in the fieldname,
% or as seperate variables in the function input. The nesting can be
% arbitrary deep.
%
% Use as
%   f = fetchfield(s, 'targetfieldname')
% or as
%   f = fetchfield(s, 'fieldname.targetfieldname')
% or as
%   f = fetchfield(s, 'fieldname', 'targetfieldname')
%
% See also GETFIELD, GETSUBFIELD
%
% Copyright (C) 2010, Lennart Verhagen
% L.Verhagen@donders.ru.nl
% version 2010-02-01
%--------------------------------------------------------------------------

% split
if length(varargin) == 1
    varargin = regexp(varargin{1},'\.','split');
end
flds = varargin(1:end-1);   % field(s) of structure
target = varargin{end};     % subfield that needs to be retrieved

% loop over fields iteratively, start from the deepest nested field and
% continue stepping up to the level where the target field is present
while ~isempty(flds)
    try
        % test if the goal subfield is present
        getfield(S,flds{:},target);
        break
    catch
        % remove the deepest nested field, i.e. move up one level
        flds = flds(1:end-1);
    end
end

% get the value of the target field
val = getfield(S,flds{:},target);