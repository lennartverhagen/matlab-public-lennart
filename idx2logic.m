function logic_array = idx2logic(idx,nsamp)
%--------------------------------------------------------------------------
% logic_array = IDX2LOGIC(idx,nsamp)
%
% This file is used by the EEG-TMS, FieldTripWrapper and KineMagic
% toolboxes
% Copyright (C) 2010, Lennart Verhagen
% L.Verhagen@donders.ru.nl
% version 2010-01-01
%--------------------------------------------------------------------------

% transpose indeces if arranged in the second dimension
if size(idx,2) > 2
    idx = idx';
end

% if nsamp is an (time-)array, get the number of samples
if length(nsamp) > 1,   nsamp = length(nsamp);  end

% restrict indeces to nsamp
if size(idx,2) == 1
    idx = idx(idx<=nsamp);
elseif size(idx,2) == 2
    idx(idx(:,2)>nsamp,2) = nsamp;
end

logic_array = false(1,nsamp);
if isempty(idx)
    return
elseif size(idx,2) == 1
    logic_array(idx) = true;
elseif size(idx,2) == 2
    for i = 1:size(idx,1)
        logic_array(idx(i,1):idx(i,2)) = true;
    end
else
    error('Unsupported indeces matrix size. Size should be nx1 or nx2.')
end