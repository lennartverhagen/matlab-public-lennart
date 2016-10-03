function sout = getsubfield(s, f)

% GETSUBFIELD returns a field from a structure just like the standard
% GETFIELD function, except that you can also specify nested fields
% using a '.' in the fieldname. The nesting can be arbitrary deep. If the
% structure is multidimensional it will return the result in a cell
% array.
%
% Use as
%   f = getsubfield(s, 'fieldname')
% or as
%   f = getsubfield(s, 'fieldname.subfieldname')
%
% See also GETFIELD, ISSUBFIELD, SETSUBFIELD

% Copyright (C) 2016, Lennart Verhagen
% Copyright (C) 2005-2013, Robert Oostenveld
%
% This file is based on a file that was part of FieldTrip, see
% http://www.fieldtriptoolbox.org for the documentation and details.
%
%    FieldTrip is free software: you can redistribute it and/or modify
%    it under the terms of the GNU General Public License as published by
%    the Free Software Foundation, either version 3 of the License, or
%    (at your option) any later version.
%
%    FieldTrip is distributed in the hope that it will be useful,
%    but WITHOUT ANY WARRANTY; without even the implied warranty of
%    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
%    GNU General Public License for more details.
%
%    You should have received a copy of the GNU General Public License
%    along with FieldTrip. If not, see <http://www.gnu.org/licenses/>.
%
% $Id$

if nargin < 2
  f = '';
end

if iscell(f)
  f = f{1};
end

if ~ischar(f)
  error('incorrect input argument for fieldname');
end

if ~iscell(s)
  s = {s};
end

if isempty(f)
  sout = s;
  return
end

f = regexp(f,'\.','split');
sout = cell(size(s));
for c = 1:numel(s)
  sout{c} = getsubfield({s{c}.(f{1})},f{2:end});
  while iscell(sout{c}) && numel(sout{c}) == 1
    sout{c} = sout{c}{:};
  end
end

while iscell(sout) && numel(sout) == 1
  sout = sout{:};
end
