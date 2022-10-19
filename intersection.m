function X = intersection(m1,b1,m2,b2)

% Line detection and merging
% (c) Falah Jabar (falah.jabar@lx.it.pt)

A = [1 -m1; 1 -m2];
B = transpose([b1 b2]);
X = linsolve(A,B);

end

