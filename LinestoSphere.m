function [XSS ,YSS ,ZSS,Lm,Ln]=LinestoSphere(B,W,H,fov_h,fov_v,N,d,longt,lat)


%% =================== Find VP size for rectiliner projection ==========================
Vvs=(2*(d+1)*(sind(fov_v/2)))/(d+cosd(fov_v/2));
Vhs=(2*(d+1)*(sind(fov_h/2)))/(d+cosd(fov_h/2));

%% for test *********************************
ERP=rgb2gray(imread('Outd1.jpg'));
[ImgH,ImgW]=size(ERP);


R=rotMat(0,0); % compute the rotation matrix 

%% end for test*****************************



XSS=cell(1,N);
YSS=cell(1,N);
ZSS=cell(1,N);
Lm=cell(1,N);
Ln=cell(1,N);

for k=1:N  %% for each line
    %%  get  pixel position (n,m)
    m=B(k, [3 4]);
    n=B(k, [1 2]);
    
    %% =================== find all ponis for each line ponis=length of line ==========================
    startp=[m(1),n(1)];
    endp=[m(2),n(2)];
    [m,n]=FFilllline(startp,endp,floor(B(k,5)));  %% find all ponits on the line
    
    %% =================== Test plot ==========================
%      figure(1), hold off, imshow(I)
%      line( m,n,'Color','green','LineStyle','-','LineWidth',2)
    
    %% =================== find X,Y,Z for each line points  on the sphere  ==========================
         
    x1=zeros(1,floor(B(k,5)));
    y1=zeros(1,floor(B(k,5)));
    z1=zeros(1,floor(B(k,5)));
    for  j=1:floor(B(k,5)) % length of the line
        % compute u and v
        u=((m(j)-1)+0.5)*(Vhs/W);
        v=((n(j)-1)+0.5)*(Vvs/H);
        %compute x and y
        x=u-(Vhs/2);
        y=-v+(Vvs/2);
        a=x^2+y^2+2*d+d^2+1;
        b=-(2*d+2*d^2);
        c=d^2-1;
        u1=(-b+sqrt(b^2-4*a*c))/(2*a);
        if (isreal(u1))
        else
            u1=real(u1);
        end
        % compute X,Y,Z on the sphere
        x1(j)=u1*x;
        y1(j)=u1*y;
        z1(j)=-d+(u1*(1+d));
        
          p1= [x1(j) ;y1(j) ;z1(j)];
          p=R*p1;         
          x1(j)=p(1);
          y1(j)=p(2);
          z1(j)=p(3);
        %% for  test    
%         p1= [x1(j);y1(j) ;z1(j)];
%         p=R*p1;
        phi=atan2(p(1),p(3));
        theta=atan2(p(2),(sqrt(p(1)^2+p(3)^2)));       
        m_erp=ImgW*(0.5+ phi/(2*pi))-0.5;     %    8192       get the location of Y component  on the orignal image
        n_erp=ImgH*(0.5-theta/pi)-0.5;
        m_erp=floor(m_erp);
        n_erp=floor(n_erp);
        
        if m_erp<=0 
           m_erp=1; 
        end
        if n_erp<=0 
           n_erp=1; 
        end
        ERP(n_erp,m_erp)=255;
    %% end for test 
    end
         % save X,Y,Z for each line
         XSS{1,k}=x1;
         YSS{1,k}=y1;
         ZSS{1,k}=z1;
         Lm{1,k}=m;
         Ln{1,k}=n;

clear j;
clear x1 y1 z1 ;

end

%  figure, imshow(ERP);
