function [r_H2, v_H2, b_H2] = test_application_log( r,v,b )

%On suppose que la fonction 'nuage_de_points3D_avec_donnees3D' renvoie les
%vecteurs r,v et b aue l'on r�utilise ici

dim = size(r);
som = zeros(dim);
r_H2 = zeros(dim);
v_H2 = zeros(dim);
b_H2 = zeros(dim);

% Etant donn� que je ne vois pas la fa�on dont c peut etre consid�r� comme
% un scalaire pour la transformation en H2, je consid�re chaque �l�ment de
% H1 comme caract�ris� par un vecteur de taille [1,3] tel que H1(c)=[r,v,b]

for i = 1: dim(1)
    som(i) = som(i)+r(i)+ v(i)+ b(i);
end

% On trouve la valeur de M, en cherchant le max du vecteur sum
[x,~]=find(som==max(som));
M = log1p([r(x),v(x),b(x)]);

%On execute l'op�ration donn�e dans le poly
for i = 1: dim(1)   
    r_H2(i) = M(1)-log1p(r(i));
    v_H2(i) = M(2)-log1p(v(i));
    b_H2(i) = M(3)-log1p(b(i));
end

figure();
plot3(r_H2, v_H2, b_H2, '.', 'Color', 'k');
xlabel('R');
ylabel('V');
zlabel('B');

end

%Vous verrez que le r�sultats obtenus semble incorrect, si vous avez des
%id�es pour le c ditent moi

