function fname_expanded = expandfname(fname,fun,varargin)
%--------------------------------------------------------------------------
% expand the file name to accomodate folder and filter entries
%
% fname - file (can contain wildcard) name to expand
% fun   - directory listing function: 'dir' [default], 'rdir', 'subdir'
%
% Lennart Verhagen
% University of Oxford, 2015-02-01
%--------------------------------------------------------------------------
if nargin < 2, fun = 'dir'; end

% convert image file name to cell and loop
if ~iscell(fname), fname = {fname}; end
fname_expanded = {};
for f = 1:length(fname)
    if ~exist(fname{f},'dir')
        % enforce .nii.gz extension for files
        idx = regexp(fname{f},'\.\w','start','once');
        if isempty(idx), fname{f} = [fname{f} '.nii.gz']; end
    end
    % list files matching filter
    switch fun
        case 'dir'
            fname_tmp = dir(fname{f});
        case 'subdir'
            fname_tmp = subdir(fname{f});
        case 'rdir'
            fname_tmp = rdir(fname{f},varargin{:});
    end
    % exclude directories
    fname_tmp = fname_tmp(~[fname_tmp.isdir]);
    fname_tmp = {fname_tmp.name};
    % prepad with path if 'dir' is used to list the files
    if strcmpi(fun,'dir')
        fname_tmp = cellfun(@(x) fullfile(fileparts(fname{f}),x),fname_tmp,'UniformOutput',false);
    end
    % append to output cell
    fname_expanded(end+1:end+length(fname_tmp)) = fname_tmp;
end