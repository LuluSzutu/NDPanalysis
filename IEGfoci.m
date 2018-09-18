function IEGfoci(IM,stain,analysis,Impath,Imfile,Imf,Zstack,IMSIZE,ROIcondition,thresh)

close all

tic

if strcmp(ROIcondition,'all')
    Iwidth = Imf(1).Width;
    Iheight = Imf(1).Height;
    if strcmp(IMSIZE,'small')
        
        matlabpool local
        
        if stain == [1 1 0]
            if isempty(Zstack)
                NDPrunFITC2D(IM,Impath,Imfile,Iwidth,Iheight,analysis,thresh);
            else
                NDPrunFITC3D(IM,Impath,Imfile,Iwidth,Iheight,analysis,thresh,Zstack);
            end
        elseif stain == [1 0 1]
            if isempty(Zstack)
                NDPrunTxRed2D(IM,Impath,Imfile,Iwidth,Iheight,analysis,thresh);
            else
                NDPrunTxRed3D(IM,Impath,Imfile,Iwidth,Iheight,analysis,thresh,Zstack);
            end
        elseif stain == [1 1 1]
            if isempty(Zstack)
                NDPrunDouble2D(IM,Impath,Imfile,Iwidth,Iheight,analysis,thresh);
            else
                NDPrunDouble3D(IM,Impath,Imfile,Iwidth,Iheight,analysis,thresh,Zstack);
            end
        end
    else
        
        try
            matlabpool
        catch exception
            matlabpool local
            warndlg('The Matlab Cluster doesnot work. The program will use local parallel computing instead.This may cause program slow or corrupt!');
        end

        Iname = ['"',fullfile(Impath,Imfile),'"',' '];
        f = fullfile(Impath,[Imfile(1:end-5),'_TempSubimage']);
        mkdir(f);
        foutput = ['"',f,'"','\ '];
        rect = [num2str([0 0 Iwidth-1 Iheight-1]),' '];
        Imfile1 = ['"',Imfile,'"'];
        w = warndlg('The system is preparing the sub-images. It will take minutes to even hours to finish.Please wait...');
        ew = findobj(w,'Style','pushbutton');
        delete(ew);
        system(['LucyNDP.exe ',Iname,rect,foutput,Imfile1]);
        close(w);
        if stain == [1 1 0]
            if isempty(Zstack)
                FITCfoci2D(IM,Impath,Imfile,Iwidth,Iheight,analysis,thresh);
                rmdir(f,'s');
            else
                FITCfoci3D(IM,Impath,Imfile,Imf,Iwidth,Iheight,analysis,thresh,Zstack);
                rmdir(f,'s');
            end
        elseif stain == [1 0 1]
            if isempty(Zstack)
                TxRedfoci2D(IM,Impath,Imfile,Iwidth,Iheight,analysis,thresh);
                rmdir(f,'s');
            else
                TxRedfoci3D(IM,Impath,Imfile,Imf,Iwidth,Iheight,analysis,thresh,Zstack);
                rmdir(f,'s');
            end
        elseif stain == [1 1 1]
            if isempty(Zstack)
                Doublefoci2D(IM,Impath,Imfile,Iwidth,Iheight,analysis,thresh);
                rmdir(f,'s');
            else
                Doublefoci3D(IM,Impath,Imfile,Imf,Iwidth,Iheight,analysis,thresh,Zstack);
                rmdir(f,'s');
            end
        end
    end    
