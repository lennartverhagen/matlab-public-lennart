function ploterrorcloud(x,y,yerr,varargin)
%--------------------------------------------------------------------------
% PLOTERRORCLOUD adds an error cloud to a line plot
%
% Copyright (C) 2010, Lennart Verhagen
% L.Verhagen@donders.ru.nl
% version 2011-12-01
%--------------------------------------------------------------------------

% set default cloud color to black
spec.cl     = [0 0 0];  % black: 'k' or [0 0 0]

% get color specifications from varargin
if length(varargin) == 1
    spec.cl     = varargin{1};
    varargin    = {};
elseif length(varargin) > 1
    [spec.cl, varargin] = keyval('Color',varargin);
    if isempty(spec.cl) && isodd(length(varargin))
        spec.cl	= varargin{1};
        varargin= varargin(2:end);
    end
end

% get plot specification from varargin or set defaults
[spec.alpha, varargin]      = keyval('FaceAlpha',varargin);
[spec.lnstyle, varargin]    = keyval('LineStyle',varargin);
% or set defaults
if isempty(spec.alpha),     spec.alpha      = 0.2;      end
if isempty(spec.lnstyle),   spec.lnstyle    = 'none';   end

% if NaNs are present, restrict sem plotting to non-nan sections of the data
if ~any(isnan(yerr))
    xplot = [x fliplr(x)];
    yplot = [y+yerr fliplr(y-yerr)];
    hf = patch(xplot,yplot,spec.cl,'FaceAlpha',spec.alpha,'LineStyle',spec.lnstyle,varargin{:});
    uistack(hf,'bottom');
else
    idx_nan = isnan(yerr) | isnan(y);
    idx_on	= find(diff([0; ~idx_nan])==1);
    idx_off = find(diff([~idx_nan; 0])==-1);
    hf = nan(length(idx_on),1);
    for i = 1:length(idx_on)
        idx = idx_on(i):idx_off(i);
        xplot = [x(idx) fliplr(x(idx))];
        yplot = [y(idx)+yerr(idx); flipud(y(idx)-yerr(idx))];
        hf(i) = patch(xplot,yplot,spec.cl,'FaceAlpha',spec.alpha,'LineStyle',spec.lnstyle,varargin{:});
    end
    uistack(hf,'bottom');
end