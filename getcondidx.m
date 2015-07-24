function idxc = getcondidx(bcond,idxc)
%--------------------------------------------------------------------------
% get trial indeces for the requested basis conditions
%
% See also FTW_GETBASISCOND, FTW_GETIDX, FTW_PLOT
%
% This file was developed as part of the FieldTripWrapper toolbox
% Copyright (C) 2010, Lennart Verhagen
% L.Verhagen@donders.ru.nl
% version 2010-02-01
%--------------------------------------------------------------------------

% loop over conditions
for c = 1:length(bcond)
    
    % only for combined basis conditions new indeces need to be obtained
    if strcmpi(bcond(c).type,'comb') && ~isfield(idxc,bcond(c).name)
        % get parts
        A = bcond(c).parts;
        idx_empty = strcmpi(A,'');
        A = strcat('idxc.',A);
        A(idx_empty) = {''};
        % get operators
        B = bcond(c).ops;
        % combine
        comb = [A; [B {''}]];
        % calculate and store new idxc
        idxc.(bcond(c).name) = eval([comb{:}]);
    end
    
end