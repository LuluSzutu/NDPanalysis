function NDPrunDouble2D(IM,Impath,Imfile,Iwidth,Iheight,analysis,thresh)

if isempty(thresh)
    Ifitc = IM(:,:,2);
    Idapi = IM(:,:,3);
    Itxred = IM(:,:,1);
    if max(Ifitc(:)) == 255
        Gthresh = 26;
    elseif max(Ifitc(:)) >= 210 && max(Ifitc(:)) < 255
        Gthresh = 25;
    elseif max(Ifitc(:)) < 210 && max(Ifitc(:)) >= 130
        Gthresh = 20;
    else
        Gthresh = 15;
    end
    if max(Itxred(:)) == 255
        Rthresh = 26;
    elseif max(Itxred(:)) >= 210 && max(Ifitc(:)) < 255
        Rthresh = 25;
    elseif max(Itxred(:)) < 210 && max(Ifitc(:)) >= 130
        Rthresh = 20;
    else
        Rthresh = 15;
    end
    f = find(Idapi>=80);
    S = size(f,1)/(size(Idapi,1)*size(Idapi,2));
    if S>0.04
        Bthresh_low = 30;
        Bthresh_high = 130;
    elseif S>= 0.02 && S<=0.04
        Bthresh_low = 20;
        Bthresh_high = 120;
    else
        Bthresh_low = 8;
        Bthresh_high = 110;
    end
    Bthresh_low
    Bthresh_high
    Gthresh
    Rthresh
else
    Bthresh_low = thresh(1);
    Bthresh_high = thresh(2);
    Gthresh = thresh(3);
    Rthresh = thresh(4);
end

[a,b,c] = size(IM);
Fa = floor(a/1000);
Fb = floor(b/1000);
step = 1000;

hgreen = [];
hblue = [];
hred = [];
AveB = [];
AveG = [];
AveR = [];

