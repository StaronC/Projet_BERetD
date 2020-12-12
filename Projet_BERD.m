%{
close all 
clear 

%% Representation histogramme 2D avec donnees 3D

I = imread('peppers.jfif');

%I = double(I);

colormap gray;
dim = size(I);
histo = zeros(256, 256, 256);
for i=1:dim(1)
  for j=1:dim(2)
    r = I(i, j, 1)+1;
    g = I(i, j, 2)+1;
    b = I(i, j, 3)+1;
    histo(r, g, b) = histo(r, g, b) + 1;
  end
end
r = floor(double(I(i, j, 1)) * 192 / 256) + 1;

imhist(histo(r, g, b));
histoRG = sum(histo, 3);
histoRB = squeeze(sum(histo, 2));
histoGB = squeeze(sum(histo, 1));
subplot(2, 2, 1); 
imshow(I);
subplot(2, 2, 2); 
image(histoRG);
xlabel('g');
ylabel('r');
subplot(2, 2, 3); 
image(histoRB);
xlabel('b');
ylabel('r');
subplot(2, 2, 4); 
image(histoGB);
xlabel('b');
ylabel('g');
%}


%% Créer un scatter plot 3D (histogramme 3D) de l'image RGB 'peppers.jfif'

clc;
close all;
clear;

rgbImage = imread('peppers.jfif');
%Obtenir les dimensions de l'image. nbrbandecouleur devra etre egale a 3.
[li, col, nbrbandecouleur] = size(rgbImage);
%visualiser l'image de couleur originale
imshow(rgbImage, 'InitialMagnification', 'fit');
title('Image couleur Originale');

%extraire les couleurs rouge, vert, et bleu inviduellement.
red = rgbImage(:, :, 1);
green = rgbImage(:, :, 2);
blue = rgbImage(:, :, 3);

%construire l'histogramme 3D
hist3D = zeros(li/2,col/2,col/2);
for ligne = 1: li
	for colonne = 1 : col
		rIndex = red(ligne, colonne) + 1;
		vIndex = green(ligne, colonne) + 1;
		bIndex = blue(ligne, colonne) + 1;
		hist3D(rIndex, vIndex, bIndex) = hist3D(rIndex, vIndex, bIndex) + 1;
	end
end

%obtenir une liste de couleurs (r,v,b) =! 0 pour la mettre dans plot3()
%pour qu'on puisse visualiser les couleurs existants

r = zeros(li/2, 1);
v = zeros(li/2, 1);
b = zeros(li/2, 1);
Pixel_diffde_Zero = 1;

for rouge = 1 : li/2
	for vert = 1: li/2
		for bleu = 1: li/2
			if (hist3D(rouge, vert, bleu) > 1)
                %enregistrer la position RGB du couleur.
				r(Pixel_diffde_Zero) = rouge;
				v(Pixel_diffde_Zero) = vert;
				b(Pixel_diffde_Zero) = bleu;
				Pixel_diffde_Zero = Pixel_diffde_Zero + 1;
			end
		end
	end
end

figure();
plot3(r, v, b, '.', 'Color', 'k');
xlabel('R');
ylabel('V');
zlabel('B');