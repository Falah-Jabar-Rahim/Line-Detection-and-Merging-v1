function B = complete_segments_info_initial(A,N,dangle)
% For each segment in A, this function computes its length, slope (in angle), 
% intercept with yy axis and intercept with xx axis

B = zeros(N,8);
B(1:N,1:4) = A(1:N,1:4);

for i=1:N
    % Rearrange the coordinates of the segments end-points
    % B(i,1): lowest i coordinate
    % B(i,2): highest i coordinate
    % B(i,3): j coordinate corresponding to B(i,1)
    % B(i,4): j coordinate corresponding to B(i,2)
        if (A(i,1) > A(i,3))
            B(i,1)=A(i,3);
            B(i,2)=A(i,1);
            B(i,3)=A(i,4);
            B(i,4)=A(i,2);
        elseif (A(i,1) < A(i,3))
            B(i,2)=A(i,3);
            B(i,3)=A(i,2);
        else
            if (A(i,2) > A(i,4))
                B(i,1)=A(i,3);
                B(i,2)=A(i,1);
                B(i,3)=A(i,4);
                B(i,4)=A(i,2);
            else
                B(i,2)=A(i,3);
                B(i,3)=A(i,2);
            end
        end
    
    %Compute the line length and store it in B(i,5)   
    B(i,5)=sqrt((B(i,1)-B(i,2))^2 + (B(i,3)-B(i,4))^2);
    
    %Compute the line slope (in angle) and the line intercept relatively to
    %the yy (i) axis; store it in B(i,6) and B(i,7), respectively
    y = B(i,1:2);
    x = B(i,3:4);
    if (x(1) ~= x(2))
        c = [[1; 1]  x(:)]\y(:);  
        B(i,6) = atan(c(2))*180/pi;
        B(i,7) = c(1);
    else
        B(i,6) = 90;
        B(i,7) = inf;
    end
    
    %Compute the line intercept relatively to the xx (j) axis and store it
    %in B(i,8)
    if (y(1) ~= y(2))
        c = [[1; 1]  y(:)]\x(:);  
        B(i,8) = c(1);
    else
        B(i,8) = inf;
    end
    
    % if the slope (in angle) is close to -90, it is changed to +90
    if B(i,6) < -90+dangle
        B(i,6) = 90;
    end   
end

end

