function varargout = plot3fix(dat,varargin)

% check if first input argument is a handle
flg_h = numel(dat)==1 & ishandle(dat);
if flg_h
    h = dat;
    dat = varargin{1};
    varargin = varargin{2:end};
end

% Permute to place dimension with 3 up front
dat = shiftdim(dat);
siz = size(dat);
dim = find(siz==3,1);
if isempty(dim)
    error('LENVER:public:plot3fix','Data to plot must have a dimension with 3 axis to use plot3fix');
elseif dim ~= 1
    idx = [dim setdiff(1:length(siz),dim)];
    dat = permute(dat,idx);
    siz = size(dat);
end

% select and reshape data to suit plot3
siz = [siz(2:end) ones(1,3-length(siz))];
x = reshape(dat(1,:),siz);
y = reshape(dat(2,:),siz);
z = reshape(dat(3,:),siz);

% plot
if flg_h
    h = plot3(h,x,y,z,varargin{:});
else
    h = plot3(x,y,z,varargin{:});
end

% set axis to equal and the view to default for 3D plots
daspect([1,1,1]); view(3);

% return handle if requested
varargout = {};
if nargout > 0, varargout = {h}; end