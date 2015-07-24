function gra = nangradient(dat)

sizd = size(dat);
if length(sizd) > 2
    error('PUBLIC:novector','input must be a vector or a n*m matrix');
end

% reorient dat if vector
if sizd(2) == 1
    dat = dat';
end

% initialize output
gra = nan(size(dat));

% find sections without nans
idx = ~any(isnan(dat),1);
idx = logic2idx(idx);

% loop over sections
for i = 1:size(idx,1)
    gra(:,idx(i,1):idx(i,2)) = gradient(dat(:,idx(i,1):idx(i,2)));
end

% flip back if needed
if sizd(2) == 1
    gra = gra';
end