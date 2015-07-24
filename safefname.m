function fname_safe = safefname(fname)
%--------------------------------------------------------------------------
% ignore spaces in the filename by prepadding them with a backslash
%
% Lennart Verhagen
% University of Oxford, 2015-02-01
%--------------------------------------------------------------------------
fname_safe = regexprep(fname,'(?<!\\) ','\\ ');