function el_struc = construction_element_structurant()
% el_struc = construction_element_structurant()
%
% Fonction qui construit l'element structurant 18-connexe.

el_struc = zeros(3,3,3);

el_struc(:,:,2) = ones(3,3);

el_struc(2,:,1) = 1;

el_struc(:,2,1) = 1;

el_struc(2,:,3) = 1;

el_struc(:,2,3) = 1;
end