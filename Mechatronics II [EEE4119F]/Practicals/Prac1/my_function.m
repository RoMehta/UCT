 classdef my_function
     methods(Static)
         function [x_m] = x(v_x)
             x_m = v_x.*10-1000;
         end
         function [y_m] = y(v_y)
             y_m = v_y.*10 - 5*(10)^2 - 1250;
         end
     end
 end