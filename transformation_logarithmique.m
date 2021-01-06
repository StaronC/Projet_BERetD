function [tab_r,tab_v,tab_b] = transformation_logarithmique(rouge,vert,bleu,...
    N,M)

tab_r=zeros(N,M);
tab_v=zeros(N,M);
tab_b=zeros(N,M);

for i = 1:N
        Mr= max(log(1+rouge));
      
        tab_r(i,:) = Mr-log(1+rouge(i,:));
        
        Mv= max(log(1+vert));
      
        tab_v(i,:) = Mv-log(1+vert(i,:)); 
        
        Mb= max(log(1+bleu));
       
        tab_b(i,:) = Mb-log(1+bleu(i,:));
end 
end