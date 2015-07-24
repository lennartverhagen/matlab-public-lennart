function C = metadutch(varargin)
%--------------------------------------------------------------------------
% METADUTCH    create a colormap (based on dutch) using any color.
%   METADUTCH(M) creates an M-by-3 matrix containing an RGB colormap based
%   on the original "dutch" colormap (blue-white-red from bottom to top).
%   The "dutch" colormap is used by default, but the user can also manually
%   specify the colors desired. Use as:
%
% C = metadutch(m)
%   m - size of colormap, leave empty when using default.
%   
% C = metadutch(m, [r g b], [r g b])
%   where the 1st color is for the lower and the 2nd for the higher values,
%   with white in the middle. The edges of the colormap are darker versions
%   of the two colors provided by the user.
%
% C = metadutch(m, [r g b], 'o', [r g b], 'gray', [r g b])
%   up to five colors from the "dutch" colormap can be substituted. This
%   functions makes use of str2rgb to allow the use of strings when
%   specifying colors
%
% Copyright (C) 2011, A. Stolk & L. Verhagen
% version 2011-01-31
%--------------------------------------------------------------------------

% set defaults
m = [];
cp = cell(1,5);
cp{2} = [0 0 1]; % blue
cp{3} = [1 1 1]; % white
cp{4} = [1 0 0]; % red

% set border colors
cp{1} = cp{2}*(2/3); % left border
cp{5} = cp{4}*(2/3); % right border

% get colormap size
if nargin > 0 && ~isempty(varargin{1})
    m = varargin{1};
end
% get default colormap size
if isempty(m)
   m = size(get(gcf,'colormap'),1);
end

% sort color input
if nargin > 5 && ~any(cellfun(@isempty,varargin(2:6)))
    cp(1:5) = varargin(2:6);
elseif nargin == 5 && ~any(cellfun(@isempty,varargin(2:5)))
    cp([1 2 4 5]) = varargin(2:5);
elseif nargin == 4 && ~any(cellfun(@isempty,varargin(2:4)))
    cp([2 3 4]) = varargin(2:4);
elseif nargin == 3 && ~any(cellfun(@isempty,varargin(2:3)))
    cp([2 4]) = varargin(2:3);
elseif nargin == 2 && ~isempty(varargin{2})
    cp(2) = varargin(2);
end

% set all colors in a 1x3 format
for c = 1:length(cp)
    if ischar(cp{c})
        cp{c} = str2rgb(cp{c});
    end
    cp{c} = cp{c}(:)';
end

% recalculate border colors if cp2 and cp4 are provided
if nargin > 1 && nargin < 5 
    cp{1} = cp{2}*(2/3); % left border
    cp{5} = cp{4}*(2/3); % right border
end

% set colorpoints to be interpolated
x = [0 1 3 5 6]/6;
y = vertcat(cp{:});

% interpolate desired colorpoints
xi = linspace(0,1,m);
C = interp1(x,y,xi,'linear');
%--------------------------------------------------------------------------


% SUBFUNCTIONS (forked from Lennart's public snippets of code)

function rgb = str2rgb(str)
%--------------------------------------------------------------------------
% STR2RGB	string to RGB values
%   STR2RGB(str) transforms a string, or a cell-array of strings to
%   rgb-values between 0 and 1. It can only handle a basic set of colors,
%   but it can operate both on the full color name or the abbreviated
%   letter:
%
%   NAME       LETTER   [ R   G   B ]
%
%   'red'       'r'     [ 1   0   0 ]
%   'green'     'g'     [ 0   1   0 ]
%   'blue'      'b'     [ 0   0   1 ]
%   'cyan'      'c'     [ 0  0.8 0.8]
%   'magenta'   'm'     [0.8  0  0.8]
%   'yellow'    'y'     [ 1  0.8  0 ]
%   'orange'    'o'     [ 1  0.6 0.2]
%   'black'     'k'     [ 0   0   0 ]
%   'gray'      'h'     [0.4 0.4 0.4]
%   'white'     'w'     [ 1   1   1 ]
%
% see below for color specific comments

% Copyright (C) 2011, Lennart Verhagen
% L.Verhagen@donders.ru.nl
% version 2011-01-31
%--------------------------------------------------------------------------

% return quickly
if nargin < 1 || isempty(str)
    rgb = nan(0,3);
    return
end

% allow cell functionality
strcell = iscell(str);
if ~strcell,    str = {str};    end

% return quickly
if all(cellfun(@isnumeric,str))
    if ~all(cellfun(@(x) size(x,2)==3,str))
        error('PUBLIC:str2rgb','When the input is numeric, it must be n x 3 in size to match rgb');
    elseif ~strcell
        rgb = str{1};
    else
        rgb = str;
    end
    return
elseif ~all(cellfun(@ischar,str))
    error('PUBLIC:str2rgb','Input must be a character array or and cell array of strings');
end
    
% RGB color specifications
C.red       = [255  0   0 ];
C.green     = [ 0  255  0 ];
C.blue      = [ 0   0  255];
C.cyan      = [ 0  204 204];    % [ 0  255 255] is too bright/ugly/plastic
C.magenta	= [204  0  204];    % [ 0  255 255] is too bright/ugly/plastic
C.yellow	= [255 205  0 ];    % sRGB definition
C.orange	= [255 153  51];    % sRGB definition of deep saffron
C.black     = [ 0   0   0 ];
C.grey      = [102 102 102];    % slightly dark grey version
C.gray      = [102 102 102];    % to allow US spelling
C.white     = [255 255 255];

% loop over cells
rgb = cell(size(str));
for i = 1:length(str)
    if isfield(C,str{i})
        tmp = C.(str{i});
    else
        % allow concatenated letters within one cell
        tmp = nan(length(str{i}),3);
        for j = 1:length(str{i})
            switch lower(str{i}(j))
                case 'r',  tmp(j,:) = C.red;
                case 'g',  tmp(j,:) = C.green;
                case 'b',  tmp(j,:) = C.blue;
                case 'o',  tmp(j,:) = C.orange;
                case 'c',  tmp(j,:) = C.cyan;
                case 'm',  tmp(j,:) = C.magenta;
                case 'y',  tmp(j,:) = C.yellow;
                case 'k',  tmp(j,:) = C.black;
                case 'h',  tmp(j,:) = C.grey;
                case 'w',  tmp(j,:) = C.white;
            end
        end
    end
    rgb{i} = tmp/255;
end

% structure output
if ~strcell
    rgb = rgb{1};
end

