%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function Resultnearest = Findnearest2(XX,YY)

[n,p] = size(XX);
[m,o] = size(YY);

if (p~=o)
    error('Function:findnearest(XX,YY): Dimensions are not match!');
end

Resultnearest = zeros(n,p*2+3);

 for i = 1:n
     dsq2 = zeros(m,1);
     current = XX(i,1:p);
     for q = 1:p
         dsq2 = dsq2+ (current(1,q)- YY(1:m,q)).^2;
     end   
     a = find(dsq2 >0);
     mindis = min(dsq2(a));
     floc = find(dsq2 == mindis);
     if size(floc,1)>1
         floc = floc(1,:);
     end
     Dis = sqrt(dsq2(floc));
     Resultnearest(i,:) = [i XX(i,:) floc YY(floc,:) Dis];     
 end
 