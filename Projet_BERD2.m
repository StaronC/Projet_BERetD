close all;
clear;

%% Lecture et affichage de l'image

rgbImage = imread('peppers.jfif');
rgbImage = double(rgbImage);
%Obtenir les dimensions de l'image. nbrbandecouleur devra etre egale a 3.
%[lignes, colonnes, nbrbandecouleur] = size(rgbImage);
%visualiser l'image de couleur originale
imshow(uint8(rgbImage));
%imshow(rgbImage, 'InitialMagnification', 'fit');
title('Image Couleur Originale');
%Elargir la figure pour qu'elle occupe toute l'écran
set(gcf, 'units','normalized','outerposition',[0 0 1 1]);

%% Extraction et affichage de 3 dimensions de l'image

%extraire les couleurs rouge, vert, et bleu inviduellement.
rouge = rgbImage(:, :, 1);
vert = rgbImage(:, :, 2);
bleu = rgbImage(:, :, 3);

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

%////////////////////////////////// ETAPE 1////////////////////////////////

%% Création de l'histogramme 3D
%Histogramme 3D
figure(4);
plot3(rouge, vert, bleu, '.', 'MarkerSize', 0.01, 'Color', 'k');title('Histogramme 3D')
xlabel('R');
ylabel('V');
zlabel('B');

%% Application du logarithme

%Application du logarithme pour modifier la dynamique et rehausser les
%faibles valeurs de l histogramme
[m,n]=size(rouge);
rr=zeros(m,n);
vv=zeros(m,n);
bb=zeros(m,n);

for i = 1:m
        Mr= max(log(1+rouge));
      
        rr(i,:) = Mr-log(1+rouge(i,:));
        
        Mv= max(log(1+vert));
      
        vv(i,:) = Mv-log(1+vert(i,:)); 
        
        Mb= max(log(1+bleu));
       
        bb(i,:) = Mb-log(1+bleu(i,:));
end 

%% Application de l inversion de la dynamique

rrI=zeros(m,n);
vvI=zeros(m,n);
bbI=zeros(m,n);

for i = 1:m
    for j=1:n
        rrI(i,j) = 255 - rr(i,j);
        vvI(i,j) = 255 - vv(i,j);
        bbI(i,j) = 255 - bb(i,j);
    end
end 

figure(5);
H1_modifier = plot(rrI,vvI, '.', 'MarkerSize', 0.01, 'Color', 'k');
title('Projection (rouge vert) apres changement de dynamique ')
xlabel('R');
ylabel('V');


%Visualisation de l image apres changement de la dynamique
image_inv =cat(3,rrI,vvI,bbI);
figure(6);
imshow(uint8(image_inv));
title('Image apres changement de dynamique ')

%% Application du filtrage gaussien 3D

%///////////////////////////  ETAPE 2     /////////////////////////////////

%Creation d'un noyau gaussien 
%{
x=-ceil(100/2):ceil(100/2);
H=exp(-(x.^2/(2*3^2)));
H=H/sum(H(:));
Hx=reshape(H,[length(H) 1]);
Hy=reshape(H,[1 length(H)]);
%}
%Filtrage gaussien de l image 
ifiltre=imgaussfilt3(image_inv,3);
%imfilter(imfilter(image_inv,Hx,'same','replicate'),Hy,'same','replicate');
figure(7);
imshow(uint8(ifiltre));
title('Image apres le filtrage gaussien');

%% Opération de saturation

%//////////////////////////  ETAPE 3  /////////////////////////////////////

[lignes, colonnes, nbrbandecouleur] = size(ifiltre);
r_filtre = ifiltre(:, :, 1);
v_filtre = ifiltre(:, :, 2);
b_filtre= ifiltre(:, :, 3);

%Trouver le seuil de saturation qui est la valeur mediane des valeurs
%differentes de zero
T_r=zeros(n,m);
T_v=zeros(n,m);
T_b=zeros(n,m);

for i=1:n
    for j=1:m
        if r_filtre(i,j) ~= 0 && v_filtre(i,j) ~= 0 && b_filtre(i,j) ~= 0
           T_r(i,j) = r_filtre(i,j);
           T_v(i,j) = v_filtre(i,j);
           T_b(i,j) = b_filtre(i,j);
        end
    end
end
T_med_r = median(T_r);
T_med_v = median(T_v);
T_med_b = median(T_b);

T_med_rr = median(T_med_r);
T_med_vv = median(T_med_v);
T_med_bb = median(T_med_b);

%Application de la saturation
ro = zeros(n,m);
ve = zeros(n,m);
bl = zeros(n,m);
for i = 1 : n
    for j=1:m
        if r_filtre(i,j)>T_med_rr
            ro(i,j)= r_filtre(i,j);
        else
            ro(i,j)= r_filtre(i,j)*0.1;
        end
		
        if b_filtre(i,j)>T_med_bb
            bl(i,j)= b_filtre(i,j);
        else
            bl(i,j)= b_filtre(i,j)*0.1;
        end
		
        if v_filtre(i,j)>T_med_vv
            ve(i,j)= v_filtre(i,j);
        else
            ve(i,j)= v_filtre(i,j)*0.1;
        end
    end
end

figure(8);
plot3(ro, ve, bl, '.', 'MarkerSize', 0.01, 'Color', 'k');
xlabel('R');
ylabel('V');
zlabel('B');

figure(9);
plot(-ve,ro, '.', 'MarkerSize', 0.01, 'Color', 'k');
xlabel('R');
ylabel('V');
title('hist seuillé');

%Visualiser l image apres application de la saturation
image_sat =cat(3,ro,ve,bl);
figure(10);
imshow(uint8(image_sat));
title('Image apres saturation');

%% Fermeture morphologique

%Creation de l element structurant 3D
ES = construction_element_structurant();

%Application de la fermeture morphologique
image_close=imclose(image_sat,ES);   
figure(11);
imshow(uint8(image_close));title('Image apres fermeture morphologique');

%% Application de l'algorithme LPE

%////////////////////// ETAPE 4 ///////////////////////////////////////////

%Application de l 'algorithme du LPE
imseg=watershed(image_close);
figure(12);
imshow(uint8(imseg));
title('LPE');


%////////////////////// ETAPE 5 /////////////////////////////////////////

imbin=im2bw(uint8(image_close));
imagef=imfuse(uint8(rgbImage),uint8(imbin),'blend');
figure(13);
imshow(imagef);title('Image apres pretraitement');
%figure();
%imshow(imbin);
imageLPE=imfuse(uint8(rgbImage),uint8(imseg),'blend');
figure(14);
imshow(imageLPE);title('Image apres application du LPE');

%%%%%HISTOGRAMME%%%%%%%%%

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
figure(222)
subplot(1, 2, 1); imshow(img);
subplot(1, 2, 2); image(histoRG);xlabel('g');ylabel('r');
