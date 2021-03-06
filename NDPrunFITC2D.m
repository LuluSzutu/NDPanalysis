function NDPrunFITC2D(IM,Impath,Imfile,Iwidth,Iheight,analysis,thresh)

if isempty(thresh)
    Ifitc = IM(:,:,2);
    Idapi = IM(:,:,3);
    if max(Ifitc(:)) == 255
        nucT = 26;
    elseif max(Ifitc(:)) >= 210 && max(Ifitc(:)) < 255
        nucT = 25;
    elseif max(Ifitc(:)) < 210 && max(Ifitc(:)) >= 130
        nucT = 20;
    else
        nucT = 15;
    end
    f = find(Idapi>=80);
    S = size(f,1)/(size(Idapi,1)*size(Idapi,2));
    if S>0.04
        nucTb = 30;
        nucTb2 = 130;
    elseif S>= 0.02 && S<=0.04
        nucTb = 20;
        nucTb2 = 120;
    else
        nucTb = 8;
        nucTb2 = 110;
    end
    nucT
    nucTb
    nucTb2
else
    nucTb = thresh(1);
    nucTb2 = thresh(2);
    nucT = thresh(3);
end

se1 = strel('disk',20);

[a,b,c] = size(IM);
Fa = floor(a/1000);
Fb = floor(b/1000);
step = 1000;

hgreen = [];
hblue = [];
AveB = [];
AveG = [];
parfor k = 1: (Fa+1).*(Fb+1)
    [m,n] = ind2sub([Fa+1,Fb+1],k);
    x =(m-1).*step;
    y = (n-1).*step;
    SI = [];
    SG = [];
    if m ~= Fa+1 && n ~= Fb+1
        SI = IM(x+1:x+step,y+1:y+step,:);
    elseif m == Fa+1 && n ~= Fb+1
        SI = IM(x+1:end,y+1:y+step,:);
    elseif m ~= Fa+1 && n == Fb+1
        SI = IM(x+1:x+step,y+1:end,:);
    elseif m == Fa+1 && n == Fb+1
        SI = IM(x+1:end,y+1:end,:);
    end
    
    SB = SI(:,:,3);
    OG = SI(:,:,2);
    m = mean(SB(:))./mean(OG(:));
    SB = SB./m;
    p = polyfit(double(SB),double(OG),1);
    pa = p(1);
    pb = p(2);
    W = double(OG)-(pa.*double(SB)+pb);
    W = uint8(W);
    NG = imtophat(W,se1);
    NG(NG<=nucT) = 0;
    
    if max(SI(:)) == 0 && min(SI(:)) == 0
             YD(k).YW= 0;
             XD(k).XW = 0;
             hgreen(k) = 0;
             hblue(k) = 0;
             AveB(k) = 0;
             AveG(k) = 0;
             SumB(k) = 0;
             SumG(k) = 0;
             continue;
    else    
        if analysis(1) == 1
            b = find(SB>nucTb & SB< nucTb2);
            g = find(NG>0);
            hgreen(k) = size(g,1);
            hblue(k) = size(b,1);
        end
        
        if analysis(2) == 1
            b = find(SB>nucTb & SB< nucTb2);
            g = find(NG>0);
            if ~isempty(b)&& ~isempty(g)
                AveB(k) = mean(SB(b));
                AveG(k) = mean(OG(g));
                SumB(k) = sum(SB(b));
                SumG(k) = sum(OG(g));
            elseif ~isempty(b)&& isempty(g)
                AveB(k) = mean(SB(b));
                AveG(k) = 0;
                SumB(k) = sum(SB(b));
                SumG(k) = 0;
            elseif isempty(b)&&~isempty(g)
                AveB(k) = 0;
                AveG(k) = mean(OG(g));
                SumB(k) = 0;
                SumG(k) = sum(OG(g));
            end
        end
                      
        if analysis(3) == 1
            
            minisize = 8;
            CB = medfilt2(SB,[8,8]);
            CG = NG>0;
            CG = imclose(CG,strel('disk',3));
            GG = OG.*uint8(CG);
            [BW,num] = bwlabel(CG);
            stats = regionprops(BW,'Centroid','Area','PixelIdxList','Eccentricity');
            data = [];
            for i = 1:num
                Bp = mean(CB(stats(i).PixelIdxList));
                Gp = mean(GG(stats(i).PixelIdxList));
                if Bp>=15 && Bp<200 && Gp>40 && Gp-Bp>-50 && stats(i).Area>minisize
                    if stats(i).Eccentricity <= 0.80
                        data(end+1,1:2) = stats(i).Centroid;
                    else
                        TM = zeros(size(SG));
                        TM(stats(i).PixelIdxList) = 1;
                        D = bwdist(~TM);
                        D = -D;
                        D(~TM) = -Inf;
                        L = watershed(D);
                        if max(L(:)) > 1                  
                            stats2 = regionprops(L,'Centroid','Area','PixelIdxList');
                            for l = 2:max(L(:))
                                Bp = mean(CB(stats2(l).PixelIdxList));
                                Gp = mean(GG(stats2(l).PixelIdxList));
                                if Bp>=15 && Bp<200 && Gp>40 && Gp-Bp>-50 && stats2(l).Area>minisize
                                    data(end+1,1:2) = stats2(l).Centroid;
                                end
                            end
                        else
                            data(end+1,1:2) = stats(i).Centroid;
                        end
                    end
                end
            end
            if size(data,1)==0
                BlobX = [];
                BlobY = [];
            else
                BlobX = data(:,2);
                BlobY = data(:,1);
            end           
