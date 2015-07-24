function D = jetpack(m,flg)
%--------------------------------------------------------------------------
%JETPACK    Alternative colormap based on jet
%   JETPACK(M) is an M-by-3 matrix containing a colormap based on .
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

% get type of color transitions
if nargin < 2
    flg = 'sharp';
end

% get points on colormap
if m > 7
    x = linspace(0,1,m)';
elseif m == 1
    x = 4/8;
elseif m == 2
    x = [1 7]'/8;
elseif m == 3
    x = [1 4 7]'/8;
elseif m == 4
    x = [1 3 5 7]'/8;
elseif m == 5
    x = [0 2 4 6 8]'/8;
elseif m == 6
    x = [0 1 3 5 7 8]'/8;
elseif m == 7
    x = [1 2 3 4 5 6 7]'/8;
end

% get red green and blue values
switch lower(flg)
    case 'smooth'
        D = [smooth_red(x) smooth_green(x) smooth_blue(x)];
    case 'sharp'
        D = [sharp_red(x) sharp_green(x) sharp_blue(x)];
end


%% Smooth color transations
%--------------------------------------------------------------------------
function r = smooth_red(x)
y0 = zeros(size(x));
y1 = 1-((x-(3/4))*8).^2/9;
y2 = y0; y2(x>=(3/4) & x<=(7/8)) = 1;
y3 = 1-((x-(7/8))*16).^2/9;
r = max([y0 y1 y2 y3],[],2);

function g = smooth_green(x)
g = max(1-((x-(1/2))*8).^2/9,0);

function b = smooth_blue(x)
y0 = zeros(size(x));
y1 = 1-((x-(1/8))*16).^2/9;
y2 = y0; y2(x>=(1/8) & x<=(1/4)) = 1;
y3 = 1-((x-(1/4))*8).^2/9;
b = max([y0 y1 y2 y3],[],2);


%% Sharp color transations
%--------------------------------------------------------------------------
function r = sharp_red(x)
y0 = zeros(size(x));
yd3= 4.8*(x-(3/8));
yd2= 2.4*(x-(4/8)) + 0.6;
yd1= 0.8*(x-(5/8)) + 0.9;
y1 = ones(size(x));
yu = -3.2*(x-(7/8)) + 1;
y = min([yu y1 yd1 yd2 yd3],[],2);
r = max([y y0],[],2);

function g = sharp_green(x)
y0 = zeros(size(x));
yu1= 4.8*(x-(1/8));
yu2= 2.4*(x-(2/8)) + 0.6;
yu3= 0.8*(x-(3/8)) + 0.9;
yd1= -0.8*(x-(4/8)) + 1;
yd2= -2.4*(x-(5/8)) + 0.9;
yd3= -4.8*(x-(6/8)) + 0.6;
y = min([yu1 yu2 yu3 yd1 yd2 yd3],[],2);
g = max([y y0],[],2);

function b = sharp_blue(x)
y0 = zeros(size(x));
yu = 3.2*x + 0.6;
y1 = ones(size(x));
yd1= -0.8*(x-(2/8)) + 1;
yd2= -2.4*(x-(3/8)) + 0.9;
yd3= -4.8*(x-(4/8)) + 0.6;
y = min([yu y1 yd1 yd2 yd3],[],2);
b = max([y y0],[],2);