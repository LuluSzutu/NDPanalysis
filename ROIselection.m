function ROIselection(IM,sTool,Impath,Imfile,rotation,IMSIZE,fig)
global IM
figure(fig);
set(gcf,'units','pixel');
% % Pos = get(gcf,'position');
% draw = findobj(gca,'Type','line');
% delete(draw);
if strcmp(sTool,'circle')
    H = imellipse;
elseif strcmp(sTool,'square')
    H = imrect;
elseif strcmp(sTool,'polygon')
    H = impoly;
elseif strcmp(sTool,'freehand')
    H = imfreehand(gca,'Closed','True');
end

% str = date;
% Impath = fullfile(Impath,['ROIImages',str]);
% D = dir([Impath,'*']);
% nn = 0;
% for i = 1:size(D,1)
%     if D(i).isdir == 1
%         nn = nn+1;
%     end
% end
% if nn > 0
%     mkdir([Impath,'_',num2str(nn)]);
%     folder = [Impath,'_',num2str(nn)];
% else
%     mkdir(Impath);
%     folder = Impath;
% end

ConfirmFig = figure(...
    'Name','ROI Selection', ...
    'NumberTitle','off', ...
    'MenuBar','none', ...,
    'Resize', 'Off', ...
    'Units', 'pixel', ...
    'Toolbar','none',...
    'Position',[1200 500 200 75]);
uicontrol('Parent', ConfirmFig, 'Style','text',...
    'String','Satisfy with the contour you drew?',...
    'Position', [25 40 150 25],'FontSize',9,'ForegroundColor','blue','FontUnits','points',...
    'FontName','Times New Roman','BackgroundColor',[0.8 0.8 0.8]);
confirmok = uicontrol('Parent', ConfirmFig, 'Style','togglebutton',...
    'String','OK','Position', [30 10 50 25],'Callback','uiresume(gcbf)');
confirmno = uicontrol('Parent', ConfirmFig, 'Style','togglebutton',...
    'String','REDRAW','Position', [120 10 50 25],'Callback','uiresume(gcbf)');
uiwait(gcf);
uicontrol(confirmok);
uicontrol(confirmno);

if get(confirmok,'Value') == 1
    close(ConfirmFig);
    Mask = createMask(H);
    M(:,:,1) = Mask;
    M(:,:,2) = Mask;
    M(:,:,3) = Mask;
    if strcmp(IMSIZE,'small')
        SizeofMask = size(find(Mask>0),1);
    else
        SizeofMask = size(find(Mask>0),1)*64;
    end
    display('The area of the select region by pixel is: ');
    display(SizeofMask);
    display('The physical area of the select region in square micron meter is: ');
    display(SizeofMask*0.0529);
    II = uint8(M).*IM;
    f = find(Mask>=1);
    [fx,fy] = ind2sub(size(Mask),f);
    rect = [min(fy(:)) min(fx(:)) max(fy(:))-min(fy(:)) max(fx(:))-min(fx(:))];
    Icrop = imcrop(II,rect);
    figure;
    imshow(Icrop);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%Save the croped image and result%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    NameFig = figure(...
        'Name','warning', ...
        'NumberTitle','off', ...
        'MenuBar','none', ...,
        'Resize', 'Off', ...
        'Units', 'pixel', ...
        'Toolbar','none',...
        'Position',[1200 500 200 75]);
    starttext = uicontrol('Parent', NameFig, 'Style','text',...
        'String','Region Name:',...
        'Position', [25 40 70 25],'FontSize',8,'ForegroundColor','blue','FontUnits','points',...
        'FontName','Times New Roman','BackgroundColor',[0.8 0.8 0.8]);
    startedit = uicontrol('Parent', NameFig, 'Style','edit',...
        'String',' ',...
        'Position', [105 40 70 25]);
    startstart = uicontrol('Parent', NameFig, 'Style','togglebutton',...
        'String','OK','value',0,...
        'Position', [80 10 40 25],'Callback','uiresume(gcbf)');
    uiwait(gcf);
    uicontrol(startedit);
    uicontrol(startstart);
    RegionName = get(startedit,'String');
    close(NameFig);
    while RegionName(end) == ' '
        RegionName = RegionName(1:end-1);
    end  
    Imfile = [num2str(Imfile),'ROI','_',num2str(RegionName)];    
    Rfile = fullfile(Impath,Imfile);
    if strcmp(IMSIZE,'small')
        imwrite(Icrop,[num2str(Rfile),'_raw.bmp']);
    else
        imwrite(Icrop,[num2str(Rfile),'_map.bmp']);
    end
    Rfile = [fullfile(Impath,Imfile),'_mask.mat'];    
    save(Rfile,'Mask','rect','rotation');    
elseif get(confirmno,'Value') == 1;
    close(ConfirmFig);
    delete(H);
    return;
end 
    
IM = Icrop;

    