parfor k = 1: (Fa+1).*(Fb+1)
    se1 = strel('disk',20);
    [m,n] = ind2sub([Fa+1,Fb+1],k);
    x =(m-1).*step;
    y = (n-1).*step;
    SI = [];
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
    OR = SI(:,:,1);
    m = mean(SB(:))./mean(OG(:));
    SB = SB./m;
    p = polyfit(double(SB),double(OG),1);
    pa = p(1);
    pb = p(2);
    W = double(OG)-(pa.*double(SB)+pb);
    W = uint8(W);
    NG = imtophat(W,se1);
    NG(NG<=Gthresh) = 0;
    p = polyfit(double(OG),double(OR),1);
    pa = p(1);
    pb = p(2);
    W = double(OR)-(pa.*double(OG)+pb);
    W = uint8(W);
    NR = imtophat(W,se1);
    NR(NR<=Rthresh) = 0;
    
    if max(SI(:)) == 0 && min(SI(:)) == 0
             RedYD(k).YW= 0;
             RedXD(k).XW = 0;
             GreenYD(k).YW= 0;
             GreenXD(k).XW = 0;
             hgreen(k) = 0;
             hblue(k) = 0;
             hred(k) = 0;
             AveB(k) = 0;
             AveG(k) = 0;
             AveR(k) = 0;
             SumB(k) = 0;
             SumG(k) = 0;
             SumR(k) = 0;
             continue;
    else    
        if analysis(1) == 1
            b = find(SB>Bthresh_low & SB< Bthresh_high);
            g = find(NG>0);
            r = find(NR>0);
            hgreen(k) = size(g,1);
            hblue(k) = size(b,1);
            hred(k) = size(r,1);
        end
        
        if analysis(2) == 1
            b = find(SB>Bthresh_low & SB< Bthresh_high);
            g = find(NG>0);
            r = find(NR>0);
             if isempty(b)
                AveB(k) = 0;
                SumB(k) = 0;
            else
                AveB(k) = mean(SB(b));
                SumB(k) = sum(SB(b));
            end
            if isempty(g)
                AveG(k) = 0;
                SumG(k) = 0;
            else
                AveG(k) = mean(NG(g));
                SumG(k) = sum(NG(g));
            end
            if isempty(r)
                AveR(k) = 0;
                SumR(k) = 0;
            else
                AveR(k) = mean(NR(r));
                SumR(k) = sum(NR(r));
            end
        end
                      
        if analysis(3) == 1
            
            minisize = 8;
            CB = medfilt2(SB,[8,8]);
            CG = NG>0;
            CG = imclose(CG,strel('disk',3));
            GG = OG.*uint8(CG);
            CR = NR>0;
            CR = imclose(CR,strel('disk',3));
            RR = OR.*uint8(CR);
            [BWG,numG] = bwlabel(CG);
            [BWR,numR] = bwlabel(CR);
            statsG = regionprops(BWG,'Centroid','Area','PixelIdxList','Eccentricity');
            statsR = regionprops(BWR,'Centroid','Area','PixelIdxList','Eccentricity');
            dataG = [];
            dataR = [];
            for i = 1:numG
                Bp = mean(CB(statsG(i).PixelIdxList));
                Gp = mean(GG(statsG(i).PixelIdxList));
                if Bp>=15 && Bp<200 && Gp>40 && Gp-Bp>-50 && statsG(i).Area>minisize
                    if statsG(i).Eccentricity <= 0.80
                        dataG(end+1,1:2) = statsG(i).Centroid;
                    else
                        TM = zeros(size(OG));
                        TM(statsG(i).PixelIdxList) = 1;
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
                                    dataG(end+1,1:2) = stats2(l).Centroid;
                                end
                            end
                        else
                            dataG(end+1,1:2) = statsG(i).Centroid;
                        end
                    end
                end
            end
            for i = 1:numR
                Bp = mean(CB(statsR(i).PixelIdxList));
                Rp = mean(RR(statsR(i).PixelIdxList));
                if Bp>=15 && Bp<200 && Rp>40 && Rp-Bp>-50 && statsR(i).Area>minisize
                    if statsR(i).Eccentricity <= 0.80
                        dataR(end+1,1:2) = statsR(i).Centroid;
                    else
                        TM = zeros(size(OR));
                        TM(statsR(i).PixelIdxList) = 1;
                        D = bwdist(~TM);
                        D = -D;
                        D(~TM) = -Inf;
                        L = watershed(D);
                        if max(L(:)) > 1                  
                            stats2 = regionprops(L,'Centroid','Area','PixelIdxList');
                            for l = 2:max(L(:))
                                Bp = mean(CB(stats2(l).PixelIdxList));
                                Rp = mean(RR(stats2(l).PixelIdxList));
                                if Bp>=15 && Bp<200 && Rp>40 && Rp-Bp>-50 && stats2(l).Area>minisize
                                    dataR(end+1,1:2) = stats2(l).Centroid;
                                end
                            end
                        else
                            dataR(end+1,1:2) = statsR(i).Centroid;
                        end
                    end
                end
            end
            if size(dataR,1)==0
                RBlobX = [];
                RBlobY = [];
            else
                RBlobX = dataR(:,2);
                RBlobY = dataR(:,1);
             end  
             
             if size(dataG,1)==0
                 GBlobX = [];
                 GBlobY = [];
             else
                 GBlobX = dataG(:,2);
                 GBlobY = dataG(:,1);
             end           
            RedYW = RBlobY+y;
            RedXW = RBlobX+x;
            GreenYW = GBlobY+y;
            GreenXW = GBlobX+x;
            RedYD(k).YW= RedYW;
            RedXD(k).XW = RedXW;
            GreenYD(k).YW= GreenYW;
            GreenXD(k).XW = GreenXW;
        end
        
        if analysis(4) == 1
            b = find(SB>Bthresh_low & SB< Bthresh_high);
            hblue(k) = size(b,1);
        end
        
    end   
        
end

ResName = [Imfile(1:end-5),'_Doublefoci.mat'];
Res = fullfile(Impath,ResName);
save(Res,'Iwidth','Iheight');

if analysis(1)==1
    greenpixel = sum(hgreen);
    bluepixel = sum(hblue);
    redpixel = sum(hred);
    RatioRED = redpixel./bluepixel ;
    RatioGREEN = greenpixel./bluepixel ;
    display('The Green Pixel Number is: ')
    disp(greenpixel);
    display('The Blue Pixel Number is: ')
    disp(bluepixel);
    display('The Red and Blue Pixel Number Ratio is: ')
    disp(RatioRED);
    display('The Green and Blue Pixel Number Ratio is: ')
    disp(RatioGREEN);
    save(Res,'greenpixel','bluepixel','redpixel','RatioRED','RatioGREEN','-append');
end

