function histogramme2D_avec_donnees3D(img3D)
% histogramme2D_avec_donnees3D(img3D)
%
% Fonction permettant a partir d'une image 3D de representer son
% histogramme 2D

dim = size(img3D);
histo = zeros(256, 256, 256);
for i=1:dim(1)
  for j=1:dim(2)
    r = img3D(i, j, 1)+1;
    g = img3D(i, j, 2)+1;
    b = img3D(i, j, 3)+1;
    histo(r, g, b) = histo(r, g, b) + 1;
  end
end
r = floor(double(img3D(i, j, 1)) * 192 / 256) + 1;

imhist(histo(r, g, b));
histoRG = sum(histo, 3);
histoRB = squeeze(sum(histo, 2));
histoGB = squeeze(sum(histo, 1));

figure();
subplot(2, 2, 1); 
imshow(img3D);
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
end