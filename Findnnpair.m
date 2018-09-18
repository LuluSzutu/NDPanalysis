%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [Xnnpair,Xmid] = Findnnpair(Result)

if ~isempty(Result)

    Xnnpair = [];
    fless = find(Result(:,9) <= 12);
    Fless = Result(fless,:);
    for i =1:size(Fless,1)
        num1 = Fless(i,1);
        num2 = Fless(i,5);
        if (num1~=0&&num2~=0)
            locat = find(Fless(:,1) == num2);
            for j = 1:size(locat,1)
                if Fless(locat(j),5) == num1
                    Xnnpair = [Xnnpair; Fless(locat(j),:)];
                    Fless(locat(j),:) = zeros(1,size(Fless,2));
                end
            end
        end
    end
    if isempty(Xnnpair)
        Xmid = [];
    else
        Xmid =[(Xnnpair(:,2)+ Xnnpair(:,6))/2 (Xnnpair(:,3)+ Xnnpair(:,7))/2 (Xnnpair(:,4)+ Xnnpair(:,8))/2];
    end
else
    
   Xnnpair = [];
   Xmid = [];
end

  