if analysis(2) == 1    
    fg = find(AveG >0);
    fb = find(AveB >0);
    fr = find(AveR >0);
    disp('The Sum Intensity of FITC in selected Area is ');
    SumIntenFITC = sum(SumG(:));
    disp(SumIntenFITC);
    disp('The Average Intensity of FITC in selected Area is ');
    AveIntenFITC = mean(AveG(fg));
    disp(AveIntenFITC);
    disp('The Sum Intensity of TxRed in selected Area is ');
    SumIntenTxRed = sum(SumR(:));
    disp(SumIntenTxRed);
    disp('The Average Intensity of TxRed in selected Area is ');
    AveIntenTxRed = mean(AveR(fr));
    disp(AveIntenTxRed);
    disp('The Sum Intensity of DAPI in selected Area is ');
    SumIntenDAPI = sum(SumB(:));
    disp(SumIntenDAPI);
    disp('The Average Intensity of DAPI stained Neuron Neucli in selected Area is ');
    AveIntenDAPI = mean(AveB(fb));
    disp(AveIntenDAPI);
    save(Res,'SumIntenFITC','AveIntenFITC','SumIntenTxRed','AveIntenTxRed','SumIntenDAPI','AveIntenDAPI','-append');
end

if analysis(3) == 1      
    XcoordR = RedXD(1).XW;
    YcoordR = RedYD(1).YW;
    if size(RedXD,2)> 1
        for j = 2:size(RedXD,2)
            if ~isempty(RedXD(j).XW)
                XcoordR = [XcoordR;RedXD(j).XW];
                YcoordR = [YcoordR;RedYD(j).YW];
            end
        end
    end
    d = size(XcoordR,1);
    XCOORDR = [];
    YCOORDR = [];
    for l = 1:d
        Dis = sqrt((XcoordR - XcoordR(l)).^2+(YcoordR - YcoordR(l)).^2);
        fd = find(Dis<= 8);
        XCOORDR(end+1) = round(mean(XcoordR(fd)));
        YCOORDR(end+1) = round(mean(YcoordR(fd)));
        XcoordR(fd) = -100;
        YcoordR(fd) = -100;
        XcoordR(l) = round(mean(XcoordR(fd)));
        YcoordR(l) = round(mean(YcoordR(fd)));
    end
    XCOORDR = XCOORDR(find(XCOORDR>0));
    YCOORDR = YCOORDR(find(YCOORDR>0));
    
    save(Res,'XCOORDR','YCOORDR','-append');  
    
    D = cell(size(XCOORDR,2)+1,2);
    D(1,:) = {'REDXcoordinate','REDYcoordinate'};
    for j = 2:size(XCOORDR,2)
        D(j,:) = {XCOORDR(j-1),YCOORDR(j-1)};
    end
    xlswrite([Res,'REDCoordinate.xls'],D,'output');
       
    disp('The Number of TxRed Foci in selected Area is ');
    disp(size(XCOORDR,2));
    
    %NOW GREEN BLOBS
    XcoordG = GreenXD(1).XW;
    YcoordG = GreenYD(1).YW;
    if size(GreenXD,2) >1
        for j = 2:size(GreenXD,2)
            if ~isempty(GreenXD(j).XW)
                XcoordG = [XcoordG;GreenXD(j).XW];
                YcoordG = [YcoordG;GreenYD(j).YW];
            end
        end
    end
    d = size(XcoordG,1);
    XCOORDG = [];
    YCOORDG = [];
    for l = 1:d
        Dis = sqrt((XcoordG - XcoordG(l)).^2+(YcoordG - YcoordG(l)).^2);
        fd = find(Dis<= 8);
        XCOORDG(end+1) = round(mean(XcoordG(fd)));
        YCOORDG(end+1) = round(mean(YcoordG(fd)));
        XcoordG(fd) = -100;
        YcoordG(fd) = -100;
        XcoordG(l) = round(mean(XcoordG(fd)));
        YcoordG(l) = round(mean(YcoordG(fd)));
    end
    XCOORDG = XCOORDG(find(XCOORDG>0));
    YCOORDG = YCOORDG(find(YCOORDG>0));
    
    save(Res,'XCOORDG','YCOORDG','-append');  
    
    D = cell(size(XCOORDG,2)+1,2);
    D(1,:) = {'GreenXcoordinate','GreenYcoordinate'};
    for j = 2:size(XCOORDG,2)
        D(j,:) = {XCOORDG(j-1),YCOORDG(j-1)};
    end
    xlswrite([Res,'GreenCoordinate.xls'],D,'output');
    
    disp('The Number of FITC Foci in selected Area is ');
    disp(size(XCOORDG,2));
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %Find NNPAIR
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    Resolu = 0.23;
    
    XFreal = XCOORDG.*Resolu;
    YFreal = YCOORDG.*Resolu;
    ZFreal = zeros(size(XCOORDG,2));
    
    XTreal = XCOORDR.*Resolu;
    YTreal = YCOORDR.*Resolu;
    ZTreal = zeros(size(XCOORDR,2));
    
    XX = [XFreal' YFreal' ZFreal'];
    YY = [XTreal' YTreal' ZTreal'];
    
    FITCnear = Findnearest(XX);
    TxRednear = Findnearest(YY);
    
    [~,Fmid] = Findnnpair(FITCnear);
    [~,Tmid] = Findnnpair(TxRednear);
    if ~isempty(Fmid)&& ~isempty(Tmid)
        FmidTmidnear = Findnearest2(Fmid,Tmid);
        TmidFmidnear = Findnearest2(Tmid,Fmid);
        [FTnnpair,FTmid] = Findnnpair2(FmidTmidnear,TmidFmidnear);
        if ~isempty(FTmid)
            DoubleLabel = [FTmid(:,1)./Resolu FTmid(:,2)./Resolu FTmid(:,3)./Resolu];
            DoubleLabel = round(DoubleLabel);
            
            DoublenumF = FTnnpair(:,1);
            DoublenumT = FTnnpair(:,5);
            
            FFmid = Fmid;
            TTmid = Tmid;
            
            FFmid(DoublenumF,:) = 0;
            TTmid(DoublenumT,:) = 0;
            
            f = find(FFmid(:,1)>0);
            FFmid = FFmid(f,:);
            SingleFITC = [FFmid(:,1)./Resolu FFmid(:,2)./Resolu FFmid(:,3)./Resolu];
            SingleFITC = round(SingleFITC);
            
            f2 = find(TTmid(:,1)>0);
            TTmid = TTmid(f2,:);
            SingleTxRed = [TTmid(:,1)./Resolu TTmid(:,2)./Resolu TTmid(:,3)./Resolu];
            SingleTxRed = round(SingleTxRed);
        else
            DoubleLabel = [];
            SingleFITC = [Fmid(:,1)./Resolu Fmid(:,2)./Resolu Fmid(:,3)./Resolu];
            SingleTxRed = [Tmid(:,1)./Resolu Tmid(:,2)./Resolu Tmid(:,3)./Resolu];
        end
    elseif isempty(Fmid)&& isempty(Tmid)
        DoubleLabel = [];
        SingleFITC = [];
        SingleTxRed = [];
    elseif ~isempty(Fmid) && isempty(Tmid)
        SingleTxRed = [];
        DoubleLabel = [];
        SingleFITC = [Fmid(:,1)./Resolu Fmid(:,2)./Resolu Fmid(:,3)./Resolu];
        SingleFITC = round(SingleFITC);
    elseif isempty(Fmid) && ~isempty(Tmid)
        DoubleLabel = [];
        SingleFITC = [];
        SingleTxRed = [Tmid(:,1)./Resolu Tmid(:,2)./Resolu Tmid(:,3)./Resolu];
        SingleTxRed = round(SingleTxRed);
    end
    
    display('The number of Doulbe Labeling Cell is');
    display(size(DoubleLabel,1))
    display('The number of FITC labeled only Cell is');
    display(size(SingleFITC,1))
    display('The number of TxRed labeled only Cell is');
    display(size(SingleTxRed,1))
    
    save(Res,'DoubleLabel','SingleFITC','SingleTxRed','-append');  
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 %SHOW RESULT
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    Tim = imread(fullfile(Impath,Imfile));
    try
        imshow(Tim);
    catch exception
        image(Tim);
    end
    hold on
    plot(YCOORDR,XCOORDR,'.m','markersize',6);
    plot(YCOORDG,XCOORDG,'.c','markersize',6);
    saveas(gcf,fullfile(Impath,[Imfile,'_FITCandTxRedPlot.fig']),'fig');
    hold off
    close
    
    Tim = imread(fullfile(Impath,Imfile));
    try
        imshow(Tim);
    catch exception
        image(Tim);
    end
    hold on
    if ~isempty(SingleFITC)
        plot(SingleFITC(:,2),SingleFITC(:,1),'.m','markersize',6);
    end
    if ~isempty(SingleTxRed)
        plot(SingleTxRed(:,2),SingleTxRed(:,1),'.c','markersize',6);
    end
    if ~isempty(DoubleLabel)
        plot(DoubleLabel(:,2),DoubleLabel(:,1),'*w','markersize',6);
    end
    saveas(gcf,fullfile(Impath,[Imfile,'_DoubleLabeling.fig']),'fig');
    hold off
    close
    
end

if analysis(4)==1
    display('The Estimated Nuclei Number in this region is: ')
    EsNucleiNumber = round(sum(hblue)/2249.49);
    disp(EsNucleiNumber);
    save(Res,'EsNucleiNumber','-append');     
end

disp('JOB DONE!');