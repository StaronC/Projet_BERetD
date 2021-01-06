close all;
clear;

%% Lecture et affichage de l'image

% Selectionner parmi les images suivantes : 
% rgbImage = imread('tom&jerry.jpg');
% rgbImage = imread('tigre.jpg');
% rgbImage = imread('zebre.jpg');
% rgbImage = imread('peppers.jfif');
% rgbImage = imread('baboon.png');

rgbImage = imread('peppers.jfif');

rgbImage = imresize(rgbImage,[512,512]);

rgbImage = double(rgbImage);

%visualiser l'image de couleur originale
imshow(uint8(rgbImage));
title('Image Couleur Originale');


%extraire les couleurs rouge, vert, et bleu inviduellement.
rouge = rgbImage(:, :, 1);
vert = rgbImage(:, :, 2);
bleu = rgbImage(:, :, 3);

%{
% Cette figure affiche les 3 dimensions Rouge Vert et Bleue de l'image
figure('Position',[100,100,900,400]);
subplot(1,3,1);
imshow(uint8(rouge));
title('image rouge');
subplot(1,3,2);
imshow(uint8(vert));
title('image vert');
subplot(1,3,3);
imshow(uint8(bleu));
title('image bleu');
%}

%Histogramme 3D
figure();
plot3(rouge, vert, bleu, '.', 'MarkerSize', 0.01, 'Color', 'k');
title('Histogramme 3D')
xlabel('R');
ylabel('V');
zlabel('B');

%% Etape 1 : Application du logarithme

%Application du logarithme pour modifier la dynamique et rehausser les
%faibles valeurs de l histogramme
[m,n]=size(rouge);

[rr,vv,bb] = transformation_logarithmique(rouge,vert,bleu,n,m);

%% Etape 2 : Inversion des intensités

[rrI,vvI,bbI] = inversion_intensites(rr,vv,bb,n,m);

% Nous affichons  sur l'axe des abscisse "l'inverse" du tableau des valeurs
% contenant les intensitées vertes et en ordonnée celle du rouge pour que
% nous puissions comparer cette figure avec celle figurant dans l'article.

figure();
plot(-vvI,rrI, '.', 'MarkerSize', 0.01, 'Color', 'k');
title('Projection (rouge vert) apres changement de dynamique ')
xlabel('R');
ylabel('V');


%Visualisation de l image apres changement de la dynamique

image_inv =cat(3,rrI,vvI,bbI);
%{
% Figure montrant l'image après changement de la dynamique
figure();
imshow(uint8(image_inv));
title('Image apres changement de dynamique ')
%}

%% Etape 3 : Filtrage gaussien

% Creation d'un noyau gaussien 

% Noyau gaussien pour images 2D (Rouge,Vert et Bleu)

x=-ceil(100/2):ceil(100/2);
H=exp(-(x.^2/(2*3^2)));
H=H/sum(H(:));
Hx=reshape(H,[length(H) 1]);
Hy=reshape(H,[1 length(H)]);

%Filtrage gaussien de l image 3D
ifiltre = imfilter(imfilter(image_inv,Hx,'same','replicate'),...
    Hy,'same','replicate');

% On peut aussi mettre 
%ifiltre = imgaussfilt3(image_inv,3);

%{
% Figure montrant l'image après filtrage gaussien
figure();
imshow(uint8(ifiltre));
title('Image apres le filtrage gaussien');
%}

r_filtre = ifiltre(:, :, 1);
v_filtre = ifiltre(:, :, 2);
b_filtre= ifiltre(:, :, 3);

figure();
plot(-v_filtre,r_filtre, '.', 'MarkerSize', 0.01, 'Color', 'k');
xlabel('R');
ylabel('V');
title('histogramme après filtrage gaussien');

%% Etape 4 : Saturation

[ro,ve,bl] = operation_saturation(r_filtre,v_filtre,b_filtre,n,m);

image_sat =cat(3,ro,ve,bl);

%{
% Figure montrant l'image après saturation
figure();
imshow(uint8(image_sat));
title('Image apres saturation');
%}

%% Etape 5 : Fermeture morphologique

% Creation de l element structurant 3D
ES = construction_element_structurant();

% Application de la fermeture morphologique

image_close=imclose(image_sat,ES);   
%{
% Figure montrant l'image après fermeture morphologique
figure();
imshow(uint8(image_close));
title('Image apres fermeture morphologique');
%}

%% Etape 6 : Application LPE

imseg=watershed(image_close);
figure();
imshow(uint8(imseg));
title('Application de l''algorithme LPE');

imbin=im2bw(uint8(image_close));
imagef=imfuse(uint8(rgbImage),uint8(imbin),'blend');
figure();
imshow(imagef);
title('Image apres pretraitement');
%figure();
%imshow(imbin);
imageLPE=imfuse(uint8(rgbImage),uint8(imseg),'blend');
figure();
imshow(imageLPE);
title('Image originale + application du LPE');

%%%%%HISTOGRAMME%%%%%%%%%

%{
% Figure affichant l'histogramme 2D
dim = size(rgbImage);
img=uint8(rgbImage);
histo = zeros(256, 256, 256);
for i=1:dim(1)
  for j=1:dim(2)
    r = img(i, j, 1)+1;
    g = img(i, j, 2)+1;
    b = img(i, j, 3)+1;
    histo(r, g, b) = histo(r, g, b) + 1;
  end
end
%r = floor(double(img(i, j, 1)) * 192 / 256) + 1;
histoRG = sum(histo, 3);
%histoRB = squeeze(sum(histo, 2));
%histoGB = squeeze(sum(histo, 1));
figure();
subplot(1, 2, 1); imshow(img);
subplot(1, 2, 2); image(histoRG);xlabel('g');ylabel('r');
%}