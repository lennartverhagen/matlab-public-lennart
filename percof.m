function c = percof(a,b)
% a: sample
% b: reference
% c: percentage of sample compared to reference

if a == 0 && b == 0
    c = 100;
else
    c = (a/b)*100;
end