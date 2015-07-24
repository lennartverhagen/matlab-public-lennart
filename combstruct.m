function Scomb = combstruct(Sdefault,Supdate)
% S = COMBSTRUCT(Sdefault,Supdate)
% combine structures: S = Sdefault, but all (sub)fields of Scurr overwrite
% those of Sdefault (if present) or are added (if not present).

% return quickly
if nargin < 1,  Scomb = struct; return; end

% base new structure (Scomb) on first input (Sdefault)
Scomb = Sdefault;
if nargin < 2,	return;	end

switch 'new'
    case 'new'
        % ensure Scomb has the same length as Supdate
        nScomb = length(Scomb);
        nSupdate = length(Supdate);
        if nScomb > nSupdate
            Scomb = Scomb(1:nSupdate);
        elseif nScomb < nSupdate
            Scomb(end+1:nSupdate) = Scomb(end);
        end
        
        % copy fields from Supdate to Scomb (overwriting existing fields)
        fn = fieldnames(Supdate);
        for f = 1:length(fn)
            
            % loop over elements of Supdate and Scomb
            for i = 1:nSupdate
                
                if isfield(Scomb(i),fn{f}) && isstruct(Scomb(i).(fn{f})) && isstruct(Supdate(i).(fn{f}))
                    % if the fields are also structures, call combstruct iteratively
                    Scomb(i).(fn{f}) = combstruct(Scomb(i).(fn{f}),Supdate(i).(fn{f}));
                else
                    % otherwise overwrite the Sa field with the Snew field
                    Scomb(i).(fn{f}) = Supdate(i).(fn{f});
                end
            end
            
        end
        
    case 'old'
        % copy fields from Supdate to Scomb (overwriting existing fields)
        fn = fieldnames(Supdate);
        for f = 1:length(fn)
            
            % loop over the elements of Sdefault and Scomb
            for i = 1:max(length(Scomb),length(Supdate))
                %if length(Sb) < i,  continue;   end
                if length(Supdate) < i
                    Scomb = Scomb(1:i-1);
                    break
                end
                
                % if the fields are also structures, call combstruct iteratively
                if length(Scomb) >= i && isfield(Scomb(i),fn{f}) && isstruct(Scomb(i).(fn{f})) && isstruct(Supdate(i).(fn{f}))
                    Scomb(i).(fn{f}) = combstruct(Scomb(i).(fn{f}),Supdate(i).(fn{f}));
                    
                    % otherwise overwrite the Sa field with the Snew field
                else
                    Scomb(i).(fn{f}) = Supdate(i).(fn{f});
                end
            end
            
        end
end
