clc;
close all;
clear;
%{
%% Representation histogramme 2D avec donnees 3D

I = imread('peppers.jfif');

I = double(I);
colormap gray;

histogramme2D_avec_donnees3D(I);

%}


%% Créer un scatter plot 3D (histogramme 3D) a partir d'une image RGB

rgbImage = imread('peppers.jfif');

nuage_de_points3D_avec_donnes3D(rgbImage);