function [new_C,new_count,flag] = merge(C,index,count)

new_C = C;
flag  = 0;
canceled_line = zeros(count,1);
n_lines = 0;
for i=1:count
    k_min = C(i,1);
    k_max = C(i,2);
    l_min = min(C(i,3),C(i,4));
    l_max = max(C(i,3),C(i,4));
    length = C(i,5);
    ang = C(i,6);
    b_yy = C(i,7);
    b_xx = C(i,8);
    n_connected = 1;
    if canceled_line(i) ~= 1
        n_lines = n_lines+1;
        for j=i+1:count
             if canceled_line(j) ~= 1
                if  index(i,j) ~= 0
                    %merge segments i and j
                    n_connected = n_connected +1;
                    flag = 1;
                    canceled_line(j) = 1;
                    k_min = min([k_min C(j,1) C(j,2)]);
                    k_max = max([k_max C(j,1) C(j,2)]);
                    l_min = min([l_min C(j,3) C(j,4)]);
                    l_max = max([l_max C(j,3) C(j,4)]);
                    if C(j,5) > length
                        length = C(j,5);
                        ang = C(j,6);
                        b_yy = C(j,7);
                        b_xx = C(j,8);
                    end
                end
             end
        end
        new_C(n_lines,6) = ang;
        new_C(n_lines,7) = b_yy;
        new_C(n_lines,8) = b_xx;
        new_C(n_lines,1) = k_min; new_C(n_lines,2) = k_max;
        if ang >= 0
            new_C(n_lines,3) = l_min; new_C(n_lines,4) = l_max;
        else
            new_C(n_lines,3) = l_max; new_C(n_lines,4) = l_min;
        end
        length = sqrt((new_C(n_lines,1)-new_C(n_lines,2))^2 + ...
                 (new_C(n_lines,3)-new_C(n_lines,4))^2);
        new_C(n_lines,5) = length;    
    end
end
new_count = n_lines;

