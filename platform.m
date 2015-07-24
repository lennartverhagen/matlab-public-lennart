function plat = platform
%--------------------------------------------------------------------------
% PLATFORM checks on what kind of platform you are currently working: a
% 32-bit or a 64-bit machine.
%
% FORMAT:         platform;
% OUTPUT:  plat - An integer. Gives '32' for 32-bit platforms and '64' for
%                 64-bit platforms.
%
% created by Lennart Verhagen, may-2008
% L.Verhagen@fcdonders.ru.nl
% version 2008-05-06
%--------------------------------------------------------------------------

comp = computer;
if strcmp(comp(end-1:end),'64')
    plat = 64;
else
    plat = 32;
end

% % Example code
% if platform ~=64
%     error('LENVER:checkplatform',...
%         ['You appear to be trying to run an SPM5 version\n'...
%         'compiled for a 64-bit platform on a 32-bit machine.\n'...
%         'Please, use another computer or an older version of SPM5.']);
% end