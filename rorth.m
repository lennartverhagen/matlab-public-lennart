function X = rorth(X,flg)
%--------------------------------------------------------------------------
% RORTH performs recursive Gram-Schmidt orthogonalisation on the columns of
% X (performed serially, starting with the first column).
%
% X = RORTH(X,flg)
%
% X   - matrix
% flg - 'pad'  for zero padding of null space [default]
%     - 'norm' for Euclidean normalisation
%     
% refs:
% Golub, Gene H. & Van Loan, Charles F. (1996), Matrix Computations (3rd
% ed.), Johns Hopkins, ISBN 978-0-8018-5414-9.
%
% Copyright (C) 2008 Wellcome Trust Centre for Neuroimaging
% Karl Friston
% 
% adapted by Lennart Verhagen
% L.Verhagen@donders.ru.nl
% version 2010-01-01
%--------------------------------------------------------------------------

% check input
if nargin < 2
    flg = 'pad';
end

% recursive Gram-Schmidt orthogonalisation
%--------------------------------------------------------------------------
sw = warning('off','all');
[n m] = size(X);
X     = X(:,any(X));
try
    x     = X(:,1);
    j     = 1;
    for i = 2:size(X,2)
        D = X(:,i);
        D = D - (x'*x)\x*x'*D;      % x*(inv(x'*x)*x'*D)
        if norm(D,1) > exp(-32)
            x          = [x D];
            j(end + 1) = i;
        end
    end
catch
    x     = zeros(n,0);
    j     = [];
end
warning(sw);


% perform normalisation, if requested
%--------------------------------------------------------------------------
switch flg
    case{'pad'}
        X      = zeros(n,m);
        X(:,j) = x;
    otherwise
        X = x;
        % perform Euclidian normalization
        for i = 1:size(X,2)
            if any(X(:,i))
                X(:,i) = X(:,i)/sqrt(sum(X(:,i).^2));
            end
        end
end
