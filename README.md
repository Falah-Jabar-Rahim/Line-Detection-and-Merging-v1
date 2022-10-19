# Line-detection-and-meging

An implemenation of line detection and merging for 2D images.
 1. Detect straight lines in the input image with EDlines method [1]. EDLines is an algorithm that aims to extract straight lines in the image based on the image gradient, with a validation step that allows to reduce the number of false detections. 
2. Neighbour lines are connected (lines that are close enough, thus likely belonging to the same image contour) based on the procedure proposed in [2].
3. Short lines that remain after the merging procedure are removed. 
![](https://github.com/jwtyar/Line-detection-and-meging/blob/main/Output.bmp)
