function D = peuclid(X,Dtype)
% pair-wise Euclidic distance
%
% Input
%   X       npnts by ndims data matrix (also determines output class)
%   Dtype   determines output type: 'matrix' (default), 'vector'


% housekeeping
if nargin<2
    Dtype = 'mat';
else
    Dtype = lower(Dtype(1:3));
end
Dclass = class(X);
[npnts,ndims] = size(X);

% core
switch Dtype
    case 'vec'
        k = 1;
        D = zeros(1,npnts*(npnts-1)./2, Dclass);
        % loop over points
        for i = 1:npnts-1
            dsq = zeros(npnts-i,1,Dclass);
            for q = 1:ndims
                dsq = dsq + (X(i,q) - X((i+1):npnts,q)).^2;
            end
            D(k:(k+npnts-i-1)) = sqrt(dsq);
            k = k + (npnts-i);
        end
    case {'mat','spa'}
        D = nan(npnts);
        % loop over points
        for i = 1:npnts-1
            D((i+1):npnts,i) = sum(bsxfun(@minus,X(i,:),X((i+1):npnts,:)).^2,2);
        end
        D = sqrt(D);
end
