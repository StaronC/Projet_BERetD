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

[r,v,b] = nuage_de_points3D_avec_donnees3D(rgbImage);

%% Transformation en échelle logarithmique

[H2r,H2v,H2b] = test_application_log(r,v,b);

%% Lissage de l'histogramme

% imgaussfilt3( ?



%% Creation de l'element structurant et fermeture morphologique

ES = construction_element_structurant();



