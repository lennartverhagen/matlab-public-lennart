function y = istrue(x,method)
% ISTRUE ensures that a true/false input argument like "yes", "true"
% or "on" is converted into a boolean
%
% Lennart Verhagen, based on istrue.m from the FieldTrip package
% Copyright (C) 2009, Robert Oostenveld

if nargin < 2,	method = 'strict';	end

true_list  = {'yes' 'true' 'on' 'y' 'always' 'all' 'everything' 'yeah' 'yo'};
false_list = {'no' 'false' 'off' 'n' 'none' 'never' 'nope' 'noppes' 'nothing' 'nada'};

if isempty(x)
    y = false;
elseif ischar(x)
    % convert string to boolean value
    if any(strcmpi(strtrim(x), true_list))
        y = true;
    elseif any(strcmpi(strtrim(x), false_list))
        y = false;
    else
        y = false;
        give_output(x,method)
    end
elseif isstruct(x)
    y = false;
    give_output(x,method)
else
    % convert numerical value to boolean
    y = logical(x);
end


function give_output(x,method)
if strcmpi(method,'strict')
    error('cannot determine whether "%s" should be interpreted as true or false', x);
elseif strcmpi(method,'loose')
    warning('Lennart:NotSupported','cannot determine whether "%s" should be interpreted as true or false', x);
end