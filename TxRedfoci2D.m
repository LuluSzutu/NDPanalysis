function [XD,YD] = TxRedfoci2D(Impath,Imfile,Iwidth,Iheight)

xstep = 1000;
ystep = 1000;
xrange = floor(Iwidth/xstep);
yrange = floor(Iheight/ystep);
EndWidth = xrange*xstep;
EndHeight = yrange*ystep;

se1 = strel('disk',20);
nucT = 25;
nucTb = 10;
nucTb2 = 130;
minisize = 8;

matlabpool

tic
parfor i = 1:(xrange+1)*(yrange+1)
    [X,Y] = ind2sub([xrange+1 yrange+1],i);
    X = (X-1)*xstep;
    Y = (Y-1)*ystep;
    fna = [Imfile,'_',num2str(X,'%d'),'_',num2str(Y,'%d'),'_',num2str(1,'%d'),'.bmp'];
%     filena = fullfile(Impath,fna);
    filena = [Impath fna];
    I = imread(filena);
    R = I(:,:,1);
    B = I(:,:,3);
    m = mean(B(:))./mean(R(:));
    B = B./m;
    p = polyfit(double(B),double(R),1);
    pa = p(1);
    pb = p(2);
    W = double(R)-(pa.*double(B)+pb);
    W = uint8(W);
    NG = imtophat(W,se1);
    fg = find(NG<=nucT);
    NG(fg) = 0;
    CB = medfilt2(B,[8,8]);
    CG = NG>0;
    CG = imclose(CG,strel('disk',3));
    GG = NG.*uint8(CG);
    [BW,num] = bwlabel(CG);
    stats = regionprops(BW,'Centroid','Area','PixelIdxList','Eccentricity');
    data = [];
    for j = 1:num
        Bp = mean(CB(stats(j).PixelIdxList));
        Gp = mean(GG(stats(j).PixelIdxList));
        if Bp>=15 && Bp<200 && Gp>40 && Gp-Bp>-50 && stats(j).Area>minisize
            if stats(j).Eccentricity <= 0.80
                data(end+1,1:2) = stats(j).Centroid;
            else
                TM = zeros(size(NG));
                TM(stats(j).PixelIdxList) = 1;
                D = bwdist(~TM);
                D = -D;
                D(~TM) = -Inf;
                L = watershed(D);
                stats2 = regionprops(L,'Centroid','Area','PixelIdxList');
                for k = 2:max(L(:))
                    Bp = mean(CB(stats2(k).PixelIdxList));
                    Gp = mean(GG(stats2(k).PixelIdxList));
                    if Bp>=15 && Bp<200 && Gp>40 && Gp-Bp>-50 && stats2(k).Area>minisize
                        data(end+1,1:2) = stats2(k).Centroid;
                    end
                end
            end
        end
    end
    d = size(data,1);
    BlobX = [];
    BlobY = [];
    for l = 1:d
        Dis = sqrt((data(:,2) - data(l,2)).^2+(data(:,1)-data(l,1)).^2);
        fd = find(Dis<=10);
        BlobY(end+1) = round(mean(data(fd,1)));
        BlobX(end+1) = round(mean(data(fd,2)));
        data(fd,:) = -100;
        data(l,1) = round(mean(data(fd,1)));
        data(l,2)= round(mean(data(fd,2)));
    end
    BlobY = BlobY(find(BlobY>0));
    BlobX = BlobX(find(BlobX>0));
    YW = BlobY'+Y;
    XW = BlobX'+X;
    YD(i).YW= YW;
    XD(i).XW = XW;
end
toc

matlabpool close