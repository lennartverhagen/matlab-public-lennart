function idx = logic2idx(logic_array)
%--------------------------------------------------------------------------
% idx = LOGIC2IDX(logic_array)
%
% This file is used by the EEG-TMS, FieldTripWrapper and KineMagic
% toolboxes
% Copyright (C) 2010, Lennart Verhagen
% L.Verhagen@donders.ru.nl
% version 2010-01-01
%--------------------------------------------------------------------------

% check array size
if numel(logic_array) ~= length(logic_array)
    error('Unsupported logic array size. Size should be nx1 or 1xn.')
end

% transpose if needed
if size(logic_array,1) > size(logic_array,2)
    logic_array = logic_array';
end
    
% find on and offsets
idx_on = find(diff([false logic_array]) > 0);
idx_off = find(diff([logic_array false]) < 0);

% store in output
idx = [idx_on' idx_off'];