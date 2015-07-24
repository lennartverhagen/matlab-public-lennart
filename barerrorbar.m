function hb = barerrorbar(dat,err,varargin)
%--------------------------------------------------------------------------
% BARERRORBAR plots bar graphs with errorbars. Basically, it is a wrapper
% around the bar (matlab), getbarx (Lennart), and errorbar (matlab)
% functions. Why didn't matlab include this function in the first place?
%
% Please be aware that at the moment I'm too lazy to implement the varargin
% distribution over bar and errorbar functions. In other words, it only
% works if varargin contains only parameters that are supported by both bar
% and errorbar.
%
% Copyright (C) 2010-2014, Lennart Verhagen
% Lennart.Verhagen@psy.ox.ac.uk
% version 2014-11-01
%--------------------------------------------------------------------------

% plot bar
hb = bar(dat,varargin{:});

% get x positions of bar graph
x = getbarx(hb);

% loop over first data dimension
hold on;
for d = 1:size(dat,2)
    % add errorbars
    errorbar(x(:,d),dat(:,d),err(:,d),'LineStyle','none','Color','k',varargin{:});
end