function varargout = fileparts2(fname,varargin)
% mimic matlab's built-in 'fileparts' function, but then allow for multiple
% extensions for filenames.
%
% Usage example 1:
%
%   [pa,fi,ex] = fileparts2('This/is/a_great_file.yes.it.is')
%
%   pa: 'This/is'
%   fi: 'a_great_file'
%   ex: '.yes.it.is'
%
%
% Usage example 2:
%
%   [pa,fi,ex] = fileparts2('This/is/a_great_file.yes.it.is','classic')
%
%   pa: 'This/is'
%   fi: 'a_great_file.yes.it'
%   ex: '.is'
%
%
% Usage examples 3-5:
%
%   fi = fileparts2('This/is/a/path/to/a_great_file.yes.it.is','file')
%   fi = fileparts2('This/is/a/path/to/a_great_file.yes.it.is','F')
%   fi = fileparts2('This/is/a/path/to/a_great_file.yes.it.is',2)
%
%   fi: 'a_great_file'


% check for usage mode
if any(ismember(varargin,{'classic','conventional','matlab','built-in'}))
    
    % use the conventional fileparts
    [pa,fi,ex] = fileparts(fname);
    
    % update varargin
    varargin = varargin(~ismember(varargin,{'classic','conventional','matlab','built-in'}));
    
else
    
    % parse the string
    [st,sp] = regexp(fname,'(?<=/?|(\\)?)[\w|-]*(?=\.|$)','start','end','once');
    
    % assining parts to output (as a cell or not)
    if ~iscell(fname)
        pa = fname(1:st-2);     if isempty(deblank(pa)), pa = ''; end
        fi = fname(st:sp);      if isempty(deblank(fi)), fi = ''; end
        ex = fname(sp+1:end);   if isempty(deblank(ex)), ex = ''; end
    else
        pa = cellfun(@(x,cst) x(1:cst-2),fname,st,'UniformOutput',false);
        fi = cellfun(@(x,cst,csp) x(cst:csp),fname,st,sp,'UniformOutput',false);
        ex = cellfun(@(x,csp) x(csp+1:end),fname,sp,'UniformOutput',false);
        pa(cellfun(@(x) isempty(deblank(x)),pa)) = {''};
        fi(cellfun(@(x) isempty(deblank(x)),fi)) = {''};
        ex(cellfun(@(x) isempty(deblank(x)),ex)) = {''};
    end
end

% sort output if requested
varargout = {pa,fi,ex};
if ~isempty(varargin)
    if all(cellfun(@ischar,varargin))
        varargin = cellfun(@(x) lower(x(1)),varargin,'UniformOutput',false);
        [~,varargin] = ismember(varargin,{'p','f','e'});
    else
        varargin = [varargin{:}];
    end
    varargout = varargout(varargin);
end