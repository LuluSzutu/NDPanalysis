function Doublefoci3D_wMASK(IM,Impath,Imfile,Imregion,Imf,analysis,thresh,MaskCrop,rect,rot,Zstack)

Imreg = [Imregion,'_TempSubimage'];

MaskCrop = uint8(MaskCrop);
[Iheight,Iwidth] = size(MaskCrop);
SizeofMask = size(find(MaskCrop>0),1)*64;
ROIinUM = SizeofMask*0.0529;

xstep = 1000;
ystep = 1000;
xrange = floor(Iwidth/xstep);
yrange = floor(Iheight/ystep);
EndWidth = (xrange+1)*xstep;
EndHeight = (yrange+1)*ystep;
MCrop = uint8(zeros(EndHeight,EndWidth));
MCrop(1:Iheight,1:Iwidth) = MaskCrop;

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
    Mk = MCrop(Y+1:Y+ystep,X+1:X+xstep);
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
        IMB(:,:,q) = I(:,:,3).*Mk;
        IMG(:,:,q) = I(:,:,2).*Mk;
        IMR(:,:,q) = I(:,:,1).*Mk;
    end
           
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
        se1 = strel('ball',10,5);
        minisize = 8;
        
        B = IMB>Bthresh_low & IMB< Bthresh_high;
        
        p = polyfit(double(IMB),double(IMG),1);
        pa = p(1);
        pb = p(2);
        G = double(IMG)-(pa.*double(IMB)+pb);
        G(G<0) = 0;
        G = uint8(G).*uint8(B);
        
        p = polyfit(double(IMG),double(IMR),1);
        pa = p(1);
        pb = p(2);
        R = double(IMR)-(pa.*double(IMG)+pb);
        R(R<0) = 0;
        R = uint8(R).*uint8(B);
        
        G = imtophat(G,se1);
        R = imtophat(R,se1);
        
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
                Rp = mean(R(statsR(k).PixelIdxList));
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
    
    TxRedXcoordBIG = XCOORDR'+rect(1);
    TxRedYcoordBIG = YCOORDR'+rect(2);
    TxRedZcoordBIG = ZCOORDR;
    save(Res,'TxRedXcoordBIG','TxRedYcoordBIG','TxRedZcoordBIG','-append');
    
    A = uint8(zeros(size(MaskCrop)));
    coord = sub2ind(size(A),XCOORDR,YCOORDR);
    A(coord) = 1;
    B = imrotate(A,rot);
    f = find(B>0);
    [TxRedXcoordSM,TxRedYcoordSM] = ind2sub(size(B),f);
    TxRedZcoordSM = ZCOORDR;
    save(Res,'TxRedXcoordSM','TxRedYcoordSM','TxRedZcoordSM','-append');   
    
    D = cell(size(XCOORDR,2)+1,6);
    D(1,:) = {'REDXcoordinateSM','REDYcoordinateSM','REDZcoordinateSM','REDXcoordinateBIG','REDYcoordinateBIG','REDZcoordinateBIG'};
    for j = 2:size(XCOORDR,2)
        D(j,:) = {TxRedXcoordSM(j-1),TxRedYcoordSM(j-1),TxRedZcoordSM(j-1),TxRedXcoordBIG(j-1),TxRedYcoordBIG(j-1),TxRedZcoordBIG(j-1)};
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
    
    FITCXcoordBIG = XCOORDG'+rect(1);
    FITCYcoordBIG = YCOORDG'+rect(2);
    FITCZcoordBIG = ZCOORDG;
    save(Res,'FITCXcoordBIG','FITCYcoordBIG','FITCZcoordBIG','-append');
    
    A = uint8(zeros(size(MaskCrop)));
    coord = sub2ind(size(A),XCOORDG,YCOORDG);
    A(coord) = 1;
    B = imrotate(A,rot);
    f = find(B>0);
    [FITCXcoordSM,FITCYcoordSM] = ind2sub(size(B),f);
    FITCZcoordSM = ZCOORDG;
    save(Res,'FITCXcoordSM','FITCYcoordSM','FITCZcoordSM','-append');   
    
    D = cell(size(XCOORDG,2)+1,6);
    D(1,:) = {'GREENXcoordinateSM','GREENYcoordinateSM','GREENZcoordinateSM','GREENXcoordinateBIG','GREENYcoordinateBIG','GREENZcoordinateBIG'};
    for j = 2:size(XCOORDG,2)
        D(j,:) = {FITCXcoordSM(j-1),FITCYcoordSM(j-1),FITCZcoordSM(j-1),FITCXcoordBIG(j-1),FITCYcoordBIG(j-1),FITCZcoordBIG(j-1)};
    end
    xlswrite([Res,'GREENCoordinate.xls'],D,'output');
    
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
    
    XFreal = FITCXcoordSM.*Resolu;
    YFreal = FITCYcoordSM.*Resolu;
    ZFreal = FITCZcoordSM.*ResoluZ;
    
    XTreal = TxRedXcoordSM.*Resolu;
    YTreal = TxRedYcoordSM.*Resolu;
    ZTreal = TxRedZcoordSM.*ResoluZ;
    
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
    
    DoubleLabelBIG = [DoubleLabel(:,1)+rect(1) DoubleLabel(:,2)+rect(2)  DoubleLabel(:,3)] ;
    SingleFITCBIG = [SingleFITC(:,1)+rect(1) SingleFITC(:,2)+rect(2)  SingleFITC(:,3)] ;
    SingleTxRedBIG = [SingleTxRed(:,1)+rect(1) SingleTxRed(:,2)+rect(2)  SingleTxRed(:,3)] ;
    save(Res,'DoubleLabelBIG','SingleFITCBIG','SingleTxRedBIG','-append'); 
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 %SHOW RESULT
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    Tim = imread(fullfile(Impath,[Imregion,'_map.bmp']));
    try
        imshow(Tim);
    catch exception
        image(Tim);
    end
    hold on
    if size(TxRedXcoordSM,2)> 0
        plot(TxRedYcoordSM./8,TxRedXcoordSM./8,'.m','markersize',6);
    end
    if size(FITCXcoordSM,2)> 0
        plot(FITCYcoordSM./8,FITCXcoordSM./8,'.c','markersize',6);
    end
    saveas(gcf,fullfile(Impath,[Imfile,'_FITCandTxRedPlot.fig']),'fig');
    hold off
    close
    
    Tim = imread(fullfile(Impath,[Imregion,'_map.bmp']));
    try
        imshow(Tim);
    catch exception
        image(Tim);
    end
    hold on
    if size(SingleFITC,1)>0
        plot(SingleFITC(:,2)./8,SingleFITC(:,1)./8,'.m','markersize',6);
    end
    if size(SingleTxRed,1) >0
        plot(SingleTxRed(:,2)./8,SingleTxRed(:,1)./8,'.c','markersize',6);
    end
    if size(DoubleLabel,1) >0
       plot(DoubleLabel(:,2)./8,DoubleLabel(:,1)./8,'*w','markersize',6);
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

