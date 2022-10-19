function R=Line_rotMat(phi,thi)
 phi=phi*pi/180;
 thi=thi*pi/180;

R=zeros(3,3);
% R=[cos(phi), -sin(phi)*sin(thi), sin(phi)*cos(thi) ;
%     0      , cos(thi)          , sin(thi)               ;
%   sin(thi) ,  sin(thi)         , cos(phi)*cos(thi)];


% R=[cos(phi), -sin(phi)*sin(thi), sin(phi)*cos(thi) ;
%     0           , cos(thi)               , sin(thi)               ;
%   -sin(phi-pi/2), -cos(phi-pi/2)*sin(thi), cos(phi-pi/2)*cos(thi)];


% % rotation matrix acording to MPEG
R=[cos(phi), -sin(phi)*sin(thi), sin(phi)*cos(thi) ;
    0           , cos(thi)               , sin(thi)               ;
  -sin(phi), -cos(phi)*sin(thi), cos(phi)*cos(thi)];
end 