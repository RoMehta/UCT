X = 2
for n = 1:100
    X = (10*(X-1))/n;
    if rem(n,10)== 0
        disp(X)
    end
end