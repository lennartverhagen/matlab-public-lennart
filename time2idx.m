function idx = time2idx(time_points,time_array)
%--------------------------------------------------------------------------
% idx = TIME2IDX(time_points,time_array)
%
% This file is used by the EEG-TMS, FieldTripWrapper and KineMagic
% toolboxes
% Copyright (C) 2010, Lennart Verhagen
% L.Verhagen@donders.ru.nl
% version 2010-01-01
%--------------------------------------------------------------------------

% transpose time_points if arranged in the second dimension
dims = size(time_points);
if length(dims)==2 && dims(1) == 2 && dims(2) > 2
    time_points = time_points'; dims = size(time_points);
end

% find index of nearest time point
if isempty(time_points)
    idx = nan(dims);
else
    idx = nearest(time_array,time_points);
end