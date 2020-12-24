syms s k1 k2
sI = eye(2)*s;
A = [0 -1;5 2];
b = [0;1];
K = [k1, k2];

X = sI -A + (b*K)
eq1 = det(X)                %Characterstic Equation
s_coeff_eq1 = coeffs(eq1,s)

eq2 = expand((s+5)*(s+10))  %Pole Placement Equation
s_coeff_eq2 = coeffs(eq2,s)

Y = coeffs((eq1 - eq2),s);
K1 = solve(Y(1),k1)
K2 = solve(Y(2),k2)