function varargout = NDPanalysis(varargin)
% NDPANALYSIS M-file for NDPanalysis.fig
%      NDPANALYSIS, by itself, creates a new NDPANALYSIS or raises the existing
%      singleton*.
%
%      H = NDPANALYSIS returns the handle to a new NDPANALYSIS or the handle to
%      the existing singleton*.
%
%      NDPANALYSIS('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in NDPANALYSIS.M with the given input arguments.
%
%      NDPANALYSIS('Property','Value',...) creates a new NDPANALYSIS or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before NDPanalysis_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to NDPanalysis_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help NDPanalysis

% Last Modified by GUIDE v2.5 24-Sep-2011 14:45:29

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @NDPanalysis_OpeningFcn, ...
                   'gui_OutputFcn',  @NDPanalysis_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before NDPanalysis is made visible.
function NDPanalysis_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command measureline arguments to NDPanalysis (see VARARGIN)

% Choose default command measureline output for NDPanalysis
handles.output = hObject;

set(handles.check_step1,'Enable','off');
set(handles.check_step2,'Enable','off');
set(handles.check_step3,'Enable','off');
set(handles.check_step4,'Enable','off');
set(handles.push_Circle_Win,'Enable','off');
set(handles.push_Square_Win,'Enable','off');
set(handles.push_Polygon_Win,'Enable','off');
set(handles.push_FreeHand_Win,'Enable','off');
set(handles.edit_DAPIthresh_low,'Enable','off');
set(handles.edit_DAPIthresh_high,'Enable','off');
set(handles.edit_FITCthresh,'Enable','off');
set(handles.edit_TxRedthresh,'Enable','off');
handles.rotate = 0;
try
    matlabpool close
end
% Update handles structure
guidata(hObject, handles);

% UIWAIT makes NDPanalysis wait for user response (see UIRESUME)
% uiwait(handles.figure1);

% --- Outputs from this function are returned to the command measureline.
function varargout = NDPanalysis_OutputFcn(~, ~, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command measureline output from handles structure
varargout{1} = handles.output;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%FILE
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% --------------------------------------------------------------------
function File_Callback(~, ~, ~)
% hObject    handle to File (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% --------------------------------------------------------------------
function Open_Callback(~, ~, ~)
% hObject    handle to Open (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% --------------------------------------------------------------------
function LoadSmallImage_Callback(hObject, ~, handles)
% hObject    handle to LoadSmallImage (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global IM
[IM,Impath,Imfile,Imf,Zstack,fig] = LoadImage('small','single');
handles.Impath = Impath;
handles.Imfile = Imfile;
handles.Imf = Imf;
handles.Zstack = Zstack;
handles.size = 'small';
handles.fig = fig;
handles.rotate = 0;
set(handles.check_step1,'Enable','off');
set(handles.check_step2,'Enable','off');
set(handles.check_step3,'Enable','off');
set(handles.check_step4,'Enable','off');
set(handles.push_Circle_Win,'Enable','off');
set(handles.push_Square_Win,'Enable','off');
set(handles.push_Polygon_Win,'Enable','off');
set(handles.push_FreeHand_Win,'Enable','off');
set(handles.edit_DAPIthresh_low,'Enable','off');
set(handles.edit_DAPIthresh_high,'Enable','off');
set(handles.edit_FITCthresh,'Enable','off');
set(handles.edit_TxRedthresh,'Enable','off');
guidata(hObject,handles);

% --------------------------------------------------------------------
function LoadSmallImageStack_Callback(hObject, ~, handles)
% hObject    handle to LoadSmallImageStack (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global IM
[IM,Impath,Imfile,Imf,Zstack,fig] = LoadImage('small','multi');
handles.Impath = Impath;
handles.Imfile = Imfile;
handles.Imf = Imf;
handles.Zstack = Zstack;
handles.size = 'small';
handles.fig = fig;
handles.rotate = 0;
set(handles.check_step1,'Enable','off');
set(handles.check_step2,'Enable','off');
set(handles.check_step3,'Enable','off');
set(handles.check_step4,'Enable','off');
set(handles.push_Circle_Win,'Enable','off');
set(handles.push_Square_Win,'Enable','off');
set(handles.push_Polygon_Win,'Enable','off');
set(handles.push_FreeHand_Win,'Enable','off');
set(handles.edit_DAPIthresh_low,'Enable','off');
set(handles.edit_DAPIthresh_high,'Enable','off');
set(handles.edit_FITCthresh,'Enable','off');
set(handles.edit_TxRedthresh,'Enable','off');
guidata(hObject,handles);
% --------------------------------------------------------------------
function LoadLargeImage_Callback(hObject, ~, handles)
% hObject    handle to LoadLargeImage (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global IM
[IM,Impath,Imfile,Imf,Zstack,fig] = LoadImage('large','single');
handles.Impath = Impath;
handles.Imfile = Imfile;
handles.Imf = Imf;
handles.Zstack = Zstack;
handles.size = 'large';
handles.fig = fig;
handles.rotate = 0;
set(handles.check_step1,'Enable','off');
set(handles.check_step2,'Enable','off');
set(handles.check_step3,'Enable','off');
set(handles.check_step4,'Enable','off');
set(handles.push_Circle_Win,'Enable','off');
set(handles.push_Square_Win,'Enable','off');
set(handles.push_Polygon_Win,'Enable','off');
set(handles.push_FreeHand_Win,'Enable','off');
set(handles.edit_DAPIthresh_low,'Enable','off');
set(handles.edit_DAPIthresh_high,'Enable','off');
set(handles.edit_FITCthresh,'Enable','off');
set(handles.edit_TxRedthresh,'Enable','off');
guidata(hObject,handles);
% --------------------------------------------------------------------
function LoadLargeImageStack_Callback(hObject, ~, handles)
% hObject    handle to LoadLargeImageStack (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global IM
[IM,Impath,Imfile,Imf,Zstack,fig] = LoadImage('large','multi');
handles.Impath = Impath;
handles.Imfile = Imfile;
handles.Imf = Imf;
handles.Zstack = Zstack;
handles.size = 'large';
handles.fig = fig;
handles.rotate = 0;
set(handles.check_step1,'Enable','off');
set(handles.check_step2,'Enable','off');
set(handles.check_step3,'Enable','off');
set(handles.check_step4,'Enable','off');
set(handles.push_Circle_Win,'Enable','off');
set(handles.push_Square_Win,'Enable','off');
set(handles.push_Polygon_Win,'Enable','off');
set(handles.push_FreeHand_Win,'Enable','off');
set(handles.edit_DAPIthresh_low,'Enable','off');
set(handles.edit_DAPIthresh_high,'Enable','off');
set(handles.edit_FITCthresh,'Enable','off');
set(handles.edit_TxRedthresh,'Enable','off');
guidata(hObject,handles);
% --------------------------------------------------------------------
function CreateBatch_Callback(~, ~, ~)
% hObject    handle to CreateBatch (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%VIEW
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% --------------------------------------------------------------------
function View_Callback(~, ~, ~)
% hObject    handle to View (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% --------------------------------------------------------------------
function Adjust_Callback(~, ~, ~)
% hObject    handle to Adjust (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% --------------------------------------------------------------------
function Brightness_Callback(hObject, ~, handles)
% hObject    handle to Brightness (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
AdjustBrightness;
guidata(hObject,handles);
% --------------------------------------------------------------------
function ColorBalance_Callback(hObject, ~, handles)
% hObject    handle to ColorBalance (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
AdjustColorBalance;

global IM
global IMout
IM = IMout;
guidata(hObject,handles);
% --------------------------------------------------------------------
function Rotate_Callback(hObject, eventdata, handles)
% hObject    handle to Rotate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% --------------------------------------------------------------------
function degree90_Callback(hObject, eventdata, handles)
% hObject    handle to degree90 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global IM
IM = imrotate(IM,90);
figure(handles.fig),clf;
imshow(IM);
handles.rotate = handles.rotate+90;
guidata(hObject,handles);
% --------------------------------------------------------------------
function degree180_Callback(hObject, eventdata, handles)
% hObject    handle to degree180 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global IM
IM = imrotate(IM,180);
figure(handles.fig),clf;
imshow(IM);
handles.rotate = handles.rotate+180;
guidata(hObject,handles);
% --------------------------------------------------------------------
function degree270_Callback(hObject, eventdata, handles)
% hObject    handle to degree270 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global IM
IM = imrotate(IM,270);
figure(handles.fig),clf;
imshow(IM);
handles.rotate = handles.rotate+270;
guidata(hObject,handles);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%Tools
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% --------------------------------------------------------------------
function Tools_Callback(~, ~, handles)
% hObject    handle to Tools (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% --------------------------------------------------------------------
function SelectROI_Callback(~, ~, handles)
% hObject    handle to SelectROI (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% --------------------------------------------------------------------
function push_Circle_Callback(hObject, eventdata, handles)
% hObject    handle to push_circle_win (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global IM
sTool = 'circle';
ROIselection(IM,sTool,handles.Impath,handles.Imfile,handles.rotate,handles.size,handles.fig);
guidata(hObject,handles);
% --------------------------------------------------------------------
function push_Square_Callback(hObject, ~, handles)
% hObject    handle to push_Square_Win (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global IM
sTool = 'square';
ROIselection(IM,sTool,handles.Impath,handles.Imfile,handles.rotate,handles.size,handles.fig);
guidata(hObject,handles);
% --------------------------------------------------------------------
function push_Polygon_Callback(hObject, ~, handles)
% hObject    handle to push_polygon_win (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global IM
sTool = 'polygon';
ROIselection(IM,sTool,handles.Impath,handles.Imfile,handles.rotate,handles.size,handles.fig);
guidata(hObject,handles);
% --------------------------------------------------------------------
function push_FreeHand_Callback(hObject, ~, handles)
% hObject    handle to push_freehand_win (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global IM
sTool = 'freehand';
ROIselection(IM,sTool,handles.Impath,handles.Imfile,handles.rotate,handles.size,handles.fig);
guidata(hObject,handles);

% --------------------------------------------------------------------
function AtalsAssist_Callback(hObject, eventdata, handles)
% hObject    handle to AtalsAssist (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%ANALYSIS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% --------------------------------------------------------------------
function Analysis_Callback(~, ~, handles)
% hObject    handle to Analysis (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% --------------------------------------------------------------------
function Meansure_Callback(hObject, eventdata, handles)
% hObject    handle to Meansure (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% --------------------------------------------------------------------
function MeasureLine_Callback(hObject, eventdata, handles)
% hObject    handle to MeasureLine (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% --------------------------------------------------------------------
function push_Line_Callback(hObject, eventdata, handles)
% hObject    handle to push_Line (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% --------------------------------------------------------------------
function MeasureArea_Callback(hObject, eventdata, handles)
% hObject    handle to MeasureArea (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% --------------------------------------------------------------------
function Measure_Circle_Callback(hObject, eventdata, handles)
% hObject    handle to Measure_Circle (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function Measure_Polygon_Callback(hObject, eventdata, handles)
% hObject    handle to Measure_Polygon (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function Measure_Freehand_Callback(hObject, eventdata, handles)
% hObject    handle to Measure_Freehand (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% --------------------------------------------------------------------
function Histogram_Callback(hObject, eventdata, handles)
% hObject    handle to Histogram (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% --------------------------------------------------------------------
function LineProfile_Callback(hObject, eventdata, handles)
% hObject    handle to LineProfile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% --------------------------------------------------------------------
function FISHanalysis_Callback(hObject, eventdata, handles)
% hObject    handle to FISHanalysis (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% --------------------------------------------------------------------
function FISHautomated_Callback(hObject, eventdata, handles)
% hObject    handle to FISHautomated (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
warndlg('Follow the steps show on the screen, then click RUN button');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%AUTOMATED ANALYSIS OF FISH IMAGES STEPS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%STEP 1%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% --- Executes on button press in radio_DAPIdye.
function radio_DAPIdye_Callback(hObject, eventdata, handles)
% hObject    handle to radio_DAPIdye (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radio_DAPIdye
guidata(hObject,handles);
% --- Executes on button press in radio_FITCdye.
function radio_FITCdye_Callback(hObject, eventdata, handles)
% hObject    handle to radio_FITCdye (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radio_FITCdye
set(handles.check_step1,'Enable','on');
set(handles.check_step1,'Value',1);
guidata(hObject,handles);
% --- Executes on button press in radio_TxReddye.
function radio_TxReddye_Callback(hObject, eventdata, handles)
% hObject    handle to radio_TxReddye (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radio_TxReddye
set(handles.check_step1,'Enable','on');
set(handles.check_step1,'Value',1);
guidata(hObject,handles);
% --- Executes on button press in check_step1.
function check_step1_Callback(hObject, eventdata, handles)
% hObject    handle to check_step1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of check_step1
if get(hObject,'Value') == 0
    set(handles.radio_DAPIdye,'Value',0);
    set(handles.radio_FITCdye,'Value',0);
    set(handles.radio_TxReddye,'Value',0);
    set(handles.check_step1,'Enable','off');
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%STEP 2%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% --- Executes on button press in push_selectall.
function push_selectall_Callback(hObject, ~, handles)
% hObject    handle to push_selectall (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.check_step2,'Enable','on');
set(handles.check_step2,'Value',1);
set(handles.push_ROIselect,'Enable','off');
set(handles.push_ROIprevious,'Enable','off');
handles.ROIcondition = 'all';
guidata(hObject,handles);
% --- Executes on button press in push_ROIprevious.
function push_ROIprevious_Callback(hObject, eventdata, handles)
% hObject    handle to push_ROIprevious (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% --- Executes on button press in push_ROIselect.
set(handles.check_step2,'Enable','on');
set(handles.check_step2,'Value',1);
set(handles.push_ROIselect,'Enable','off');
set(handles.push_selectall,'Enable','off');
handles.ROIcondition = 'ROIpre';
guidata(hObject,handles);
function push_ROIselect_Callback(hObject, eventdata, handles)
% hObject    handle to push_ROIselect (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.push_Circle_Win,'Enable','on');
set(handles.push_Square_Win,'Enable','on');
set(handles.push_Polygon_Win,'Enable','on');
set(handles.push_FreeHand_Win,'Enable','on');
set(handles.push_selectall,'Enable','off');
set(handles.push_ROIprevious,'Enable','off');
handles.ROIcondition = 'ROInow';
guidata(hObject,handles);
% --------------------------------------------------------------------
function push_Circle_Win_Callback(hObject, eventdata, handles)
% hObject    handle to push_circle_win (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global IM
sTool = 'circle';
set(handles.push_Circle_Win,'Enable','off');
set(handles.push_Square_Win,'Enable','off');
set(handles.push_Polygon_Win,'Enable','off');
set(handles.push_FreeHand_Win,'Enable','off');
ROIselection(IM,sTool,handles.Impath,handles.Imfile,handles.rotate,handles.size,handles.fig);
set(handles.push_Circle_Win,'Enable','on');
set(handles.push_Square_Win,'Enable','on');
set(handles.push_Polygon_Win,'Enable','on');
set(handles.push_FreeHand_Win,'Enable','on');
set(handles.check_step2,'Enable','on');
set(handles.check_step2,'Value',1);
guidata(hObject,handles);
% --------------------------------------------------------------------
function push_Square_Win_Callback(hObject, ~, handles)
% hObject    handle to push_Square_Win (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global IM
sTool = 'square';
set(handles.push_Circle_Win,'Enable','off');
set(handles.push_Square_Win,'Enable','off');
set(handles.push_Polygon_Win,'Enable','off');
set(handles.push_FreeHand_Win,'Enable','off');
ROIselection(IM,sTool,handles.Impath,handles.Imfile,handles.rotate,handles.size,handles.fig);
set(handles.push_Circle_Win,'Enable','on');
set(handles.push_Square_Win,'Enable','on');
set(handles.push_Polygon_Win,'Enable','on');
set(handles.push_FreeHand_Win,'Enable','on');
set(handles.check_step2,'Enable','on');
set(handles.check_step2,'Value',1);
guidata(hObject,handles);
% --------------------------------------------------------------------
function push_Polygon_Win_Callback(hObject, ~, handles)
% hObject    handle to push_polygon_win (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global IM
sTool = 'polygon';
set(handles.push_Circle_Win,'Enable','off');
set(handles.push_Square_Win,'Enable','off');
set(handles.push_Polygon_Win,'Enable','off');
set(handles.push_FreeHand_Win,'Enable','off');
ROIselection(IM,sTool,handles.Impath,handles.Imfile,handles.rotate,handles.size,handles.fig);
set(handles.push_Circle_Win,'Enable','on');
set(handles.push_Square_Win,'Enable','on');
set(handles.push_Polygon_Win,'Enable','on');
set(handles.push_FreeHand_Win,'Enable','on');
set(handles.check_step2,'Enable','on');
set(handles.check_step2,'Value',1);
guidata(hObject,handles);
% --- Executes on button press in push_FreeHand_Win.
function push_FreeHand_Win_Callback(hObject, ~, handles)
% hObject    handle to push_FreeHand_Win (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global IM
sTool = 'freehand';
set(handles.push_Circle_Win,'Enable','off');
set(handles.push_Square_Win,'Enable','off');
set(handles.push_Polygon_Win,'Enable','off');
set(handles.push_FreeHand_Win,'Enable','off');
ROIselection(IM,sTool,handles.Impath,handles.Imfile,handles.rotate,handles.size,handles.fig);
set(handles.push_Circle_Win,'Enable','on');
set(handles.push_Square_Win,'Enable','on');
set(handles.push_Polygon_Win,'Enable','on');
set(handles.push_FreeHand_Win,'Enable','on');
set(handles.check_step2,'Enable','on');
set(handles.check_step2,'Value',1);
guidata(hObject,handles);
% --- Executes on button press in check_step2.
function check_step2_Callback(hObject, ~, handles)
% hObject    handle to check_step2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of check_step2
if get(hObject,'Value') == 0
    set(handles.push_selectall,'Enable','on');
    set(handles.push_ROIselect,'Enable','on');
    set(handles.push_ROIprevious,'Enable','on');
    set(handles.check_step2,'Enable','off');
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%STEP 3%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% --- Executes on button press in push_autothresh.
function push_autothresh_Callback(hObject, ~, handles)
% hObject    handle to push_autothresh (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.check_step3,'Enable','on');
set(handles.check_step3,'Value',1);
set(handles.push_manualthresh,'Enable','off');
handles.thresh = [];
guidata(hObject,handles);
% --- Executes on button press in push_manualthresh.
function push_manualthresh_Callback(hObject, ~, handles)
% hObject    handle to push_manualthresh (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.edit_DAPIthresh_low,'Enable','on');
set(handles.edit_DAPIthresh_high,'Enable','on');
set(handles.edit_FITCthresh,'Enable','on');
set(handles.edit_TxRedthresh,'Enable','on');
set(handles.check_step3,'Enable','on');
set(handles.check_step3,'Value',1);
handles.thresh = zeros(1,4);
guidata(hObject,handles);
function edit_DAPIthresh_low_Callback(hObject, eventdata, handles)
% hObject    handle to edit_DAPIthresh_low (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_DAPIthresh_low as text
%        str2double(get(hObject,'String')) returns contents of edit_DAPIthresh_low as a double
% --- Executes during object creation, after setting all properties.
handles.thresh(1,1) = str2num(get(hObject,'String'));
guidata(hObject,handles);
function edit_DAPIthresh_low_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_DAPIthresh_low (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function edit_DAPIthresh_high_Callback(hObject, eventdata, handles)
% hObject    handle to edit_DAPIthresh_high (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hints: get(hObject,'String') returns contents of edit_DAPIthresh_high as text
%        str2double(get(hObject,'String')) returns contents of edit_DAPIthresh_high as a double
% --- Executes during object creation, after setting all properties.
handles.thresh(1,2) = str2num(get(hObject,'String'));
guidata(hObject,handles);
function edit_DAPIthresh_high_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_DAPIthresh_high (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function edit_FITCthresh_Callback(hObject, eventdata, handles)
% hObject    handle to edit_FITCthresh (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hints: get(hObject,'String') returns contents of edit_FITCthresh as text
%        str2double(get(hObject,'String')) returns contents of edit_FITCthresh as a double
% --- Executes during object creation, after setting all properties.
handles.thresh(1,3) = str2num(get(hObject,'String'));
guidata(hObject,handles);
function edit_FITCthresh_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_FITCthresh (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function edit_TxRedthresh_Callback(hObject, eventdata, handles)
% hObject    handle to edit_TxRedthresh (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hints: get(hObject,'String') returns contents of edit_TxRedthresh as text
%        str2double(get(hObject,'String')) returns contents of edit_TxRedthresh as a double
% --- Executes during object creation, after setting all properties.
handles.thresh(1,4) = str2num(get(hObject,'String'));
guidata(hObject,handles);
function edit_TxRedthresh_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_TxRedthresh (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
% --- Executes on button press in check_step3.
function check_step3_Callback(hObject, ~, handles)
% hObject    handle to check_step3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hint: get(hObject,'Value') returns toggle state of check_step3
if get(hObject,'Value') == 0
    set(handles.push_autothresh,'Enable','on');
    set(handles.push_manualthresh,'Enable','on');
    set(handles.check_step3,'Enable','off');
    set(handles.edit_DAPIthresh_low,'Enable','off');
    set(handles.edit_DAPIthresh_high,'Enable','off');
    set(handles.edit_FITCthresh,'Enable','off');
    set(handles.edit_TxRedthresh,'Enable','off');
end
% --- Executes on button press in push_threshassist.
function push_threshassist_Callback(hObject, eventdata, handles)
% hObject    handle to push_threshassist (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
ThreshAssist(IM,handles.size,handles.fig);
%IEGfoci(IM,handles.stain,handles.analysis,handles.Impath,handles.Imfile,handles.Imf,...
%handles.Zstack,handles.size,handles.ROIcondition,handles.thresh);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%STEP 4%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% --- Executes on button press in radio_RunPixel.
function radio_RunPixel_Callback(hObject, eventdata, handles)
% hObject    handle to radio_RunPixel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hint: get(hObject,'Value') returns toggle state of radio_RunPixel
set(handles.check_step4,'Enable','on');
set(handles.check_step4,'Value',1);
guidata(hObject,handles);
% --- Executes on button press in radio_RunIntensity.
function radio_RunIntensity_Callback(hObject, ~, handles)
% hObject    handle to radio_RunIntensity (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hint: get(hObject,'Value') returns toggle state of radio_RunIntensity
set(handles.check_step4,'Enable','on');
set(handles.check_step4,'Value',1);
guidata(hObject,handles);
% --- Executes on button press in radio_RunFoci.
function radio_RunFoci_Callback(hObject, eventdata, handles)
% hObject    handle to radio_RunFoci (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hint: get(hObject,'Value') returns toggle state of radio_RunFoci
set(handles.check_step4,'Enable','on');
set(handles.check_step4,'Value',1);
guidata(hObject,handles);
% --- Executes on button press in radio_RunNuclei.
function radio_RunNuclei_Callback(hObject, eventdata, handles)
% hObject    handle to radio_RunNuclei (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hint: get(hObject,'Value') returns toggle state of radio_RunNuclei
set(handles.check_step4,'Enable','on');
set(handles.check_step4,'Value',1);
guidata(hObject,handles);
% --- Executes on button press in check_step4.
function check_step4_Callback(hObject, eventdata, handles)
% hObject    handle to check_step4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hint: get(hObject,'Value') returns toggle state of check_step4
if get(hObject,'Value') == 0
    set(handles.radio_RunPixel,'Value',0);
    set(handles.radio_RunIntensity,'Value',0);
    set(handles.radio_RunFoci,'Value',0);
    set(handles.radio_RunNuclei,'Value',0);
    set(handles.check_step4,'Enable','off');
end
guidata(hObject,handles);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%RUN 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% --- Executes on button press in push_SaveandRun.
function push_SaveandRun_Callback(hObject, eventdata, handles)
% hObject    handle to push_SaveandRun (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global IM
handles.stain = [get(handles.radio_DAPIdye,'Value'),...
    get(handles.radio_FITCdye,'Value'),get(handles.radio_TxReddye,'Value')];
handles.analysis = [get(handles.radio_RunPixel,'Value'),...            
    get(handles.radio_RunIntensity,'Value'),...
    get(handles.radio_RunFoci,'Value'),...
    get(handles.radio_RunNuclei,'Value')];

IEGfoci(IM,handles.stain,handles.analysis,handles.Impath,handles.Imfile,handles.Imf,...
    handles.Zstack,handles.size,handles.ROIcondition,handles.thresh);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%End of Auto Analysis.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% --------------------------------------------------------------------
function FISHmanual_Callback(hObject, eventdata, handles)
% hObject    handle to FISHmanual (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%Reprot into PDF DOCUMENT
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% --------------------------------------------------------------------
function Report_Callback(hObject, eventdata, handles)
% hObject    handle to Report (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%HELP DOCUMENT
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% --------------------------------------------------------------------
function Help_Callback(hObject, eventdata, handles)
% hObject    handle to Help (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%Exit
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% --------------------------------------------------------------------
function Exit_Callback(hObject, eventdata, handles)
% hObject    handle to Exit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

