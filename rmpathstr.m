function pathstr = rmpathstr(pathstr,rmstr)
%--------------------------------------------------------------------------
% removes folders from path that match a string
%
% Input
%   pathstr       string describing a folder or list of folders to add
%                 (e.g. generated using genpath or path)
%   rmstr         if this string is found in the folder paths of pathstr
%                 then these folders are removed from pathstr
%
% Output
%   pathstr       the cleaned up version of pathstr after removal
%
%
% version history
% 2015-10-01    Lennart created
%
% Lennart Verhagen
% University of Oxford, 2015-10-01
%--------------------------------------------------------------------------

% split the path string at colons into folders
pp = regexp(pathstr,':','split');

% remove all folders with a match of rmstr
pp = pp(cellfun(@isempty,regexp(pp,rmstr)));

% remove all empty folder strings
pp = pp(~cellfun(@isempty,pp));

% append the colons and concatenate again
pp = cellfun(@(x) [x ':'],pp,'UniformOutput',false);
pathstr = [pp{:}];