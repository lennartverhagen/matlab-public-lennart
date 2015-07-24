function p = homepath
%--------------------------------------------------------------------------
% Return the path of the home folder of the current user
%
% Lennart Verhagen
% University of Oxford, 2015-02-01
%--------------------------------------------------------------------------

try
    % try to get the home path from an environment variable
    if ispc,	p = getenv('USERPROFILE');
    else        p = getenv('HOME');
    end
catch
    % defunct to using a tilde, which probably won't work on Windows, but
    % at least the intention is clear
    p = '~';
end