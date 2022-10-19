
function lineSegments=EDLinesTest(I)
% I = imread('lab.bmp');


%% erp image
%  I=imread('p17.jpg');

% I=imread('Seq1_Vp3_p1_110.bmp');
% I=imread('Seq3_Vp3_p1_110.bmp');
%    I=imread('Seq2_Vp1_p1_110.bmp');
% I = imread('Seq_P39_Vp1_p1_110.bmp');

% I=rgb2gray(I);

tic
lineSegments = EDLines(I, 1);

toc
noLines = size(lineSegments, 1)

% imshow(I);
% hold on;

% for i = 1:noLines
%     
%     
% % %     
% %      x=[lineSegments(i).sx lineSegments(i).ex];
% %    y=[lineSegments(i).sy lineSegments(i).ey];
% % % %    tic
% %     h=imdistline(gca,x,y);
% % %     toc
% %      setLabelVisible(h,false) 
% %     dist = h.getDistance();
% %     delete(h);
% % %      lines(i,5)=dist;
% %      
% % 
% %         if dist>=25
% 
% 	    plot([lineSegments(i).sx lineSegments(i).ex], [lineSegments(i).sy lineSegments(i).ey],'g-','LineWidth',1);
% %         end
% end