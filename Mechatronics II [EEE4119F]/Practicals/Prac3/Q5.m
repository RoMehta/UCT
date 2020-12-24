% Qn 5a:
syms a b c A
E = ((b^2) + (c^2) - (2*b*c*cos(A)) == (a^2));
b_ans = solve(E,b)
% //Another way
%solve(((b^2) + (c^2) - (2*b*c*cos(A)) == (a^2)),b) 

% Qn 5b:
syms m
F = subs(E,{a,c,A},{(5*m),(2*m),(pi/3)})
b_ans = solve(F,b)
