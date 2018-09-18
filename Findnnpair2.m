 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 function [Xnnpair,Xmid] = Findnnpair2(FTresult,TFresult)

Xnnpair = [];
fless = find(FTresult(:,9)<=12);
FTless = FTresult(fless,:);
fless2 = find(TFresult(:,9)<=12);
TFless = TFresult(fless2,:);

for i =1:size(FTless,1)
    num1 = FTless(i,1);
    num2 = FTless(i,5);
    if (num1~=0&&num2~=0)
        locat = find(TFless(:,1) == num2);
        for j = 1:size(locat,1)
            if TFless(locat(j),5) == num1
                Xnnpair = [Xnnpair;FTless(i,:)];
%                 FTless(locat(j),:) = zeros(1,size(FTless,2));
            end
        end
    end
end

if isempty(Xnnpair)
    Xmid = [];
else
    Xmid =[(Xnnpair(:,2)+ Xnnpair(:,6))/2 (Xnnpair(:,3)+ Xnnpair(:,7))/2 (Xnnpair(:,4)+ Xnnpair(:,8))/2];
end