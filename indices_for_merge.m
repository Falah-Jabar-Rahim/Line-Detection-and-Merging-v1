function   index = indices_for_merge(C,count,max_dist)

% Line detection and merging
% (c) Falah Jabar (falah.jabar@lx.it.pt)

index = zeros(count);
for i=1:count
    k_min = C(i,1); 
    k_max = C(i,2); 
    l_min = min(C(i,3),C(i,4)); 
    l_max = max(C(i,3),C(i,4)); 
    if abs(C(i,6)) < 45
        for j=i+1:count
            u_min = C(j,1); 
            u_max = C(j,2); 
            v_min = min(C(j,3),C(j,4)); 
            v_max = max(C(j,3),C(j,4)); 
            if ((v_min < l_min) && (v_max >= l_min)) || ...
               ((v_min <= l_max) && (v_max > l_max)) || ...
               ((v_min >= l_min) && (v_max <= l_max)) 
              % => segments i and j overllap 
                index(i,j) = 1;
            elseif (abs(l_min-v_max) < max_dist) || ... 
                   (abs(l_max-v_min) < max_dist)      
              % => segments i,j are close to each other 
                index(i,j) = 1;
            end
        end
    else
       for j=i+1:count
            u_min = C(j,1);
            u_max = C(j,2);
            v_min = min(C(j,3),C(j,4));
            v_max = max(C(j,3),C(j,4));
            if ((u_min < k_min) && (u_max >= k_min))|| ...
               ((u_min <= k_max) && (u_max > k_max)) || ...
               ((u_min >= k_min) && (u_max <= k_max)) 
              % => segments i and j overllap 
                index(i,j) = 1;
            elseif (abs(k_min-u_max) < max_dist) || ... 
                   (abs(k_max-u_min) < max_dist)      
                % => segments i,j are close to each other 
                index(i,j) = 1;
            end
        end 
    end
end

           


