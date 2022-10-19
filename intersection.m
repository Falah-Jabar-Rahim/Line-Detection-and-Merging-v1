function X = intersection(m1,b1,m2,b2)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

A = [1 -m1; 1 -m2];
B = transpose([b1 b2]);
X = linsolve(A,B);

end

