sum = 0;
state = 0;

for d = 1:1000
    
    if(state)
        sum = sum - 1/d;
    else
        sum = sum + 1/d;
    end
    state = not(state);
    
end