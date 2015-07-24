function subdir = getsubjsubdir(cfg,s,opt,defsubdir)
%--------------------------------------------------------------------------
% get subject specific sub directory
%
% Copyright (C) 2011, Lennart Verhagen
% L.Verhagen@donders.ru.nl
% version 2011-12-01
%--------------------------------------------------------------------------

% set defaults
if nargin < 4
    [ST,~] = dbstack(1);
    if ~isempty(regexp(ST(1).name,'^km_','once'))
        defsubdir = fullfile('kinematics',opt);
    else
        defsubdir = opt;
    end
end

% check subject input
if ischar(s)
    subj = s;
elseif isempty(s) || ~(s>0) || isinf(s)
    subj = 'Group';
else
    subj = cfg.subj{s};
end

% check for known options
if ~ismember(opt,{'proc','ana','report'})
    warning('KM:get_subjsubdir:UnknownSubDirOption','This sub-directory option [%s] is not recognized, but we are going to try to implement it anyways.',opt);
end

if ~isfield(cfg.dir,opt) || isempty(cfg.dir.(opt))
    subdir = fullfile(cfg.dir.root,subj,defsubdir);
elseif ~isempty(regexp(cfg.dir.(opt),['^' regexptranslate('escape',cfg.dir.root)],'once'))
    subdir = cfg.dir.(opt);
elseif isempty(fileparts(cfg.dir.(opt))) || ~exist(cfg.dir.(opt),'dir')
    subdir = fullfile(cfg.dir.root,subj,cfg.dir.(opt));
else
    subdir = cfg.dir.(opt);
end