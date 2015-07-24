function D = dutch(m)
%--------------------------------------------------------------------------
%DUTCH    Red-White-Blue colormap
%   DUTCH(M) is an M-by-3 matrix containing a blue, white, red  colormap.
%   The colors begin with dark blue, range through shades of blue, white
%   and red, and end with dark red. DUTCH, by itself, is the same length as
%   the current figure's colormap. If no figure exists, MATLAB creates one.
%
%   See also JET, HSV, HOT, PINK, FLAG, COLORMAP, RGBPLOT.

% This file is based on the mat file dutch.mat, so the copyright only holds
% for the code itself, not for the colormap it creates
% Copyright (C) 2010, Lennart Verhagen
% L.Verhagen@donders.ru.nl
% version 2010-02-01
%--------------------------------------------------------------------------

% get colormap size
if nargin < 1
   m = size(get(gcf,'colormap'),1);
end

x = linspace(0,1,m);
x = x';

D = [red(x) green(x) blue(x)];

%--------------------------------------------------------------------------


function r = red(x)
yu = max(min(3*x-0.5,1),0);
yd = max(min(-2*x+8/3,1),0);
r = min([yu yd],[],2);

function g = green(x)
yu = max(min(3*x-0.5,1),0);
yd = max(min(-3*x+2.5,1),0);
g = min([yu yd],[],2);

function b = blue(x)
yu = max(min(2*x+2/3,1),0);
yd = max(min(-3*x+2.5,1),0);
b = min([yu yd],[],2);