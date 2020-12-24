% Qn 4a:
syms x y;
simplify((sin (x))^2 + (cos (x))^2) % LHS of the equation
    
% Qn 4b:
syms x y;
simplify(cos(y)*sin(x) + cos(x)*sin(y)) %LHS of the equation
simplify(cos(y)*sin(x) + cos(x)*sin(y)) == expand(sin(x+y))
    
% Qn 4c:
syms x y;
simplify((cosh (x))^2 - (sinh (x))^2) % LHS of the equation
