
% Line detection and merging
% (c) Falah Jabar (falah.jabar@lx.it.pt)

clc, clear 

I=imread('Input.bmp'); %% input image
AC =3; %% angular interval
Cc =3; %% intercept interval
Lm = 10; %% max line distance 
Lf = 30; %% min line length
do_plot =1;  %% do plot or not
Line_merging(I, AC, Cc, Lm,Lf,do_plot)
