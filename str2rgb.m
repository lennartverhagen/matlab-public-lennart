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
