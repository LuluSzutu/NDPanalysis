function Doublefoci3D(IM,Impath,Imfile,Imf,Iwidth,Iheight,analysis,thresh,Zstack)

% Impath1 = fullfile(Impath,[Imfile(1:end-5),'_TempSubimage\']);
Imreg = [Imfile(1:end-5),'_TempSubimage'];

xstep = 1000;
ystep = 1000;
xrange = floor(Iwidth/xstep);
yrange = floor(Iheight/ystep);
% EndWidth = xrange*xstep;
% EndHeight = yrange*ystep;

if isempty(thresh)
    Ifitc = IM(:,:,2);
    Idapi = IM(:,:,3);
    Itxred = IM(:,:,1);
    if max(Ifitc(:)) == 255
        Gthresh = 25;
    elseif max(Ifitc(:)) >= 210 && max(Ifitc(:)) < 255
        Gthresh = 20;
    elseif max(Ifitc(:)) < 210 && max(Ifitc(:)) >= 130
        Gthresh = 18;
    else
        Gthresh = 15;
    end
    if max(Itxred(:)) == 255
        Rthresh = 25;
    elseif max(Itxred(:)) >= 210 && max(Ifitc(:)) < 255
        Rthresh = 20;
    elseif max(Itxred(:)) < 210 && max(Ifitc(:)) >= 130
        Rthresh = 20;
    else
        Rthresh = 20;
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
    Gthresh
    Rthresh
    Bthresh_low
    Bthresh_high
else
    Gthresh = thresh(3);
    Rthresh = thresh(4);
    Bthresh_low = thresh(1);
    Bthresh_high = thresh(2);
end

hgreen = [];
hblue = [];
hred = [];
AveB = [];
AveG = [];
AveR = [];
SumB = [];
SumG = [];
SumR = [];
analysis = analysis';

parfor i = 1:(xrange+1)*(yrange+1)
    [X,Y] = ind2sub([xrange+1 yrange+1],i);
    X = (X-1)*xstep;
    Y = (Y-1)*ystep;
    IMB = uint8(zeros(xstep,ystep,size(Zstack,2)));
    IMG = uint8(zeros(xstep,ystep,size(Zstack,2)));
    IMR = uint8(zeros(xstep,ystep,size(Zstack,2)));
    for q = 1:size(Zstack,2)
        fna = [Imfile,'_',num2str(X,'%d'),'_',num2str(Y,'%d'),'_',num2str(q,'%d'),'.bmp'];
        try
            filena = [Impath filesep Imreg filesep fna];
            I = imread(filena);
        catch
            if strcmp(Impath(1),'X')
                Newpath = PathChange(Impath);
                filena = [Newpath filesep Imreg filesep fna];
                I = imread(filena);
            else
                errordlg('MATLAB CLUSTER only can processing the image storaged in the CLUSTER!');
            end
        end
        IMB(:,:,q) = I(:,:,3);
        IMG(:,:,q) = I(:,:,2);
        IMR(:,:,q) = I(:,:,1);
    end
    se1 = strel('ball',10,5);
    minisize = 4;
    
    B = IMB>Bthresh_low & IMB< Bthresh_high;
        
    p = polyfit(double(IMB),double(IMG),1);
    pa = p(1);
    pb = p(2);
    G = double(IMG)-(pa.*double(IMB)+pb);
    G(G<0) = 0;
    G = uint8(G).*uint8(B);
    
    p = polyfit(double(IMB),double(IMR),1);
    pa = p(1);
    pb = p(2);
    R = double(IMR)-(pa.*double(IMB)+pb);
    R(R<0) = 0;
    R = uint8(R).*uint8(B);
    
    G = imtophat(G,se1);
    R = imtophat(R,se1);
       
    if max(IMG(:)) == 0 && min(IMG(:)) == 0 && max(IMR(:)) == 0 && min(IMR(:)) == 0
        RedYD(i).YW= 0;
        RedXD(i).XW = 0;
        RedZD(i).ZW = 0;
        GreenYD(i).YW= 0;
        GreenXD(i).XW = 0;
        GreenZD(i).ZW = 0;
        hgreen(i) = 0;
        hblue(i) = 0;
        hred(i) = 0;
        AveB(i) = 0;
        AveG(i) = 0;
        SumB(i) = 0;
        SumG(i) = 0;
        continue;
    else
        if analysis(1) == 1
            b = find(IMB>Bthresh_low & IMB< Bthresh_high);
            g = find(G>Gthresh);
            r = find(R>Rthresh);
            hgreen(i) = size(g,1);
            hred(i) = size(r,1);
            hblue(i) = size(b,1);
        end
        
        if analysis(2) == 1
            b = find(IMB>Bthresh_low & IMB< Bthresh_high);
            g = find(G>Gthresh);
            r = find(R>Rthresh);
            if isempty(b)
                AveB(i) = 0;
                SumB(i) = 0;
            else
                AveB(i) = mean(IMB(b));
                SumB(i) = sum(IMB(b));
            end
            if isempty(g)
                AveG(i) = 0;
                SumG(i) = 0;
            else
                AveG(i) = mean(G(g));
                SumG(i) = sum(G(g));
            end
            if isempty(r)
                AveR(i) = 0;
                SumR(i) = 0;
            else
                AveR(i) = mean(R(r));
                SumR(i) = sum(R(r));
            end
        end
        
        if analysis(3) == 1
            G(G<=Gthresh) = 0;
            R(R<=Rthresh) = 0;
            
            [bwG,numG] = bwlabeln(G);
            [bwR,numR] = bwlabeln(R);
                   
            statsG = regionprops(bwG,'Centroid','PixelIdxList','Area');
            statsR = regionprops(bwR,'Centroid','PixelIdxList','Area');
            
            DataG = [];
            DataR = [];
            
            for k = 1:numG
                Gp = mean(G(statsG(k).PixelIdxList));
                Rp = mean(IMR(statsG(k).PixelIdxList));
                if Gp>Rp && Gp>Bthresh_low && Rp<=Bthresh_high && statsG(k).Area>minisize
                    if statsG(k).Area > 500
                        TM = zeros(size(IMG));
                        TM(statsG(k).PixelIdxList) = 1;
                        D = bwdist(~TM);
                        D = -D;
                        D(~TM) = -Inf;
                        L = watershed(D);
                        if max(L(:)) > 1                  
                            stats2 = regionprops(L,'Centroid','Area','PixelIdxList');
                            for l = 2:max(L(:))
                                Rp = mean(IMR(stats2(l).PixelIdxList));
                                Gp = mean(G(stats2(l).PixelIdxList));
                                if Gp>Rp && Gp>Bthresh_low && Rp<=Bthresh_high && stats2(l).Area>minisize
                                    DataG(end+1,1:3) = stats2(l).Centroid;
                                end
                            end
                        else
                            DataG(end+1,1:3) = statsG(k).Centroid;
                        end
                    else
                        DataG(end+1,1:3) = round(statsG(k).Centroid);
                    end
                end
            end
            
            for k = 1:numR
                Gp = mean(IMG(statsR(k).PixelIdxList));
                Rp = mean(IMR(statsR(k).PixelIdxList));
                PoissonMean = mle(R(statsR(k).PixelIdxList),'distribution','poisson');
                if Rp>Gp && Rp>Bthresh_low && Rp<=Bthresh_high && PoissonMean >= 0.5 && statsR(k).Area>minisize
                    if statsR(k).Area > 500
                        TM = zeros(size(IMR));
                        TM(statsR(k).PixelIdxList) = 1;
                        D = bwdist(~TM);
                        D = -D;
                        D(~TM) = -Inf;
                        L = watershed(D);
                        if max(L(:)) > 1                  
                            stats2 = regionprops(L,'Centroid','Area','PixelIdxList');
                            for l = 2:max(L(:))
                                Rp = mean(R(stats2(l).PixelIdxList));
                                Gp = mean(IMG(stats2(l).PixelIdxList));
                                if Rp>Gp && Rp>Bthresh_low && Rp<=Bthresh_high && stats2(l).Area>minisize
                                    DataR(end+1,1:3) = stats2(l).Centroid;
                                end
                            end
                        else
                            DataR(end+1,1:3) = statsR(k).Centroid;
                        end
                    else
                        DataR(end+1,1:3) = round(statsR(k).Centroid);
                    end 
                end
            end
            
             if size(DataR,1)==0
                RBlobX = [];
                RBlobY = [];
                RBlobZ = [];
            else
                RBlobX = DataR(:,2);
                RBlobY = DataR(:,1);
                RBlobZ = DataR(:,3);
             end  
             
             if size(DataG,1)==0
                 GBlobX = [];
                 GBlobY = [];
                 GBlobZ = [];
             else
                 GBlobX = DataG(:,2);
                 GBlobY = DataG(:,1);
                 GBlobZ = DataG(:,3);
             end

            RYW = RBlobY+X;
            RXW = RBlobX+Y;
            RZW = RBlobZ;
            RedYD(i).YW= RYW;
            RedXD(i).XW = RXW;
            RedZD(i).ZW = RZW;
            GYW = GBlobY+X;
            GXW = GBlobX+Y;
            GZW = GBlobZ;
            GreenYD(i).YW= GYW;
            GreenXD(i).XW = GXW;
            GreenZD(i).ZW = GZW;
        end
        
        if analysis(4) == 1
            b = find(IMB>Bthresh_low & IMB< Bthresh_high);
            hblue(i) = size(b,1);
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

if analysis(3)==1  
    XcoordR = RedXD(1).XW;
    YcoordR = RedYD(1).YW;
    ZcoordR = RedZD(1).ZW;
    if size(RedXD,2)> 1
        for j = 2:size(RedXD,2)
            if ~isempty(RedXD(j).XW)
                XcoordR = [XcoordR;RedXD(j).XW];
                YcoordR = [YcoordR;RedYD(j).YW];
                ZcoordR = [ZcoordR;RedZD(j).ZW];
            end
        end
    end
    d = size(XcoordR,1);
    XCOORDR = [];
    YCOORDR = [];
    ZCOORDR = [];
    for l = 1:d
        Dis = sqrt((XcoordR - XcoordR(l)).^2+(YcoordR - YcoordR(l)).^2+(ZcoordR - ZcoordR(l)).^2);
        fd = find(Dis<= 8);
        XCOORDR(end+1) = round(mean(XcoordR(fd)));
        YCOORDR(end+1) = round(mean(YcoordR(fd)));
        ZCOORDR(end+1) = round(mean(ZcoordR(fd)));
        XcoordR(fd) = -100;
        YcoordR(fd) = -100;
        ZcoordR(fd) = -100;
        XcoordR(l) = round(mean(XcoordR(fd)));
        YcoordR(l) = round(mean(YcoordR(fd)));
        ZcoordR(l) = round(mean(ZcoordR(fd)));
    end
    XCOORDR = XCOORDR(find(XCOORDR>0));
    YCOORDR = YCOORDR(find(YCOORDR>0));
    ZCOORDR = ZCOORDR(find(ZCOORDR>0));   
    
    save(Res,'XCOORDR','YCOORDR','ZCOORDR','-append');  
    
    D = cell(size(XCOORDR,2)+1,3);
    D(1,:) = {'REDXcoordinate','REDYcoordinate','REDZcoordinate'};
    for j = 2:size(XCOORDR,2)
        D(j,:) = {XCOORDR(j-1),YCOORDR(j-1),ZCOORDR(j-1)};
    end
    xlswrite([Res,'REDCoordinate.xls'],D,'output');
    
    %NOW GREEN BLOBS
    XcoordG = GreenXD(1).XW;
    YcoordG = GreenYD(1).YW;
    ZcoordG = GreenZD(1).ZW;
    if size(GreenXD,2) >1
        for j = 2:size(GreenXD,2)
            if ~isempty(GreenXD(j).XW)
                XcoordG = [XcoordG;GreenXD(j).XW];
                YcoordG = [YcoordG;GreenYD(j).YW];
                ZcoordG = [ZcoordG;GreenZD(j).ZW];
            end
        end
    end
    d = size(XcoordG,1);
    XCOORDG = [];
    YCOORDG = [];
    ZCOORDG = [];
    for l = 1:d
        Dis = sqrt((XcoordG - XcoordG(l)).^2+(YcoordG - YcoordG(l)).^2+(ZcoordG - ZcoordG(l)).^2);
        fd = find(Dis<= 8);
        XCOORDG(end+1) = round(mean(XcoordG(fd)));
        YCOORDG(end+1) = round(mean(YcoordG(fd)));
        ZCOORDG(end+1) = round(mean(ZcoordG(fd)));
        XcoordG(fd) = -100;
        YcoordG(fd) = -100;
        ZcoordG(fd) = -100;
        XcoordG(l) = round(mean(XcoordG(fd)));
        YcoordG(l) = round(mean(YcoordG(fd)));
        ZcoordG(l) = round(mean(ZcoordG(fd)));
    end
    XCOORDG = XCOORDG(find(XCOORDG>0));
    YCOORDG = YCOORDG(find(YCOORDG>0));
    ZCOORDG = ZCOORDG(find(ZCOORDG>0));   
    
    save(Res,'XCOORDG','YCOORDG','ZCOORDG','-append');  
    
    D = cell(size(XCOORDG,2)+1,3);
    D(1,:) = {'GreenXcoordinate','GreenYcoordinate','GreenZcoordinate'};
    for j = 2:size(XCOORDG,2)
        D(j,:) = {XCOORDG(j-1),YCOORDG(j-1),ZCOORDG(j-1)};
    end
    xlswrite([Res,'GreenCoordinate.xls'],D,'output');
    
    disp('The Number of FITC Foci in selected Area is ');
    disp(size(XCOORDG,2));
    
    disp('The Number of TxRed Foci in selected Area is ');
    disp(size(XCOORDR,2));
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %Find NNPAIR
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    Resolu = 0.23;
    
    Zre1 = Imf(Zstack(1)).UnknownTags;
    Zre2 = Imf(Zstack(2)).UnknownTags;
    ResoluZ = abs((Zre1(5).Value - Zre2(5).Value)/1000);
    
    XFreal = XCOORDG.*Resolu;
    YFreal = YCOORDG.*Resolu;
    ZFreal = ZCOORDG.*ResoluZ;
    
    XTreal = XCOORDR.*Resolu;
    YTreal = YCOORDR.*Resolu;
    ZTreal = ZCOORDR.*ResoluZ;
    
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
            DoubleLabel = [FTmid(:,1)./Resolu FTmid(:,2)./Resolu FTmid(:,3)./ResoluZ];
            DoubleLabel = round(DoubleLabel);
            
            DoublenumF = FTnnpair(:,1);
            DoublenumT = FTnnpair(:,5);
            
            FFmid = Fmid;
            TTmid = Tmid;
            
            FFmid(DoublenumF,:) = 0;
            TTmid(DoublenumT,:) = 0;
            
            f = find(FFmid(:,1)>0);
            FFmid = FFmid(f,:);
            SingleFITC = [FFmid(:,1)./Resolu FFmid(:,2)./Resolu FFmid(:,3)./ResoluZ];
            SingleFITC = round(SingleFITC);
            
            f2 = find(TTmid(:,1)>0);
            TTmid = TTmid(f2,:);
            SingleTxRed = [TTmid(:,1)./Resolu TTmid(:,2)./Resolu TTmid(:,3)./ResoluZ];
            SingleTxRed = round(SingleTxRed);
        else
            DoubleLabel = [];
            SingleFITC = [Fmid(:,1)./Resolu Fmid(:,2)./Resolu Fmid(:,3)./ResoluZ];
            SingleTxRed = [Tmid(:,1)./Resolu Tmid(:,2)./Resolu Tmid(:,3)./ResoluZ];
        end
    elseif isempty(Fmid)&& isempty(Tmid)
        DoubleLabel = [];
        SingleFITC = [];
        SingleTxRed = [];
    elseif ~isempty(Fmid) && isempty(Tmid)
        SingleTxRed = [];
        DoubleLabel = [];
        SingleFITC = [Fmid(:,1)./Resolu Fmid(:,2)./Resolu Fmid(:,3)./ResoluZ];
        SingleFITC = round(SingleFITC);
    elseif isempty(Fmid) && ~isempty(Tmid)
        DoubleLabel = [];
        SingleFITC = [];
        SingleTxRed = [Tmid(:,1)./Resolu Tmid(:,2)./Resolu Tmid(:,3)./ResoluZ];
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
    
    Tim = imread(fullfile(Impath,[Imfile,'_map.bmp']));
    try
        imshow(Tim);
    catch exception
        image(Tim);
    end
    hold on
    plot(YCOORDR./8,XCOORDR./8,'.m','markersize',6);
    plot(YCOORDG./8,XCOORDG./8,'.c','markersize',6);
    saveas(gcf,fullfile(Impath,[Imfile,'_FITCandTxRedPlot.fig']),'fig');
    hold off
    close
    
    Tim = imread(fullfile(Impath,[Imfile,'_map.bmp']));
    try
        imshow(Tim);
    catch exception
        image(Tim);
    end
    hold on
    plot(ceil(SingleFITC(:,2)./8),ceil(SingleFITC(:,1)./8),'.m','markersize',6);
    plot(ceil(SingleTxRed(:,2)./8),ceil(SingleTxRed(:,1)./8),'.c','markersize',6);
    plot(ceil(DoubleLabel(:,2)./8),ceil(DoubleLabel(:,1)./8),'*w','markersize',6);
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

