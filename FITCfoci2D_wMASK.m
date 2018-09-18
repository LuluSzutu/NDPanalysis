function FITCfoci2D_wMASK(IM,Impath,Imfile,Imregion,analysis,thresh,MaskCrop,rect,rot)

% Impath1 = fullfile(Impath,[Imregion,'_TempSubimage\']);
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

se1 = strel('disk',20);
minisize = 8;

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

hgreen = [];
hblue = [];
AveB = [];
AveG = [];
SumB = [];
SumG = [];
analysis = analysis';

parfor i = 1:(xrange+1)*(yrange+1)
    [x,y] = ind2sub([xrange+1 yrange+1],i);
    X = (x-1)*xstep;
    Y = (y-1)*ystep;
    Mk = MCrop(Y+1:y*ystep,X+1:x*xstep);
    fna = [Imfile,'_',num2str(X,'%d'),'_',num2str(Y,'%d'),'_',num2str(1,'%d'),'.bmp'];
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
    
%     imwrite(I2,filena);
    
    if max(I(:)) == 0 && min(I(:)) == 0
        YD(i).YW= 0;
        XD(i).XW = 0;
        hgreen(i) = 0;
        hblue(i) = 0;
        AveB(i) = 0;
        AveG(i) = 0;
        SumB(i) = 0;
        SumG(i) = 0;
        continue;
    else
        G = I(:,:,2).*Mk;
        B = I(:,:,3).*Mk;
        m = mean(B(:))./mean(G(:));
        SB = B./m;
        p = polyfit(double(SB),double(G),1);
        pa = p(1);
        pb = p(2);
        W = double(G)-(pa.*double(SB)+pb);
        W = uint8(W);
        NG = imtophat(W,se1);
        
        if analysis(1) == 1
            b = find(B>nucTb & B< nucTb2);
            g = find(NG>nucT);
            hgreen(i) = size(g,1);
            hblue(i) = size(b,1);
        end
        
        if analysis(2) == 1
            b = find(B>nucTb & B< nucTb2);
            g = find(NG>nucT);
            if ~isempty(b)&& ~isempty(g)
                AveB(i) = mean(B(b));
                AveG(i) = mean(G(g));
                SumB(i) = sum(B(b));
                SumG(i) = sum(G(g));
            elseif ~isempty(b)&& isempty(g)
                AveB(i) = mean(B(b));
                AveG(i) = 0;
                SumB(i) = sum(B(b));
                SumG(i) = 0;
            elseif isempty(b)&&~isempty(g)
                AveB(i) = 0;
                AveG(i) = mean(G(g));
                SumB(i) = 0;
                SumG(i) = sum(G(g));
            end
        end
        
        if analysis(3) == 1
            NG(NG<=nucT) = 0;
            CB = medfilt2(B,[8,8]);
            CG = NG>0;
            CG = imclose(CG,strel('disk',3));
            GG = G.*uint8(CG);
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
                        if max(L(:)) > 1                  
                            stats2 = regionprops(L,'Centroid','Area','PixelIdxList');
                            for k = 2:max(L(:))
                                Bp = mean(CB(stats2(k).PixelIdxList));
                                Gp = mean(GG(stats2(k).PixelIdxList));
                                if Bp>=15 && Bp<200 && Gp>40 && Gp-Bp>-50 && stats2(k).Area>minisize
                                    data(end+1,1:2) = stats2(k).Centroid;
                                end
                            end
                        else
                            data(end+1,1:2) = stats(j).Centroid;
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
            YW = BlobY+X;
            XW = BlobX+Y;
            YD(i).YW= YW;
            XD(i).XW = XW;
        end
        
        if analysis(4) == 1
            b = find(B>nucTb & B< nucTb2);
            hblue(i) = size(b,1);
        end
    end        
end

ResName = [Imregion,'_FITCfoci.mat'];
Res = fullfile(Impath,ResName);
save(Res,'Iwidth','Iheight','rect','SizeofMask','ROIinUM');

if analysis(1)==1
    greenpixel = sum(hgreen);
    bluepixel = sum(hblue);
    Ratio = greenpixel./bluepixel ;
    display('The Green Pixel Number is: ')
    disp(greenpixel);
    display('The Blue Pixel Number is: ')
    disp(bluepixel);
    display('The Green and Blue Pixel Number Ratio is: ')
    disp(Ratio);
    save(Res,'greenpixel','bluepixel','Ratio','-append');
end

if analysis(2) == 1    
    fg = find(AveG >0);
    fb = find(AveB >0);
    disp('The Sum Intensity of FITC in selected Area is ');
    SumIntenFITC = sum(SumG(:));
    disp(SumIntenFITC);
    disp('The Average Intensity of FITC in selected Area is ');
    AveIntenFITC = mean(AveG(fg));
    disp(AveIntenFITC);
    disp('The Sum Intensity of DAPI in selected Area is ');
    SumIntenDAPI = sum(SumB(:));
    disp(SumIntenDAPI);
    disp('The Average Intensity of DAPI stained Neuron Neucli in selected Area is ');
    AveIntenDAPI = mean(AveB(fb));
    disp(AveIntenDAPI);
    save(Res,'SumIntenFITC','AveIntenFITC','SumIntenDAPI','AveIntenDAPI','-append');
end

if analysis(3)==1  
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
    
    XcoordBIG = XCOORD'+rect(1);
    YcoordBIG = YCOORD'+rect(2);
    save(Res,'XcoordBIG','YcoordBIG','-append');
    
    A = uint8(zeros(size(MaskCrop)));
    coord = sub2ind(size(A),XCOORD,YCOORD);
    A(coord) = 1;
    B = imrotate(A,rot);
    f = find(B>0);
    [XcoordSM,YcoordSM] = ind2sub(size(B),f);
       
    save(Res,'XcoordSM','YcoordSM','-append');        
    D = cell(size(XcoordSM,1)+1,4);
    D(1,:) = {'XcoordinateSmall','YcoordinateSmall','XcoordinateBig','YcoordinateBig'};
    for j = 2:size(XcoordSM,1)
        D(j,:) = {XcoordSM(j-1),YcoordSM(j-1),XcoordBIG(j-1),YcoordBIG(j-1)};
    end
    xlswrite([Res,'Coordinate.xls'],D,'output');
      
    disp('The Number of FITC Foci in selected Area is ');
    disp(size(XCOORD,2));
    
    %Find NNPair       
    Resolu = 0.23;
    XFreal = XcoordSM.*Resolu;
    YFreal = YcoordSM.*Resolu;
    ZFreal = zeros(size(XcoordSM));
    XX = [XFreal' YFreal' ZFreal'];
    FITCnear = Findnearest(XX);
    [~,Fmid] = Findnnpair(FITCnear);
    Fmid = round(Fmid./Resolu);
    
    disp('The Number of FITC Foci Pair in selected Area is ');
    disp(size(Fmid,1));
    
    save(Res,'Fmid','-append');
    
    Tim = imread(fullfile(Impath,[Imregion,'_map.bmp']));
    try
        imshow(Tim);
    catch exception
        image(Tim);
    end
    hold on
    plot(YcoordSM./8,XcoordSM./8,'.m','markersize',6);
    saveas(gcf,fullfile(Impath,[Imregion,'_FITCfociPlot.fig']),'fig');
    hold off
    close
    
    
    % Find nearest pair of the blobs
%     XDOTS = [];
%     YDOTS = [];
%     for l = 1:(Fa+1)*(Fb+1)
%         if XD(l).XW~= 0 & YD(l).YW~=0
%             XDOTS = [XDOTS;XD(l).XW];
%             YDOTS = [YDOTS;YD(l).YW];
%         end
%     end
%     DATA = [XDOTS YDOTS];
%     
%     Resolu = 0.23;
%     XFreal = XDOTS.*Resolu;
%     YFreal = YDOTS.*Resolu;
%     ZFreal = zeros(size(XDOTS));
%     XX = [XFreal YFreal ZFreal];
%     FITCnear = Findnearest(XX);
%     [~,Fmid] = Findnnpair(FITCnear);
%     Fmid = Fmid./Resolu;
%     
%     figure(FigHandle)
%     hold on
%     plot(YDOTS,XDOTS,'.m','markersize',6);
%     fname = [num2str(Imfile(1:end-5)), num2str('CountResult')];
%     fname1 = [num2str(Imfile(1:end-5)), num2str('CountFigure')];
%     F1 = fullfile(Impath,fname);
%     save(F1,'DATA');
%     disp('The Number of FITC Foci in selected Area is ');
%     disp(size(DATA,1))
%     
%     fname2 =  [num2str(Imfile(1:end-5)), num2str('CountPair')];
%     F2 = fullfile(Impath,fname2);
%     save(F2,'Fmid');
%     
%     hold on
%     plot(Fmid(:,2),Fmid(:,1),'*w','markersize',8);
%     saveas(FigHandle,fullfile(Impath,fname1),'fig');
%     disp('The Number of FITC Foci Pairs in selected Area is ');
%     disp(size(Fmid,1))
end

if analysis(4)==1
    display('The Estimated Nuclei Number in this region is: ')
    EsNucleiNumber = round(sum(hblue)/2249.49);
    disp(EsNucleiNumber);
    save(Res,'EsNucleiNumber','-append');     
end

disp('JOB DONE!');

