function B = complete_segments_info_final(A,N)

% Line detection and merging
% (c) Falah Jabar (falah.jabar@lx.it.pt)

% For each segment in A, this function computes its length, slope (in angle), 
% intercept with yy axis and intercept with xx axis

B = A;

for i=1:N
    ang = B(i,6);
    if abs(B(i,6)) < 45
        ang = B(i,6);
        b1 = A(i,7);
        k_min = A(i,1);
        k_max = A(i,2);
        l_min = min(A(i,3),A(i,4));
        l_max = max(A(i,3),A(i,4));
    else
        % change xx axis with yy axis
        ang = atan(1/tand(ang))*180/pi;
        b1 = A(i,8);
        l_min = A(i,1);
        l_max = A(i,2);
        k_min = min(A(i,3),A(i,4));
        k_max = max(A(i,3),A(i,4));
    end
    if abs(ang) > 0.5
        % not a horizontal line
        m1 = tand(ang);
        m2 = -1/m1;
        if ang >= 0
            b2 = k_min-m2*l_min;
            new_point = intersection(m1,b1,m2,b2);
            k_min = new_point(1);
            l_min = new_point(2);
            b2 = k_max-m2*l_max;
            new_point = intersection(m1,b1,m2,b2);
            k_max = new_point(1);
            l_max = new_point(2);
        else
            b2 = k_min-m2*l_max;
            new_point = intersection(m1,b1,m2,b2);
            k_min = new_point(1);
            l_max = new_point(2);
            b2 = k_max-m2*l_min;
            new_point = intersection(m1,b1,m2,b2);
            k_max = new_point(1);
            l_min = new_point(2);           
        end
    else
        % quasi a horizontal line
        k_min = b1;
        k_max = k_min;
    end
    if abs(B(i,6)) < 45
        B(i,1) = k_min; B(i,2) = k_max;
        if ang >= 0
            B(i,3) = l_min; B(i,4) = l_max;  
        else
            B(i,3) = l_max; B(i,4) = l_min; 
        end
    else
        B(i,1) = l_min; B(i,2) = l_max;
        if ang >= 0
            B(i,3) = k_min; B(i,4) = k_max;  
        else
            B(i,3) = k_max; B(i,4) = k_min; 
        end       
    end
    B(i,5)=sqrt((B(i,1)-B(i,2))^2 + (B(i,3)-B(i,4))^2); 
    delta_i = B(i,2)-B(i,1);
    delta_j = B(i,4)-B(i,3);
    if delta_j ~= 0 && delta_i ~= 0
        m = delta_i/delta_j;
        B(i,6) =  atan(m)*180/pi;
        B(i,7) = B(i,1)-m*B(i,3);
        B(i,8) = -B(i,7)/m;
    elseif delta_j == 0
        B(i,6) = 90;
        B(i,7) = inf;
        B(i,8) = B(i,3);
    else
        B(i,6) = 0;
        B(i,7) = B(i,1);
        B(i,8) = inf;
    end
end

end
