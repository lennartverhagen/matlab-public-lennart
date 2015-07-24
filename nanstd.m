function y = nanstd(varargin)

y = sqrt(nanvar(varargin{:}));