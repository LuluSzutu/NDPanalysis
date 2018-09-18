function [IM,Impath,Imfile,Imf,Zstack,fig] = LoadImage(varargin)

global IM

u = varargin{1};
v = varargin{2};

if strcmp(u,'small') && strcmp(v,'single')
    Zstack = [];
    [Imfile,Impath] = uigetfile({'*.*'},'Pick a file');
    Imf = imfinfo(fullfile(Impath,Imfile));
    if Imf(1).Width > 20000 || Imf(1).Height > 20000
        choice = questdlg('The image you try to open is relatively large, consider using open "large scale image" instead. Continue loading this image may cause image corruption. Do you want to continue?',...
            'Warning!!','Yes','No','No');
        switch choice
            case 'No'
                return;
            case 'Yes'
                IM = imread(fullfile(Impath,Imfile));
                if max(IM(:)) == 0
                    errordlg('Image corruption!!');
                    return;
                end                
                fig = figure('Name','Image','MenuBar','none','Toolbar','figure');
                try
                    imshow(IM);
                catch exception
                    image(IM);
                    warndlg('Program: Can not find Image Processing Toolbox. This will cause function of ROI selection, adjust brightness, image rotate etc. not working!');
                end
        end
    else
        IM = imread(fullfile(Impath,Imfile));
                if max(IM(:)) == 0
                    errordlg('Image corruption!!');
                    return;
                end                
                fig = figure('Name','Image','MenuBar','none','Toolbar','figure');
                try
                    imshow(IM);
                catch exception
                    image(IM);
                    warndlg('Program: Can not find Image Processing Toolbox. This will cause function of ROI selection, adjust brightness, image rotate etc. not working!');
                end
    end
elseif strcmp(u,'small') && strcmp(v,'multi')
    [Imfile,Impath] = uigetfile({'*.ndpi'},'Pick a file');
    Imf = imfinfo(fullfile(Impath,Imfile));
    Zstack = [];
    for i = 1:numel(Imf)
        if Imf(i).Width == Imf(1).Width
            Zstack(end+1) = i;
        end
    end
    medZ = median(Zstack);
    IM = imread(fullfile(fullfile(Impath,Imfile)),medZ);
    fig = figure('Name','Image','MenuBar','none','Toolbar','figure');
    try
        imshow(IM);
    catch exception
        image(IM);
        warndlg('Program: Can not find Image Processing Toolbox. This will cause function of ROI selection, adjust brightness, image rotate etc. not working!');
    end
elseif strcmp(u,'large') && strcmp(v,'single')
    Zstack = [];
    [Imfile,Impath] = uigetfile({'*.ndpi'},'Pick a file');
    w = warndlg('The system is preparing the image map. Please wait...');
    ew = findobj(w,'Style','pushbutton');
    delete(ew);
    fname = ['"' fullfile(Impath,Imfile) '"'];
    system(['NDPpreprocess.exe ',fname]);
    Imf = imfinfo(fullfile(Impath,Imfile));
    Widlarge = abs(Imf(1).Width);
    Heilarge = abs(Imf(1).Height);
    Imfile1 = [Imfile,'_map.bmp'];
    Imfmap = imfinfo(fullfile(Impath,Imfile1));
    Widsmall = abs(Imfmap.Width);
    Heismall = abs(Imfmap.Height);
    Wrat = Widlarge/Widsmall;
    Hrat = Heilarge/Heismall;
    if Wrat ~= Hrat
        errordlg('Unexpect Error: large and small image is not match, ask producer for detail');
    end
    IM = imread(fullfile(Impath,Imfile1));
    fig = figure('Name','Image','MenuBar','none','Toolbar','figure');
    try
        imshow(IM);
    catch exception
        image(IM);
        warndlg('Program: Can not find Image Processing Toolbox. This will cause function of ROI selection, adjust brightness, image rotate etc. not working!');
    end
    close(w);
elseif strcmp(u,'large') && strcmp(v,'multi')
    [Imfile,Impath] = uigetfile({'*.ndpi'},'Pick a file');
    w = warndlg('The system is preparing the image map. Please wait...');
    ew = findobj(w,'Style','pushbutton');
    delete(ew);
    fname = ['"' fullfile(Impath,Imfile) '"'];
    system(['NDPpreprocess.exe ',fname]);
    Imf = imfinfo(fullfile(Impath,Imfile));
    Widlarge = abs(Imf(1).Width);
    Heilarge = abs(Imf(1).Height);
    Zstack = [];
    for i = 1:numel(Imf)
        if Imf(i).Width == Imf(1).Width
            Zstack(end+1) = i;
        end
    end
    Imfile1 = [Imfile,'_map.bmp'];
    Imfmap = imfinfo(fullfile(Impath,Imfile1));
    Widsmall = abs(Imfmap.Width);
    Heismall = abs(Imfmap.Height);
    Wrat = Widlarge/Widsmall;
    Hrat = Heilarge/Heismall;
    if Wrat ~= Hrat
        errordlg('Unexpect Error: large and small image is not match, ask producer for detail');
    end
    IM = imread(fullfile(Impath,Imfile1));
    fig = figure('Name','Image','MenuBar','none','Toolbar','figure');
    try
        imshow(IM);
    catch exception
        image(IM);
        warndlg('Program: Can not find Image Processing Toolbox. This will cause function of ROI selection, adjust brightness, image rotate etc. not working!');
    end
    close(w);
end
