function str = spellout(str,reverseflg)
% spell out mathematic characters (or reverse spellout)

if nargin < 2
    reverseflg = false;
elseif ischar(reverseflg) && ...
        any(strcmpi(reverseflg,{'reverse','yes'}))
    reverseflg = true;
end

% spell out mathematic characters
if ~reverseflg
    str = regexprep(str,'[\[\(]','LP');
    str = regexprep(str,'[\)\]]','RP');
    str = regexprep(str,'\&','AND');
    str = regexprep(str,'\|','OR');
    str = regexprep(str,'\-','MIN');
    str = regexprep(str,'\+','PLUS');
    str = regexprep(str,'<','LT');
    str = regexprep(str,'>','GT');
    
% replace recognizable strings with mathematic characters
else
    str = regexprep(str,'LP','\(');
    str = regexprep(str,'RP','\)');
    str = regexprep(str,'AND','\&');
    str = regexprep(str,'OR','\|');
    str = regexprep(str,'MIN','\-');
    str = regexprep(str,'PLUS','\+');
    str = regexprep(str,'LT','<');
    str = regexprep(str,'GT','>');
end