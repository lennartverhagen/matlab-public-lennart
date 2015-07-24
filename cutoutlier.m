function [idx,idx_ignore,cut] = cutoutlier(dat,nr,rangeflg,tailflg,initcut,idx_ignore)
%--------------------------------------------------------------------------
% [idx,idx_ignore,cut] = CUTOUTLIER(dat,nr,rangeflg,tailflg,initcut,idx_ignore)
% CUTOUTLIER identifies outliers using either cut-offs, or the mean +/- n *
% standard deviation range (STD), or the 1-3 quartile +/- n * inter-
% quartile range IQR). The latter two methods can be combined with prior
% cut-offs and a list of indeces to ignore. The default range measure is
% the 3*IQR (normal dist: 2.698*STD). When selecting STD as a range
% measure, the default number of STDs is 4. Both these settings are
% conservative. 1.5*IQR (normal dist: 4.7215*STD) and 3*STD are more
% liberal and canonical settings.
%
% Copyright (C) 2010, Lennart Verhagen
% L.Verhagen@donders.ru.nl
% version 2010-02-01
%--------------------------------------------------------------------------

% sort input
if nargin < 1
    error('LV:CutOutlier','no data supplied');
end
if nargin < 3 || isempty(rangeflg)
    rangeflg = 'iqr';
end
if nargin < 2 || isempty(nr)
    if strcmpi(rangeflg,'iqr')
        nr = 3;
    elseif strcmpi(rangeflg,'std')
        nr = 4;
    end
end
if ~any(strcmpi(rangeflg,{'iqr','std'}))
    nr = NaN;
end
if nargin < 4 || isempty(tailflg)
    tailflg = 'both';
end
if nargin < 5 || isempty(initcut)
    if any(strcmpi(tailflg,{'higher','abs','abshigher'}))
        initcut = Inf;
    elseif any(strcmpi(tailflg,{'lower','abslower'}))
        initcut = -Inf;
    elseif any(strcmpi(tailflg,{'both'}))
        initcut = [-Inf Inf];
    end
end
if nargin < 6 || isempty(idx_ignore)
    idx_ignore = zeros(size(dat));
end

% check dimensions of dat
if ~ismatrix(dat)
    error('cutoutlier can only handle 1xN, Nx1 or NxM matrices');
end

% number of sensors and repetitions
[nsens nrep] = size(dat);
transposeflg = false;

% transpose the matrix if only one repetition is present
if nsens > 1 && nrep == 1
    transposeflg = true;
    dat = dat';
    idx_ignore = idx_ignore';
    [nsens nrep] = size(dat);
end
if nsens > nrep
    warning('PUBLIC:CutOulier','the number of sensors [%d] is larger than the number of repetitions [%d]',nsens,nrep);
end

% indeces of trials to ignore in standard deviation calculation
if size(idx_ignore,1) ~= nsens && size(idx_ignore,1) == 1
    idx_ignore = repmat(idx_ignore,nsens,1);
end

% select cases with metric outside the basic cutoff
if numel(initcut) == 1
    if strcmpi(tailflg,'higher')
        idx = dat > initcut;
    elseif strcmpi(tailflg,'lower')
        idx = dat < initcut;
    elseif any(strcmpi(tailflg,{'abs','abshigher'}))
        idx = abs(dat) > initcut;
    elseif strcmpi(tailflg,'abslower')
        idx = abs(dat) < initcut;
    elseif strcmpi(tailflg,'both')
        error('when outliers are requested to be identified at both extremes, the initial cutoff threshold must contain two values, not one.');
    end
elseif strcmpi(tailflg,'abs')
    idx = abs(dat) < min(initcut) | abs(dat) > max(initcut);
else
    idx = dat < min(initcut) | dat > max(initcut);
end

% add those to the ignore list 
idx_ignore = idx_ignore | idx;

% select trials with metric more extreme than nxrange while ignoring trials
% which do not survive the initial cutoff
if strcmpi(tailflg,'both')
    cut = nan(nsens,2);
else
    cut = nan(nsens,1);
end

% if no range cut-off is requested, skip the next part
if isnan(nr),nsens = 0; end

% loop over sensors
for c = 1:nsens
    tmp = dat(c,~idx_ignore(c,:));
    
    % inter-quartile range cut off
    if strcmpi(rangeflg,'iqr')
        
        a = prctile(tmp,[25 75]);
        d = diff(a);
        
        switch lower(tailflg)
            case 'higher',      cut(c) = a(2) + nr*d;
            case 'lower',       cut(c) = a(1) - nr*d;
            case 'abs',         cut(c) = abs(a(2) + nr*d);  % FIXME: hmm, the use of abs does not seem right here
            case 'abshigher',   cut(c) = abs(a(2) + nr*d);  % FIXME: hmm, the use of abs does not seem right here
            case 'abslower',    cut(c) = abs(a(1) - nr*d);  % FIXME: hmm, the use of abs does not seem right here
            case 'both'
                cut(c,1) = a(1) - nr*d;
                cut(c,2) = a(2) + nr*d;
        end
        
    % standard deviation cut off
    elseif strcmpi(rangeflg,'std')
        
        a = nanmean(tmp);
        d = nanstd(tmp);
        
        switch lower(tailflg)
            case 'higher',      cut(c) = a + nr*d;
            case 'lower',       cut(c) = a - nr*d;
            case 'abs',         cut(c) = abs(a + nr*d);  % FIXME: hmm, the use of abs does not seem right here
            case 'abshigher',   cut(c) = abs(a + nr*d);  % FIXME: hmm, the use of abs does not seem right here
            case 'abslower',    cut(c) = abs(a - nr*d);  % FIXME: hmm, the use of abs does not seem right here
            case 'both'
                cut(c,1) = a - nr*d;
                cut(c,2) = a + nr*d;
        end
        
    end
    
    % apply cut-off to data
    switch lower(tailflg)
        case 'higher',      idx(c,dat(c,:)>cut(c)) = true;
        case 'lower',       idx(c,dat(c,:)<cut(c)) = true;
        case 'abs',         idx(c,abs(dat(c,:))>cut(c)) = true;
        case 'abshigher',   idx(c,abs(dat(c,:))>cut(c)) = true;
        case 'abslower',    idx(c,abs(dat(c,:))<cut(c)) = true;
        case 'both',        idx(c,dat(c,:)<cut(c,1) | dat(c,:)>cut(c,2)) = true;
    end
    
end

% transpose output if requested
if transposeflg
    idx_ignore = idx_ignore';
    idx = idx';
end