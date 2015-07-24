function time_points = idx2time(idx,time_array)
%--------------------------------------------------------------------------
% time_points = IDX2TIME(idx,time_array)
%
% See also TIME2IDX, IDX2LOGIC, LOGIC2IDX, TIME2LOGIC
%
% This file is used by the EEG-TMS, FieldTripWrapper and KineMagic
% toolboxes
% Copyright (C) 2010, Lennart Verhagen
% L.Verhagen@donders.ru.nl
% version 2010-01-01
%--------------------------------------------------------------------------

% transpose indeces if arranged in the second dimension
dims = size(idx);
if length(dims)==2 && dims(1) == 2 && dims(2) > 2
    idx = idx';
end

% allow NaNs
idx_nan = isnan(idx);
idx(idx_nan) = 1;

% find time points
if isempty(time_array)
    time_points = nan(size(idx));
else
    time_points = time_array(idx);
    time_points(idx_nan) = NaN;
end