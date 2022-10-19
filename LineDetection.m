function  [XS ,YS ,ZS,HL,no_lines,lm,ln]=LineDetection(VP,Par)

% % figure, imshow(VP);
fov_h=Par.Hfov;  %% horzontal FoV
fov_v=Par.Vfov(1,1); %% vertical FoV - only one val
Im_H=Par.V_H; % get VP height    
Im_W=Par.V_W; % get VP width
d=Par.d;
long=Par.longitude;
lat=Par.latitude;
HL=Connect_Seg(VP,Par.dangle,Par.dintercept,Par.max_dist,Par.min_length);
no_lines=length(HL(:,1));

%% =================== Find all points on the sphere(X,Y,Z)for each line ==========================
[XS,YS,ZS,lm,ln]=LinestoSphere(HL,Im_W,Im_H,fov_h,fov_v,no_lines,d,long,lat); %  projected lines on the sphere backward projection

    



