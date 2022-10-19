I = imread('lab.bmp');

tic
edgeSegments = EDPF(I, 1);
noOfSegments = size(edgeSegments, 1);
toc
imshow(I);
hold on;

for i = 1:noOfSegments
	for j = 1:size(edgeSegments{i}, 1)
		plot(edgeSegments{i}(j, 1), edgeSegments{i}(j, 2));
	end
end
