function [ro,ve,bl] = operation_saturation(r_filt,v_filt,b_filt,N,M)
% operation_saturation(r_filt,v_filt,b_filt,N,M)

% Trouver le seuil de saturation qui est la valeur mediane des valeurs
% differentes de zero

T_r=zeros(N,M);
T_v=zeros(N,M);
T_b=zeros(N,M);

for i=1:N
    for j=1:M
        if r_filt(i,j) ~= 0 && v_filt(i,j) ~= 0 && b_filt(i,j) ~= 0
           T_r(i,j) = r_filt(i,j);
           T_v(i,j) = v_filt(i,j);
           T_b(i,j) = b_filt(i,j);
        end
    end
end

T_med_r = median(T_r);
T_med_v = median(T_v);
T_med_b = median(T_b);

T_med_rr = median(T_med_r);
T_med_vv = median(T_med_v);
T_med_bb = median(T_med_b);

% Application de la saturation
ro = zeros(N,M);
ve = zeros(N,M);
bl = zeros(N,M);

for i = 1 : N
    for j=1:M
        if r_filt(i,j)>T_med_rr
            ro(i,j)= r_filt(i,j);
        else
            ro(i,j)= r_filt(i,j)*0.1;
        end
		
        if b_filt(i,j)>T_med_bb
            bl(i,j)= b_filt(i,j);
        else
            bl(i,j)= b_filt(i,j)*0.1;
        end
		
        if v_filt(i,j)>T_med_vv
            ve(i,j)= v_filt(i,j);
        else
            ve(i,j)= v_filt(i,j)*0.1;
        end
    end
end
end