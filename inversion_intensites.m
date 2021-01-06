function [rrI,vvI,bbI] = inversion_intensites(rr,vv,bb,N,M)

rrI=zeros(N,M);
vvI=zeros(N,M);
bbI=zeros(N,M);

for i = 1:N
    for j=1:M
        rrI(i,j) = 255 - rr(i,j);
        vvI(i,j) = 255 - vv(i,j);
        bbI(i,j) = 255 - bb(i,j);
    end
end 
end