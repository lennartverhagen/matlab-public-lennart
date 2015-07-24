function y = isfalse(x,method)
% ISFALSE ensures that an input argument like "no", "none" or "off" is
% converted into a boolean

% Lennart Verhagen, based on istrue.m from the FieldTrip package
% Copyright (C) 2009, Robert Oostenveld

if nargin < 2,	method = 'free';	end

false_list = {'no' 'false' 'off' 'n' 'none' 'never' 'nope' 'noppes' 'nothing' 'nada'};

y = false;
if isempty(x)
    y = true;
elseif ischar(x)
    % convert string to boolean value
    if any(strcmpi(strtrim(x), false_list))
        y = true;
    end
elseif ~isstruct(x) && ~iscell(x) && ~isa(x,'function_handle') && length(x)==1
    % convert numerical value to boolean
    y = ~logical(x);
else
    if strcmpi(method,'strict')
        error('cannot determine whether "%s" should be interpreted as false', x);
    elseif strcmpi(method,'loose')
        warning('KM:NotSupported','cannot determine whether "%s" should be interpreted as false', x);
    end
end

