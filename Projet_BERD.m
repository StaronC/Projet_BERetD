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
r = floor(double(img(i, j, 1)) * 192 / 256) + 1;

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