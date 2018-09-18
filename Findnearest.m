%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function Res = Findnearest(XX)

[n,p] = size(XX);

if ~isempty(n)&~isempty(p)
    Res = zeros(n,(p*2+3));
    if n > 1
        for i = 1:n
            dsq = zeros(n,1);
            current = XX(i,1:p);
            for q = 1:p
                dsq = dsq + (current(1,q) - XX(1:n,q)).^2;
            end
            a = find(dsq >0);
            mindis = min(dsq(a));
            floc = find(dsq == mindis);
            if size(floc,1)>1
                floc = floc(1,:);
            end
            Dis = sqrt(dsq(floc));
            Res(i,:) = [i XX(i,1:p) floc XX(floc,1:p) Dis];
        end
    end
else
    Res = [];    
end

    

