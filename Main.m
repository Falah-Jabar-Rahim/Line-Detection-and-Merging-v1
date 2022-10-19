
% Line detection and merging
% (c) Falah Jabar (falah.jabar@lx.it.pt)

clc, clear 

I=imread('Input.bmp'); %% input image
dangle =3; %% angular interval
dintercept =3; %% intercept interval
max_dist = 10; %% max line distance 
min_length = 30; %% min line length
do_plot =1;  %% do plot or not
Line_merging(I, dangle, dintercept, max_dist,min_length,do_plot)
