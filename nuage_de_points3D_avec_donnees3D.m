function [r,v,b] = nuage_de_points3D_avec_donnees3D(img3D)
% nuage_de_points3D_avec_donnees3D(img3D)
%
% Fonction permettant de creer un nuage de points 3D a partir d'une image
% RGB

[li, col, ~] = size(img3D);
%visualiser l'image de couleur originale
imshow(img3D, 'InitialMagnification', 'fit');
title('Image couleur Originale');

% extraire les couleurs rouge, vert, et bleu inviduellement.
red = img3D(:, :, 1);
green = img3D(:, :, 2);
blue = img3D(:, :, 3);

% construction de l'histogramme 3D
hist3D = zeros(li/2,col/2,col/2);
for ligne = 1: li
	for colonne = 1 : col
		rIndex = red(ligne, colonne) + 1;
		vIndex = green(ligne, colonne) + 1;
		bIndex = blue(ligne, colonne) + 1;
		hist3D(rIndex, vIndex, bIndex) = hist3D(rIndex, vIndex, bIndex) + 1;
	end
end

% obtenir une liste de couleurs (r,v,b) =! 0 pour la mettre dans plot3()
% pour qu'on puisse visualiser les couleurs existants

r = zeros(li/2, 1);
v = zeros(li/2, 1);
b = zeros(li/2, 1);
Pixel_diffde_Zero = 1;

for rouge = 1 : li/2
	for vert = 1: li/2
		for bleu = 1: li/2
			if (hist3D(rouge, vert, bleu) > 1)
                %enregistrer la position RGB de la couleur.
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
end