function Sc = structcat(S,dim,exclclass,exclname)
% structcat concatenates fields (and subfields) of a structure in the
% requested dimension (default: 1). You can specify to exclude fields of a
% certain class (exclclass), or name (exclname).

nrS = length(S);
if ~iscell(S),          Sc = S; return;             end
if nrS < 2,             Sc = S{1}; return;          end
if nargin < 2,          dim = 1;                    end
if nargin < 3,          exclclass = {};             end
if nargin < 4,          exclname = '';              end
if ~iscell(exclclass),	exclclass = {exclclass};	end

% get the fields
flds = fieldnames(S{1});
nrflds = length(flds);

% return if S is empty
if all(cellfun(@isempty,S)) || nrflds == 0
    Sc = S{1}; return
end

% append the rejection indeces arrays
for f = 1:nrflds
    if any(strcmpi(flds{f},exclname))
        continue
    end
    excl = false;
    for i = 1:length(exclclass)
        if isa(S{1}.(flds{f}),exclclass{i})
            Sc.(flds{f}) = S{1}.(flds{f});
            excl = true;
        end
    end
    if excl
        continue;
    end
    if isstruct(S{1}.(flds{f}))
        % re-enter the subfield in the function
        tmp = cell(1,nrS);
        for s = 1:nrS
            tmp{s} = S{s}.(flds{f});
        end
        Sc.(flds{f}) = structcat(tmp,dim,exclclass,exclname);
    else
        eval_str = 'cat(dim';
        for s = 1:nrS
            eval_str = sprintf('%s,S{%d}.%s',eval_str,s,flds{f});
        end
        eval_str = sprintf('%s)',eval_str);
        Sc.(flds{f}) = eval(eval_str);
    end        
end