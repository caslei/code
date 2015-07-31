function varargout = select_optimal_params(varargin)
% SELECT_OPTIMAL_PARAMS MATLAB code for select_optimal_params.fig
%      SELECT_OPTIMAL_PARAMS, by itself, creates a new SELECT_OPTIMAL_PARAMS or raises the existing
%      singleton*.
%
%      H = SELECT_OPTIMAL_PARAMS returns the handle to a new SELECT_OPTIMAL_PARAMS or the handle to
%      the existing singleton*.
%
%      SELECT_OPTIMAL_PARAMS('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in SELECT_OPTIMAL_PARAMS.M with the given input arguments.
%
%      SELECT_OPTIMAL_PARAMS('Property','Value',...) creates a new SELECT_OPTIMAL_PARAMS or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before select_optimal_params_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to select_optimal_params_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help select_optimal_params

% Last Modified by GUIDE v2.5 31-Jul-2015 09:39:17

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @select_optimal_params_OpeningFcn, ...
                   'gui_OutputFcn',  @select_optimal_params_OutputFcn, ...
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


% --- Executes just before select_optimal_params is made visible.
function select_optimal_params_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to select_optimal_params (see VARARGIN)

% Choose default command line output for select_optimal_params
handles.output = hObject;
handles.params = varargin{1};
handles.pms = varargin{2};
handles.bg = varargin{3};
handles.img = varargin{4};
handles.class_pms = update_class_pms(handles);
update_sliders(handles);
update_text(handles);
update_images(handles);

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes select_optimal_params wait for user response (see UIRESUME)


% --- Outputs from this function are returned to the command line.
function varargout = select_optimal_params_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


function class_pms = update_class_pms(handles)
params = handles.params;
pms = handles.pms;
n_features = size(pms,3);
n_classes = size(pms,4);
class_pms = zeros(size(pms,1),size(pms,2),n_classes);
for nc=1:n_classes
    for nf=1:n_features
        class_pms(:,:,nc) = class_pms(:,:,nc) + params(nf,nc).*pms(:,:,nf,nc);
    end
end

function [] = update_sliders(handles)
set(handles.slider1,  'value', handles.params(1,1));
set(handles.slider2,  'value', handles.params(1,2));
set(handles.slider3,  'value', handles.params(1,3));
set(handles.slider4,  'value', handles.params(2,1));
set(handles.slider5,  'value', handles.params(2,2));
set(handles.slider6,  'value', handles.params(2,3));
set(handles.slider7,  'value', handles.params(3,1));
set(handles.slider8,  'value', handles.params(3,2));
set(handles.slider9,  'value', handles.params(3,3));
set(handles.slider10, 'value', handles.params(4,1));
set(handles.slider11, 'value', handles.params(4,2));
set(handles.slider12, 'value', handles.params(4,3));
set(handles.slider13, 'value', handles.params(5,1));
set(handles.slider14, 'value', handles.params(5,2));
set(handles.slider15, 'value', handles.params(5,3));

function [] = update_text(handles)
set(handles.text27, 'string', handles.params(1,1));
set(handles.text28, 'string', handles.params(1,2));
set(handles.text29, 'string', handles.params(1,3));
set(handles.text30, 'string', handles.params(2,1));
set(handles.text31, 'string', handles.params(2,2));
set(handles.text32, 'string', handles.params(2,3));
set(handles.text33, 'string', handles.params(3,1));
set(handles.text34, 'string', handles.params(3,2));
set(handles.text35, 'string', handles.params(3,3));
set(handles.text36, 'string', handles.params(4,1));
set(handles.text37, 'string', handles.params(4,2));
set(handles.text38, 'string', handles.params(4,3));
set(handles.text39, 'string', handles.params(5,1));
set(handles.text40, 'string', handles.params(5,2));
set(handles.text41, 'string', handles.params(5,3));


function [] = update_images(handles)
axes(handles.axes1);
imshow(handles.class_pms(:,:,1),[]);
axes(handles.axes2);
imshow(handles.class_pms(:,:,2),[]);
axes(handles.axes3);
imshow(handles.class_pms(:,:,3),[]);



% --- Executes on slider movement.
function slider1_Callback(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
row = 1; 
col = 1;
params = handles.params;
param = get(hObject,'Value');
param_prev = params(row,col);
params(:,col) = max(min(params(:,col)/((1-param_prev)/(1-param)),1),0);
params(row,col) = param;
handles.params = params;
handles.class_pms = update_class_pms(handles);
update_sliders(handles);
update_text(handles);
update_images(handles);
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function slider1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function slider2_Callback(hObject, eventdata, handles)
% hObject    handle to slider2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
row = 1; 
col = 2;
params = handles.params;
param = get(hObject,'Value');
param_prev = params(row,col);
params(:,col) = max(min(params(:,col)/((1-param_prev)/(1-param)),1),0);
params(row,col) = param;
handles.params = params;
handles.class_pms = update_class_pms(handles);
update_sliders(handles);
update_text(handles);
update_images(handles);
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function slider2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function slider3_Callback(hObject, eventdata, handles)
% hObject    handle to slider3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
row = 1; 
col = 3;
params = handles.params;
param = get(hObject,'Value');
param_prev = params(row,col);
params(:,col) = max(min(params(:,col)/((1-param_prev)/(1-param)),1),0);
params(row,col) = param;
handles.params = params;
handles.class_pms = update_class_pms(handles);
update_sliders(handles);
update_text(handles);
update_images(handles);
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function slider3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function slider4_Callback(hObject, eventdata, handles)
% hObject    handle to slider4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
row = 2; 
col = 1;
params = handles.params;
param = get(hObject,'Value');
param_prev = params(row,col);
params(:,col) = max(min(params(:,col)/((1-param_prev)/(1-param)),1),0);
params(row,col) = param;
handles.params = params;
handles.class_pms = update_class_pms(handles);
update_sliders(handles);
update_text(handles);
update_images(handles);
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function slider4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function slider5_Callback(hObject, eventdata, handles)
% hObject    handle to slider5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
row = 2; 
col = 2;
params = handles.params;
param = get(hObject,'Value');
param_prev = params(row,col);
params(:,col) = max(min(params(:,col)/((1-param_prev)/(1-param)),1),0);
params(row,col) = param;
handles.params = params;
handles.class_pms = update_class_pms(handles);
update_sliders(handles);
update_text(handles);
update_images(handles);
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function slider5_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function slider6_Callback(hObject, eventdata, handles)
% hObject    handle to slider6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
row = 2; 
col = 3;
params = handles.params;
param = get(hObject,'Value');
param_prev = params(row,col);
params(:,col) = max(min(params(:,col)/((1-param_prev)/(1-param)),1),0);
params(row,col) = param;
handles.params = params;
handles.class_pms = update_class_pms(handles);
update_sliders(handles);
update_text(handles);
update_images(handles);
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function slider6_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function slider7_Callback(hObject, eventdata, handles)
% hObject    handle to slider7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
row = 3; 
col = 1;
params = handles.params;
param = get(hObject,'Value');
param_prev = params(row,col);
params(:,col) = max(min(params(:,col)/((1-param_prev)/(1-param)),1),0);
params(row,col) = param;
handles.params = params;
handles.class_pms = update_class_pms(handles);
update_sliders(handles);
update_text(handles);
update_images(handles);
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function slider7_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function slider8_Callback(hObject, eventdata, handles)
% hObject    handle to slider8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
row = 3; 
col = 2;
params = handles.params;
param = get(hObject,'Value');
param_prev = params(row,col);
params(:,col) = max(min(params(:,col)/((1-param_prev)/(1-param)),1),0);
params(row,col) = param;
handles.params = params;
handles.class_pms = update_class_pms(handles);
update_sliders(handles);
update_text(handles);
update_images(handles);
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function slider8_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function slider9_Callback(hObject, eventdata, handles)
% hObject    handle to slider9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
row = 3; 
col = 3;
params = handles.params;
param = get(hObject,'Value');
param_prev = params(row,col);
params(:,col) = max(min(params(:,col)/((1-param_prev)/(1-param)),1),0);
params(row,col) = param;
handles.params = params;
handles.class_pms = update_class_pms(handles);
update_sliders(handles);
update_text(handles);
update_images(handles);
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function slider9_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function slider10_Callback(hObject, eventdata, handles)
% hObject    handle to slider10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
row = 4; 
col = 1;
params = handles.params;
param = get(hObject,'Value');
param_prev = params(row,col);
params(:,col) = max(min(params(:,col)/((1-param_prev)/(1-param)),1),0);
params(row,col) = param;
handles.params = params;
handles.class_pms = update_class_pms(handles);
update_sliders(handles);
update_text(handles);
update_images(handles);
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function slider10_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function slider11_Callback(hObject, eventdata, handles)
% hObject    handle to slider11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
row = 4; 
col = 2;
params = handles.params;
param = get(hObject,'Value');
param_prev = params(row,col);
params(:,col) = max(min(params(:,col)/((1-param_prev)/(1-param)),1),0);
params(row,col) = param;
handles.params = params;
handles.class_pms = update_class_pms(handles);
update_sliders(handles);
update_text(handles);
update_images(handles);
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function slider11_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function slider12_Callback(hObject, eventdata, handles)
% hObject    handle to slider12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
row = 4; 
col = 3;
params = handles.params;
param = get(hObject,'Value');
param_prev = params(row,col);
params(:,col) = max(min(params(:,col)/((1-param_prev)/(1-param)),1),0);
params(row,col) = param;
handles.params = params;
handles.class_pms = update_class_pms(handles);
update_sliders(handles);
update_text(handles);
update_images(handles);
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function slider12_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function slider13_Callback(hObject, eventdata, handles)
% hObject    handle to slider13 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
row = 5; 
col = 1;
params = handles.params;
param = get(hObject,'Value');
param_prev = params(row,col);
params(:,col) = max(min(params(:,col)/((1-param_prev)/(1-param)),1),0);
params(row,col) = param;
handles.params = params;
handles.class_pms = update_class_pms(handles);
update_sliders(handles);
update_text(handles);
update_images(handles);
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function slider13_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider13 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function slider14_Callback(hObject, eventdata, handles)
% hObject    handle to slider14 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
row = 5; 
col = 2;
params = handles.params;
param = get(hObject,'Value');
param_prev = params(row,col);
params(:,col) = max(min(params(:,col)/((1-param_prev)/(1-param)),1),0);
params(row,col) = param;
handles.params = params;
handles.class_pms = update_class_pms(handles);
update_sliders(handles);
update_text(handles);
update_images(handles);
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function slider14_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider14 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function slider15_Callback(hObject, eventdata, handles)
% hObject    handle to slider15 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
row = 5; 
col = 3;
params = handles.params;
param = get(hObject,'Value');
param_prev = params(row,col);
params(:,col) = max(min(params(:,col)/((1-param_prev)/(1-param)),1),0);
params(row,col) = param;
handles.params = params;
handles.class_pms = update_class_pms(handles);
update_sliders(handles);
update_text(handles);
update_images(handles);
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function slider15_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider15 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
good_params = handles.params;
save('temp.mat','good_params');
close(gcf);


% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[L_S,H_S,V_S,F_S] = extract_segmentation(handles.params,handles.pms,handles.bg);
axes(handles.axes4);
imshow(uint16(drawmask(handles.img,L_S)));
axes(handles.axes5);
imshow(uint16(drawmask(handles.img,H_S)));
axes(handles.axes6);
imshow(uint16(drawmask(handles.img,V_S)));
figure,imshow(uint16(drawmask(handles.img,F_S)));
