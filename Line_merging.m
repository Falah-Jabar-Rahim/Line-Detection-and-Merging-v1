
function Line_merging(I,dangle,dintercept,max_dist, min_length,plot_flag )


% Line detection and merging
% (c) Falah Jabar (falah.jabar@lx.it.pt)

%% =================== Detect lines using EDLine method   ==========================
lines=EDLinesTest(I);
%% Get all line end points
sX=cell2mat({lines.sx})';   %% X1
sY=cell2mat({lines.sy})';   %% Y1
eX=cell2mat({lines.ex})';   %% X2
eY=cell2mat({lines.ey})';   %% Y2
%% =================== store all lines   ==========================
A=[ sY sX eY eX]; %  line matrix
N =length(A(:,1));  % number of lines
%% =================== plote all detected lines over the image   ==========================
if plot_flag
    subplot(1,2,1); imshow(I); hold on;
    for i=1:N
        plot( A(i, [2 4]),  A(i, [1 3]),'-g','LineWidth',2);
    end
    title('Detected lines with EDline');  
end
% ====================================================
final_seg = zeros(N,8);
clusters_p = zeros(N,1);
clusters_c = zeros(N,1);
%% =================== Compelete line informations  ==========================
B = complete_segments_info_initial(A,N,dangle);
%% =================== Line merging  ==========================
for n_iterations=1:5
    C = sortrows(B,6); %%Sort lines in ascending order of the slope (in angle)
    B = C;
    %Find line groups with similar slope (i.e., parallel lines)
    %ngroups_p: number of groups of parallel lines
    %clusters_p: vector with the size of each group
    count = 1;
    ngroups_p = 1;
    pos_init = 1;
    clusters_p(1) = count;
    for i=2:N
        dif_slope = abs(B(i,6)-B(pos_init,6));
        if dif_slope < dangle
            count = count+1;
        else
            clusters_p(ngroups_p) = count;
            ngroups_p = ngroups_p+1;
            count = 1;
            pos_init = i;
        end
    end
    clusters_p(ngroups_p) = count;  
    %For each group of parallel lines, sort them by intercept value
    i_ini = 1;
    for i=1:ngroups_p
        i_end = i_ini+clusters_p(i)-1;
        if clusters_p(i)~= 1
            if abs(B(i_ini,6)) < 45         
                C = sortrows(B(i_ini:i_end,:),7); % Use the intercept with the yy axis
            else          
                C = sortrows(B(i_ini:i_end,:),8); % Use the intercept with the xx axis
            end
            B(i_ini:i_end,:)=C;
        end
        i_ini = i_end + 1;
    end
    
    %For each group of paralell lines, find sub-groups of lines with
    %similar intercept  (i.e., colinear lines)
    %ngroups_c: number of groups of colinear lines
    %clusters_c: vector with the size of each group
    count = 1;
    ngroups_c = 0;
    j_end = 0;
    pos_init = 1;
    for i=1:ngroups_p
        j_ini = j_end+1;
        j_end = j_ini+clusters_p(i)-1;
        if clusters_p(i)~= 1
            for j=j_ini+1:j_end
                if abs(B(j_ini,6)) < 45              
                    dif_intercept = abs(B(j,7)-B(pos_init,7));% Use the intercept with the yy axis
                else                
                    dif_intercept = abs(B(j,8)-B(pos_init,8)); % Use the intercept with the xx axis
                end
                if dif_intercept < dintercept
                    count = count+1;
                else
                    ngroups_c = ngroups_c+1;
                    clusters_c(ngroups_c) = count;
                    count = 1;
                    pos_init = j;
                end
            end
            ngroups_c = ngroups_c+1;
            clusters_c(ngroups_c) = count;
            count = 1;
            pos_init = j+1;
        else
            ngroups_c = ngroups_c+1;
            clusters_c(ngroups_c) = 1;
            pos_init = j_end+1;
        end
    end
    
    % Merge colinear segments that are close to each one
    % final_seg: matrix with the final segments, after merging
    % n_seg: number of segments after merging
    n_seg = 0;
    j_end=0;
    for i=1:ngroups_c
        
        j_ini = j_end+1;
        j_end = j_ini+clusters_c(i)-1;
        count = clusters_c(i);
        if count == 1         
            n_seg=n_seg+1; %cluster with only one segment
            final_seg(n_seg,:) = B(j_ini,:);
        else           
            C = B(j_ini:j_end,:); %cluster with more than one segment => merge segments if possible
            index = indices_for_merge(C,count,max_dist);
            [new_C,new_count,flag_merge] = merge(C,index,count);
            while (flag_merge == 1)
                C = new_C;
                count = new_count;
                index = indices_for_merge(C,count,max_dist);
                [new_C,new_count,flag_merge] = merge(C,index,count);               
                if (flag_merge == 1)
                end            
            end
            final_seg((n_seg+1):(n_seg+count),:) = C(1:count,:);
            n_seg = n_seg + count;
        end
    end   
    % Compute length, slope, intercep with yy and xx axis of resulting segments
    B = complete_segments_info_final(final_seg,n_seg); 
    
  %% =================== Line filtering  ==========================
    j=0;
    for i=1:n_seg
        if B(i,5) >= min_length
            j = j+1;
            C(j,:)=B(i,:);
        end
    end
    n_seg = j;
    B = C(1:n_seg,:);
    N = n_seg;
end

%% ===============  plote all merged lines  after merged   =======================  %%
if plot_flag
    subplot(1,2,2); imshow(I); hold on;
    for i=1:length(B(:,1))
        plot(B(i, [3 4]), B(i, [1 2]),'-g','LineWidth',2);
    end
    title('After merging & filtering');
end
%% ===============   END  =======================  %%





