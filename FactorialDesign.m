function M = FactorialDesign(A,varargin)
%% FactorialDesign
%----------
% example use case for a 3 x 3 x 12 factorial design:
% M = FactorialDesign(1:3,1:3,1:12);
%
% Lennart Verhagen (c) 2018
%----------

% ensure column notation
if max(size(A)) == numel(A), A = A(:); end

% return when no more expansion needed
if isempty(varargin)
  M = A;
  return
end

% draw the first expansion from the varargin
B = varargin{1}(:);

% count number of conditions
nA = size(A,1);
nB = size(B,1);

% expand A and B
A = A(sort(repmat((1:nA)',nB,1)),:);
B = B(repmat((1:nB)',nA,1));

% prepare output
M = [A B];

% iterate
M = FactorialDesign(M,varargin{2:end});

