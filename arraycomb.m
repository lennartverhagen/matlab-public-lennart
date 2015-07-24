function M = arraycomb(varargin)
%--------------------------------------------------------------------------
% ARRAYCOMB combines arrays into a matrix with all combinations of the
% array values. You can reverse the direction of combination by adding a
% string with 'reverse' to the input arguments.
%
% For example:
%
% A = [1 2]; B = [1:3]
% M = arraycomb(A,B);
% M = [1 1
%      2 1
%      1 2
%      2 2
%      1 3
%      2 3];
%
% M = arraycomb(A,B,'reverse');
% M = [1 1
%      1 2
%      1 3
%      2 1
%      2 2
%      2 3];
%--------------------------------------------------------------------------

% find direction flag in input
idx_dirflg = cellfun(@(x) ischar(x),varargin);
if sum(idx_dirflg)==1
    dirflg = varargin{idx_dirflg};
    dirflg = strcmpi(dirflg,'reverse');
    varargin = varargin(~idx_dirflg);
else
    dirflg = false;
end
if ~dirflg
    % forward order
    vect = 1:length(varargin);
else
    % reverse order
    vect = length(varargin):-1:1;
end

M = [];
for i = vect
    % get new array
    A = varargin{i}(:);
    % determine matrix and array lengths
    nM = max(1,size(M,1));
    nA = length(A);
    % repeat matrix and array
    rM = repmat(M,nA,1);
    iA = sort(repmat([1:nA]',nM,1));
    rA = A(iA);
    % combine matrix and array to form new matrix
    if ~dirflg
        M = [rM rA];
    else
        M = [rA rM];
    end
end