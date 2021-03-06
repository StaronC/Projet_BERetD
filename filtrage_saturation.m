function [rn,vn,bn] = filtrage_saturation(r,v,b)

r = 255 - r;
v = 255 - v;

v_g = fspecial('gaussian', 3);
v_filtre = imfilter(v, v_g, 'replicate');

r_g = fspecial('gaussian', 3);
r_filtre = imfilter(r, r_g, 'replicate');

b_g = fspecial('gaussian', 3);
b_filtre = imfilter(b, b_g, 'replicate');

figure('Position',[100,100,900,400]);
subplot(1,2,1);
plot(-v, r, '.', 'MarkerSize', 0.01, 'Color', 'k')
xlabel('R');
ylabel('V');
title('histogramme original');
subplot(1,2,2);
plot(-v_filtre,r_filtre, '.', 'MarkerSize', 0.01, 'Color', 'k');
xlabel('R');
ylabel('V');
title('histogramme filtr�');

T_r=zeros(1,256);
T_v=zeros(1,256);
T_b=zeros(1,256);

for i=1:256
    if r_filtre(i) ~= 0 || v_filtre(i) ~= 0 || b_filtre(i) ~= 0
       T_r(i) = r_filtre(i);
       T_v(i) = v_filtre(i);
       T_b(i) = b_filtre(i);
    end
end

T_med_r = median(T_r);
T_med_v = median(T_v);
T_med_b = median(T_b);

rn = zeros(256, 1);
vn = zeros(256, 1);
bn = zeros(256, 1);

for i = 1 : 46328
    if r_filtre(i)>T_med_r
        rn(i)= r_filtre(i);
    else
        rn(i)= r_filtre(i)/2;
        
    end
end

for i = 1 : 46328
    if v_filtre(i)>T_med_v
        vn(i)= v_filtre(i);
    else
        vn(i)=v_filtre(i)/2;
    end
    
    if b_filtre(i) > T_med_b
        bn(i)= b_filtre(i);
    else
        bn(i) = b_filtre(i)/2;
    end
end

figure();
plot3(rn, vn, bn, '.', 'MarkerSize', 0.01, 'Color', 'k');
xlabel('R');
ylabel('V');
zlabel('B');
end