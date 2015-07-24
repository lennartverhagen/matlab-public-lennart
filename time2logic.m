function [logic_array, logic_array_indiv] = time2logic(time_points,time_array)
%--------------------------------------------------------------------------
% [logic_array, logic_array_indiv] = TIME2LOGIC(time_points,time_array)
%
% This file is used by the EEG-TMS, FieldTripWrapper and KineMagic
% toolboxes
% Copyright (C) 2010, Lennart Verhagen
% L.Verhagen@donders.ru.nl
% version 2010-01-01
%--------------------------------------------------------------------------

% transpose time_points if arranged in the second dimension
if size(time_points,1) < size(time_points,2) && size(time_points,2) ~= 2
    time_points = time_points';
end

% initialize logic array
logic_array = false(size(time_array));
if nargout > 1
    logic_array_indiv = repmat(logic_array,size(time_points,1),1);
end

if isempty(time_points)
    return
elseif size(time_points,2) == 1
    for t = 1:size(time_points,1)
        if ~isnan(time_points(t))
            idx_on = nearest(time_array,time_points(t));
            logic_array(idx_on) = true;
            if nargout > 1
                logic_array_indiv(t,idx_on) = true;
            end
        end
    end
elseif size(time_points,2) == 2
    for t = 1:size(time_points,1)
        if all(~isnan(time_points(t,:)))
            idx_on = nearest(time_array,time_points(t,1));
            idx_off = nearest(time_array,time_points(t,2));
            logic_array(idx_on:idx_off) = true;
            if nargout > 1
                logic_array_indiv(t,idx_on:idx_off) = true;
            end
        end
    end
else
    error('Unsupported time_point array size. Size should be nx1 or nx2.')
end