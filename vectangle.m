function theta = vectangle(u,v,flg,deprecated)
% The cosine of the angle between two vectors a & b is obtained by dividing
% the dot product of the two vectors by the product of their lengths:
%
%                         u'*v
%                 ------------------------
%                 sqrt(sum(u.^2)*sum(v.^2)
%
% If (and only if) both vectors have zero mean, i.e. sum(a)==sum(b)==0,
% then the cosine of the angle between the vectors is the same as the
% correlation between the two variates.
%
% The angle can be given as the cosine (flg = 'cos'), radians (flg = 'rad')
% or in degrees (flg = 'deg').

% check for deprecated input arguments
dim = [];
if nargin>3 && ischar(deprecated)
    dim = flg;
    flg = deprecated;
elseif nargin>2 && isscalar(flg)
    dim = flg;
    flg = '';
elseif nargin>3
    % throw an error
    narginchk(1,3);
end

% set default flg to 'cos'
if nargin < 3 || isempty(flg), 	flg = 'cos';    end

% if only one input is delivered, split u into u and v
if nargin < 2 || isempty(v)
    siz = size(u);
    if isempty(dim)
        dim = find(siz==2);
        if length(dim) ~= 1
            error('LENVER:VectAngle:InputDim','One input matrix is given but the dimension over which to calculate the angle is unknown');
        end
    end
    U = permute(u,[dim setdiff(1:length(siz),dim)]);
    siz(dim) = [];
    u = nan(siz); v = nan(siz);
    u(:) = U(1,:); v(:) = U(2,:);
    clear U;
end

% if both inputs have the same number of elements
if numel(u) == numel(v)
    % if both inputs are vectors, enforce the same dimensions
    if numel(u) == length(u) && numel(v) == length(v)
        u = u(:); v = v(:);
    end
    
    % pick one of two algorithms
    switch min(size(u))
        case 1 % faster option
            % do the actual work
            theta = (u'*v)/(sqrt(sum(u.^2)*sum(v.^2)));
        otherwise % slower option
            % try to escape quickly and accurately
            if isequal(u,v)
                theta = ones(1,size(u,2));
            else
                % do the actual work
                theta = dot(u,v)/(norm(u)*norm(v));
            end
    end

% if the inputs do not have the same number of elements
else
    % dimensions of arguments
    sizu = size(u);
    sizv = size(v);
    % only accept matrices with two dimensions
    if length(sizu)>2 || length(sizv)>2
        error('LENVER:vectangle:InvalidDims','u and v must both have only two dimensions.');
    end
    % find where the dimensions differ
    sizd = sizv-sizu;
    if sum(sizd~=0)>1
        error('LENVER:vectangle:InvalidDims','u and v differ in size in more than one dimension.');
    end
    % repeat dimensions
    dimrep = abs(sizd) + ones(1,length(sizd));
    dim = find(dimrep==1,1);
    if sum(sizd)>0
        %nom = dot(repmat(u,dimrep),v,dim);
        nom = sum(repmat(u,dimrep).*v,dim);
    else
        %nom = dot(u,repmat(v,dimrep),dim);
        nom = sum(u.*repmat(v,dimrep),dim);
    end
    denom = sqrt(sum(u.^2,dim).*sum(v.^2,dim));
    theta = nom./denom;
end

% return in radians or degrees
if isequal(flg(1),'r')
	theta = acos(theta);
elseif isequal(flg(1),'d')
	theta = acos(theta)*180/pi;
end