else
    if strcmp(ROIcondition,'ROInow')
        n = 0;
        ct = datestr(clock);
        Dimage = dir([Impath,'\',Imfile,'ROI','*.bmp']);
        for i = 1:size(Dimage,1)
            dt = Dimage(i).date;
            cd = ct-dt;
            if cd(1:15) == 0
                n = n+1;
                ImList(n).name = Dimage(i).name;
            end
        end
    elseif strcmp(ROIcondition,'ROIpre')
        if strcmp(IMSIZE,'small')
            Dimage = dir([Impath,'\',Imfile,'ROI','*_raw.bmp']);
        else
            Dimage = dir([Impath,'\',Imfile,'ROI','*_map.bmp']);
        end
        if size(Dimage,1) == 0
            errordlg('There is no Pre-Selected ROI in given directory!')
            return;
        end
        for i = 1:size(Dimage,1)
            ImList(i).name = Dimage(i).name;
        end
    end
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%Check the ROIs going to process
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
          
    for i = 1:size(ImList,2)
        display(['Now Processing the ROI:  ',ImList(i).name]);
        if strcmp(IMSIZE,'small')
            
            matlabpool local
            
            I = imread(fullfile(Impath,ImList(i).name)); 
            Imregion = ImList(i).name;
            Imregion = Imregion(1:end-8);
            load([fullfile(Impath,Imregion), '_mask.mat']);
            rot = rem(rotation,360);
            M = imrotate(Mask,360-rot);
            fim = find(M>=1);
            [fx,fy] = ind2sub(size(M),fim);
            rect = [min(fy(:)) min(fx(:)) max(fy(:))-min(fy(:)) max(fx(:))-min(fx(:))];
            if stain == [1 1 0]
                if isempty(Zstack)
                    NDPrunFITC2D_wMASK(I,Impath,Imregion,analysis,thresh,Mask,rect,rot);
                else
                    NDPrunFITC3D_wMASK(I,Impath,Imregion,Imf,analysis,thresh,Mask,rect,rot,Zstack);
                end
            elseif stain == [1 0 1]
                if isempty(Zstack)
                    NDPrunTxRed2D_wMASK(I,Impath,Imregion,analysis,thresh,Mask,rect,rot);
                else
                    NDPrunTxRed3D_wMASK(I,Impath,Imregion,Imf,analysis,thresh,Mask,rect,rot,Zstack);
                end
            elseif stain == [1 1 1]
                if isempty(Zstack)
                    NDPrunDouble2D_wMASK(I,Impath,Imfile,analysis,thresh,Mask,rect,rot);
                else
                    NDPrunDouble3D_wMASK(I,Impath,Imfile,Imf,analysis,thresh,rect,Zstack);
                end
            end 
        else
            try
                matlabpool
            catch exception
                matlabpool local
                warndlg('The Matlab Cluster doesnot work. The program will use local parallel computing instead.This may cause program slow or corrupt!');
            end
            
            Iname = ['"',fullfile(Impath,Imfile),'"',' '];
            Imregion = ImList(i).name;
            Imregion = Imregion(1:end-8);
            f = fullfile(Impath,[Imregion,'_TempSubimage']);
            mkdir(f);
            foutput = ['"',f,'"','\ '];
            Imfile1 = ['"',Imfile,'"'];
            load([fullfile(Impath,Imregion), '_mask.mat']);
            rot = rem(rotation,360);
            M = imrotate(Mask,360-rot);
            fim = find(M>=1);
            [fx,fy] = ind2sub(size(M),fim);
            rect = [min(fy(:))-1 min(fx(:))-1 max(fy(:))-min(fy(:))+1 max(fx(:))-min(fx(:))+1];
            Mcrop = imcrop(M,rect);
            rect = rect.*8;
            Mcrop = imresize(Mcrop,8);
            rect1 = [num2str(rect),' '];
            w = warndlg('The system is preparing the sub-images. It will take minutes to even hours to finish.Please wait...');
            ew = findobj(w,'Style','pushbutton');
            delete(ew);
            system(['LucyNDP.exe ',Iname,rect1,foutput,Imfile1]);
            close(w);
            if stain == [1 1 0]
                if isempty(Zstack)
                    FITCfoci2D_wMASK(IM,Impath,Imfile,Imregion,analysis,thresh,Mcrop,rect,rot);
                    rmdir(f,'s');
                else
                    FITCfoci3D_wMASK(IM,Impath,Imfile,Imregion,Imf,analysis,thresh,Mcrop,rect,rot,Zstack);
                    rmdir(f,'s');
                end
            elseif stain == [1 0 1]
                if isempty(Zstack)
                    TxRedfoci2D_wMASK(IM,Impath,Imfile,Imregion,analysis,thresh,Mcrop,rect);
                    rmdir(f,'s');
                else
                    TxRedfoci3D_wMASK(IM,Impath,Imfile,Imregion,Imf,analysis,thresh,Mcrop,rect,Zstack);
                    rmdir(f,'s');
                end
            elseif stain == [1 1 1]
                if isempty(Zstack)
                    Doublefoci2D_wMASK(IM,Impath,Imfile,Imregion,analysis,thresh,Mcrop,rect);
                    rmdir(f,'s');
                else
                    Doublefoci3D_wMASK(IM,Impath,Imfile,Imregion,Imf,analysis,thresh,Mcrop,rect,rot,Zstack);
                    rmdir(f,'s');
                end
            end
        end
    end
end

matlabpool close
toc
   