%             BlobX = [];
%             BlobY = [];
%             for l = 1:d
%                 Dis = sqrt((data(:,2) - data(l,2)).^2+(data(:,1)-data(l,1)).^2);
%                 fd = find(Dis<=10);
%                 BlobY(end+1) = round(mean(data(fd,1)));
%                 BlobX(end+1) = round(mean(data(fd,2)));
%                 data(fd,:) = -100;
%                 data(l,1) = round(mean(data(fd,1)));
%                 data(l,2)= round(mean(data(fd,2)));
%             end
%             BlobY = BlobY(find(BlobY>0));
%             BlobX = BlobX(find(BlobX>0));
            YW = BlobY+y;
            XW = BlobX+x;
            YD(k).YW= YW;
            XD(k).XW = XW;
        end
        
        if analysis(4) == 1
            b = find(SB>nucTb & SB< nucTb2);
            hblue(k) = size(b,1);
        end
        
    end   
        
end

ResName = [Imfile(1:end-5),'_FITCfoci.mat'];
Res = fullfile(Impath,ResName);
save(Res,'Iwidth','Iheight');

if analysis(1)==1
    R = sum(hgreen)./sum(hblue) ;
    display('The Green Pixel Number is: ')
    disp(sum(hgreen));
    display('The Blue Pixel Number is: ')
    disp(sum(hblue));
    display('The Green and Blue Pixel Number Ratio is: ')
    disp(R);
end

if analysis(2) == 1    
    fg = find(AveG >0);
    fb = find(AveB >0);
    disp('The Sum Intensity of FITC in selected Area is ');
    disp(sum(SumG(:)));
    disp('The Average Intensity of FITC in selected Area is ');
    disp(mean(AveG(fg)));
    disp('The Sum Intensity of DAPI in selected Area is ');
    disp(sum(SumB(:)));
    disp('The Average Intensity of DAPI stained Neuron Neucli in selected Area is ');
    disp(mean(AveB(fb)));
end

if analysis(3) == 1      
    Xcoord = XD(1).XW;
    Ycoord = YD(1).YW;
    for j = 2:size(XD,2)
        if ~isempty(XD(j).XW)
            Xcoord = [Xcoord;XD(j).XW];
            Ycoord = [Ycoord;YD(j).YW];
        end        
    end
    d = size(Xcoord,1);
    XCOORD = [];
    YCOORD = [];
    for l = 1:d
        Dis = sqrt((Xcoord - Xcoord(l)).^2+(Ycoord - Ycoord(l)).^2);
        fd = find(Dis<= 6);
        XCOORD(end+1) = round(mean(Xcoord(fd)));
        YCOORD(end+1) = round(mean(Ycoord(fd)));
        Xcoord(fd) = -100;
        Ycoord(fd) = -100;
        Xcoord(l) = round(mean(Xcoord(fd)));
        Ycoord(l) = round(mean(Ycoord(fd)));
    end
    XCOORD = XCOORD(find(XCOORD>0));
    YCOORD = YCOORD(find(YCOORD>0));
    
    save(Res,'XCOORD','YCOORD','-append');        
    D = cell(size(XCOORD,2)+1,2);
    D(1,:) = {'Xcoordinate','Ycoordinate'};
    for j = 2:size(XCOORD,2)
        D(j,:) = {XCOORD(j-1),YCOORD(j-1)};
    end
    xlswrite([Res,'Coordinate.xls'],D,'output');
       
    disp('The Number of FITC Foci in selected Area is ');
    disp(size(XCOORD,2));
    
    Tim = imread(fullfile(Impath,Imfile));
    try
        imshow(Tim);
    catch exception
        image(Tim);
    end
    hold on
    plot(Ycoord,Xcoord,'.m','markersize',6);
    saveas(gcf,fullfile(Impath,[Imfile,'_FITCfociPlot.fig']),'fig');
    hold off
    close
end


if analysis(4) == 1
    display('The Estimated Nuclei Number in this region is: ')
    disp(round(sum(hblue)/2249.49));
end

disp('JOB DONE!');

end