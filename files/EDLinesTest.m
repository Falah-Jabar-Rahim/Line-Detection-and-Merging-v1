
function lineSegments=EDLinesTest(I)
tic
lineSegments = EDLines(I, 1);
toc
noLines = size(lineSegments, 1)
