# Introduction

An implemenation of line detection and merging for 2D images.
 1. Detect straight lines in the input image with EDlines [1]. EDLines is an algorithm that aims to extract straight lines in the image based on the image gradient, with a validation step that allows to reduce the number of false detections. 
2. Neighbour lines are connected (lines that are close enough likely belonging to the same image contour) based on the procedure proposed in [2].
3. Short lines that remain after the merging procedure are removed. 
![](https://github.com/jwtyar/Line-detection-and-meging/blob/main/Output.bmp)

# Dependences

- 64-bit Windows
- Microsoft Visual C++ 2012 Redistributable Package (x64)
- Matlab with version > R2015

# Usage
Check the Main.m for some simple tests
# Note
- Line merging and filtering have 4 parameters (Ac, Cc, Lm, Lf), refere to [2] for details about these parameters.
- The parameters Ac, Cc, Lm, Lf may need some tuning for images with diffrent resolutions
# References
[1] C. Akinlar, C. Topal., A. Cuney, T. Cihan, C. Akinlar, and T. Cihan, “EDLines: A Real-Time Line Segment Detector with a False Detection Control,” Pattern Recognit. Lett., vol. 32, no. 13, pp. 1633–1642, Oct. 2011.\
[2] F. Jabar, M.P. Queluz, and J. Ascenso, “Objective Assessment of Line Distortions in Viewport Rendering of 360⸰ Images,” Proc. of the 1st IEEE International Conference on Artificial Intelligence and Virtual Reality, Taichung, Taiwan, Dec. 2018.

