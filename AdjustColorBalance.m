function varargout = AdjustColorBalance(varargin)
% ADJUSTCOLORBALANCE MATLAB code for AdjustColorBalance.fig
%      ADJUSTCOLORBALANCE, by itself, creates a new ADJUSTCOLORBALANCE or raises the existing
%      singleton*.
%
%      H = ADJUSTCOLORBALANCE returns the handle to a new ADJUSTCOLORBALANCE or the handle to
%      the existing singleton*.
%
%      ADJUSTCOLORBALANCE('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in ADJUSTCOLORBALANCE.M with the given input arguments.
%
%      ADJUSTCOLORBALANCE('Property','Value',...) creates a new ADJUSTCOLORBALANCE or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before AdjustColorBalance_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to AdjustColorBalance_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help AdjustColorBalance

% Last Modified by GUIDE v2.5 09-Dec-2010 16:55:23

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @AdjustColorBalance_OpeningFcn, ...
                   'gui_OutputFcn',  @AdjustColorBalance_OutputFcn, ...
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

% --- Executes just before AdjustColorBalance is made visible.
function AdjustColorBalance_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to AdjustColorBalance (see VARARGIN)

% Choose default command line output for AdjustColorBalance
handles.output = hObject;

set(handles.slider_Red,'Value',0.5);
set(handles.slider_Green,'Value',0.5);
set(handles.slider_Blue,'Value',0.5);

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes AdjustColorBalance wait for user response (see UIRESUME)
% uiwait(handles.figure1);

% --- Outputs from this function are returned to the command line.
function varargout = AdjustColorBalance_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

% --- Executes on slider movement.
function slider_Red_Callback(hObject, eventdata, handles)
% hObject    handle to slider_Red (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
handles.SliderValue = get(handles.slider_Red,'Value');

% --- Executes during object creation, after setting all properties.
function slider_Red_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider_Red (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

% --- Executes on slider movement.
function slider_Green_Callback(hObject, eventdata, handles)
% hObject    handle to slider_Green (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider

% --- Executes during object creation, after setting all properties.
function slider_Green_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider_Green (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

% --- Executes on slider movement.
function slider_Blue_Callback(hObject, eventdata, handles)
% hObject    handle to slider_Blue (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider

% --- Executes during object creation, after setting all properties.
function slider_Blue_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider_Blue (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

% --- Executes on button press in push_RedReset.
function push_RedReset_Callback(hObject, eventdata, handles)
% hObject    handle to push_RedReset (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% --- Executes on button press in push_GreenReset.
function push_GreenReset_Callback(hObject, eventdata, handles)
% hObject    handle to push_GreenReset (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% --- Executes on button press in push_BlueReset.
function push_BlueReset_Callback(hObject, eventdata, handles)
% hObject    handle to push_BlueReset (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
