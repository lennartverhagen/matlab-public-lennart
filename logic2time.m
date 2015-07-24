function time_onoff = logic2time(logic_array,time_array)
%--------------------------------------------------------------------------
% time_onoff = LOGIC2TIME(logic_array,time_array)
%
% This file is used by the EEG-TMS, FieldTripWrapper and KineMagic
% toolboxes
% Copyright (C) 2010, Lennart Verhagen
% L.Verhagen@donders.ru.nl
% version 2010-01-01
%--------------------------------------------------------------------------

% transpose indeces if arranged in the second dimension
if size(logic_array,1) > size(logic_array,2)
    logic_array = logic_array';
end
if size(time_array,1) > size(time_array,2)
    time_array = time_array';
end

% determine on and offsets
idx_on = diff([0 logic_array])>0;
idx_off = diff([logic_array 0])<0;

% go from the sample to the time domain
time_on = time_array(idx_on);
time_off = time_array(idx_off);

% store in one variable
time_onoff = [time_on' time_off'];