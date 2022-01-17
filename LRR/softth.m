function E = softth(F,lambda)
%update J
temp = F;
[U S V] = svd(temp, 'econ');
       
diagS = diag(S);
svp = length(find(diagS > lambda));
diagS = max(0,diagS - lambda);
        
if svp < 0.5 %svp = 0
   svp = 1;
end
E = U(:,1:svp)*diag(diagS(1:svp))*V(:,1:svp)'; 