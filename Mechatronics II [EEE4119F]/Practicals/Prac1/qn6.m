counter = 0;
rolls= 1;

while rolls<1000
  x = randi(6);
  rolls = rolls+1;
  if x == 6
      counter = counter+1;
  end
  probability = counter/1000;
  disp (probability)
end