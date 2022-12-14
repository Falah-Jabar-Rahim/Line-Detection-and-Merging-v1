I = imread('lab.bmp');
tic
lineSegments = EDPFLines(I);
toc
noLines = size(lineSegments, 1);

imshow(I);
hold on;

for i = 1:noLines
	plot([lineSegments(i).sx lineSegments(i).ex], [lineSegments(i).sy lineSegments(i).ey]);
end