function [vec,ni] = matchvectors(vec,vec_ref,gra,nvect)
% reorder vectors in vec to match vec_ref as close as possible (determined
% by the largest cosine of the angle)
if nargin < 3
    nvect = 3;
end

% calculate angle between reference and current eigenvectors
theta = [vectangle(vec_ref(:,1),vec)
         vectangle(vec_ref(:,2),vec)
         vectangle(vec_ref(:,3),vec)];
         
if nvect == 3
    % find the smallest angle (largest cosine)
    T = abs(theta);
    ni = nan(1,3);
    while any(T(:))
        % find matches for all three vectors
        [m,n] = max(T,[],2);
        % appoint closest match first
        [~,nm] = max(m);
        ni(nm) = n(nm);
        % then continue to search
        T(nm,:) = 0; T(:,n(nm)) = 0;
    end
    % check for overlap
    if length(unique(ni)) < 3 || any(isnan(ni));
        error('this does not work')
    end
    new_sign = sign([theta(1,ni(1)) theta(2,ni(2)) theta(3,ni(3))]);
elseif nvect == 2
    % calculate angle between reference and current eigenvectors
    theta2 = [0 theta(2,2:3)];
    theta3 = [0 theta(2,2:3)];
    % find the smallest angle (largest cosine)
    [m2,n2] = max(abs(theta2));
    [m3,n3] = max(abs(theta3));
    % do not permit different vectors to be mapped to the same
    if m2 > m3
        n3 = setdiff(2:3,n2);
    else
        n2 = setdiff(2:3,n3);
    end
    ni = [1 n2 n3];
    new_sign = sign([1 theta2(n2) theta3(n3)]);
end

% map referenced vectors
vec = bsxfun(@times,new_sign,vec(:,ni));

% check if a vector matches the direction of movement very closely
gra_theta = vectangle(gra,vec);
[m,n] = max(abs(gra_theta));
% if this is not the first vector, place it up front
if n ~= 1 && ( m>0.8 || all(m > abs(theta(:,n))) )
    idx_vec = 1:3; idx_vec(1) = n; idx_vec(n) = 1;
    ni = ni(idx_vec);
    vec = vec(:,idx_vec);
    % check if the matched components match in direction and flip sign if
    % necessary
    vec = bsxfun(@times,sign(vectangle(vec_ref,vec)),vec);
end