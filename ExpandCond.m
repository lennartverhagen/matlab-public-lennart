function M = ExpandCond(A,varargin)
%% ExpandCond
%----------
% This is a legacy function, please switch to FactorialDesign
%
% example use case for a 3 x 3 x 12 factorial design:
% M = ExpandCond(1:3,1:3,1:12);
%
% Lennart Verhagen (c) 2018
%----------

% ExpandCond is a legacy name, call the new function
M = FactorialDesign(A,varargin);
