function el_struc = construction_element_structurant()
% el_struc = construction_element_structurant()
%
% Fonction qui construit l'element structurant 18-connexe.

struc = zeros(3,3,3);

struc(:,:,2) = ones(3,3);

struc(2,:,1) = 1;

struc(:,2,1) = 1;

struc(2,:,3) = 1;

struc(:,2,3) = 1;

el_struc = strel(struc);

end