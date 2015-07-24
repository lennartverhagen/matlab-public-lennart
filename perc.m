function c = perc(a,b)
% c = perc(a,b)
%
% a: old
% b: new
% c: percentage increase from a to b

if a == 0 && b == 0
    c = 0;
else
    c = ((b-a)/a)*100;
end