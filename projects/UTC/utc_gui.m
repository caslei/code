function varargout = utc_gui(varargin)
% UTC_GUI MATLAB code for utc_gui.fig
%      UTC_GUI, by itself, creates a new UTC_GUI or raises the existing
%      singleton*.
%
%      H = UTC_GUI returns the handle to a new UTC_GUI or the handle to
%      the existing singleton*.
%
%      UTC_GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in UTC_GUI.M with the given input arguments.
%
%      UTC_GUI('Property','Value',...) creates a new UTC_GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before utc_gui_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to utc_gui_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help utc_gui

% Last Modified by GUIDE v2.5 20-May-2015 16:19:06

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @utc_gui_OpeningFcn, ...
                   'gui_OutputFcn',  @utc_gui_OutputFcn, ...
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


% --- Executes just before utc_gui is made visible.
function utc_gui_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to utc_gui (see VARARGIN)

% Choose default command line output for utc_gui
handles.output = hObject;

% Load UTC data

% file = uigetfile;

file = '/net/ipi/scratch/jbroels/UTC/pre li 261 nr3 goed.tif';
disp('Reading image data ...');
num_images = numel(imfinfo(file));
for k = 1:num_images
    im_full(:,:,k) = imread(file,k);
end

handles.dir = 0; 
handles.img_good = im_full;
handles.img = im_full;
handles.current_frame_num = 1;
handles.current_frame = handles.img(:,:,handles.current_frame_num);
handles.n_frames = size(handles.img,3);
axes(handles.img_fig);
imshow(handles.current_frame);

% Adjust slider
set(handles.frame_slider,'min',1);
set(handles.frame_slider,'max',handles.n_frames);
set(handles.frame_slider,'Value',handles.current_frame_num);
set(handles.frame_slider,'SliderStep', [1/handles.n_frames , 10/handles.n_frames]);

% Initialize points_table
set(handles.good_points_table,'Data',[]);
set(handles.bad_points_table,'Data',[]);

handles.good = 1;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes utc_gui wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = utc_gui_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on slider movement.
function frame_slider_Callback(hObject, eventdata, handles)
% hObject    handle to frame_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
value = max(min(round(get(hObject,'Value')),handles.n_frames),1);
set(handles.frame_slider,'Value',value);
handles.current_frame_num = value;
handles.current_frame = handles.img(:,:,value);
axes(handles.img_fig);
imshow(handles.current_frame);

% Update handles structure
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function frame_slider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to frame_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on button press in dir_btn.
function dir_btn_Callback(hObject, eventdata, handles)
% hObject    handle to dir_btn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if handles.dir == 0
    handles.img = permute(handles.img,[1,3,2]);
    handles.dir = 1;
else
    if handles.dir == 1
        handles.img = permute(handles.img,[3,2,1]);
        handles.dir = 2;
    else
        handles.img = permute(handles.img,[3,1,2]);
        handles.dir = 0;
    end
end
handles.current_frame_num = 1;
handles.current_frame = handles.img(:,:,handles.current_frame_num);
handles.n_frames = size(handles.img,3);
axes(handles.img_fig);
imshow(handles.current_frame);

% Adjust slider
set(handles.frame_slider,'max',handles.n_frames);
set(handles.frame_slider,'Value',handles.current_frame_num);

% Update handles structure
guidata(hObject, handles);



function block_size_txt_Callback(hObject, eventdata, handles)
% hObject    handle to block_size_txt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of block_size_txt as text
%        str2double(get(hObject,'String')) returns contents of block_size_txt as a double


% --- Executes during object creation, after setting all properties.
function block_size_txt_CreateFcn(hObject, eventdata, handles)
% hObject    handle to block_size_txt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in select_points_btn.
function select_points_btn_Callback(hObject, eventdata, handles)
% hObject    handle to select_points_btn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

[x,y] = ginput;
if handles.good
    points = cell2mat(get(handles.good_points_table,'Data'));
    if handles.dir == 0
        additional_points = [round(x),round(y),ones(numel(x),1)*handles.current_frame_num];
    else
        if handles.dir == 1
            additional_points = [round(x),ones(numel(x),1)*handles.current_frame_num,round(y)];
        else
            additional_points = [ones(numel(x),1)*handles.current_frame_num,round(x),round(y)];
        end
    end

    points = [points;additional_points];
    cell_points = cell(size(points));
    for i=1:size(points,1)
        for j=1:size(points,2)
            cell_points{i,j} = points(i,j);
        end
    end
    set(handles.good_points_table,'Data',cell_points);
else 
    points = cell2mat(get(handles.bad_points_table,'Data'));
    if handles.dir == 0
        additional_points = [round(x),round(y),ones(numel(x),1)*handles.current_frame_num];
    else
        if handles.dir == 1
            additional_points = [round(x),ones(numel(x),1)*handles.current_frame_num,round(y)];
        else
            additional_points = [ones(numel(x),1)*handles.current_frame_num,round(x),round(y)];
        end
    end

    points = [points;additional_points];
    cell_points = cell(size(points));
    for i=1:size(points,1)
        for j=1:size(points,2)
            cell_points{i,j} = points(i,j);
        end
    end
    set(handles.bad_points_table,'Data',cell_points);
end

% Update handles structure
guidata(hObject, handles);
    


% --- Executes on button press in cb_avg.
function cb_avg_Callback(hObject, eventdata, handles)
% hObject    handle to cb_avg (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of cb_avg


% --- Executes on button press in cb_var.
function cb_var_Callback(hObject, eventdata, handles)
% hObject    handle to cb_var (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of cb_var


% --- Executes on button press in cb_ent.
function cb_ent_Callback(hObject, eventdata, handles)
% hObject    handle to cb_ent (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of cb_ent


% --- Executes on button press in cb_aut.
function cb_aut_Callback(hObject, eventdata, handles)
% hObject    handle to cb_aut (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of cb_aut


% --- Executes on button press in load_btn.
function load_btn_Callback(hObject, eventdata, handles)
% hObject    handle to load_btn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% file = uigetfile;

handles.good = 0;

file = '/net/ipi/scratch/jbroels/UTC/pre re 261 nr2.tif';
disp('Reading image data ...');
num_images = numel(imfinfo(file));
for k = 1:num_images
    im_full(:,:,k) = imread(file,k);
end

handles.dir = 0; 
handles.img_bad = im_full;
handles.img = im_full;
handles.current_frame_num = 1;
handles.current_frame = handles.img(:,:,handles.current_frame_num);
handles.n_frames = size(handles.img,3);
axes(handles.img_fig);
imshow(handles.current_frame);

% Adjust slider
set(handles.frame_slider,'min',1);
set(handles.frame_slider,'max',handles.n_frames);
set(handles.frame_slider,'Value',handles.current_frame_num);
set(handles.frame_slider,'SliderStep', [1/handles.n_frames , 10/handles.n_frames]);

% Update handles structure
guidata(hObject, handles);


% --- Executes on button press in compute_features_btn.
function compute_features_btn_Callback(hObject, eventdata, handles)
% hObject    handle to compute_features_btn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
good_points = cell2mat(get(handles.good_points_table,'Data'));
bad_points = cell2mat(get(handles.bad_points_table,'Data'));

disp('Computing features ...');
handles.good_features = compute_features(good_points,handles);
handles.bad_features = compute_features(bad_points,handles);
disp('Done');

% Update handles structure
guidata(hObject, handles);

function features = compute_features(points,handles)
im = handles.img;
[L,M,N] = size(im);
bs = num2str(get(handles.block_size_txt,'String'));
n = size(points,1);
for i=1:n
    x = points(i,1);
    y = points(i,2);
    z = points(i,3);
    block = double(im(max(1,x-bs):min(L,x+bs),max(1,y-bs):min(M,y+bs),max(1,z-bs):min(N,z+bs)));
    if get(handles.cb_avg,'Value')
        avgs(i) = sum(block(:))/numel(block);
    end
    if get(handles.cb_var,'Value')
        vars(i) = var(block(:));
    end
    if get(handles.cb_ent,'Value')
        ents(i) = entropy(block+1);
    end
    if get(handles.cb_aut,'Value')
        [gx,gy] = gradient(block);
        g = gx.^2 + gy.^2; 
        grds(i) = sum(g(:));
    end
end
features = [];
if get(handles.cb_avg,'Value')
    features = [features,avgs'];
end
if get(handles.cb_var,'Value')
    features = [features,vars'];
end
if get(handles.cb_ent,'Value')
    features = [features,ents'];
end
if get(handles.cb_aut,'Value')
    features = [features,grds'];
end


% --- Executes on button press in pca_btn.
function pca_btn_Callback(hObject, eventdata, handles)
% hObject    handle to pca_btn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[~,score_good,~] = pca(handles.good_features);
[~,score_bad,~] = pca(handles.bad_features);
handles.score_g = score_good;
handles.score_b = score_bad;
figure;
scatter(score_good(:,1),score_good(:,2));
hold on;
scatter(score_bad(:,1),score_bad(:,2));
title('Principal components');
xlabel('First component');
ylabel('Second component');
hold off;

% Update handles structure
guidata(hObject, handles);


% --- Executes on button press in train_svm_btn.
function train_svm_btn_Callback(hObject, eventdata, handles)
% hObject    handle to train_svm_btn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
X = [handles.score_g(:,1:2); handles.score_b(:,1:2)];
Y = zeros(size(handles.score_g,1)+size(handles.score_b,1),1);
Y(size(handles.score_g,1)+1:end) = 1;
handles.svm_model = fitcsvm(X,Y);

% Update handles structure
guidata(hObject, handles);


% --- Executes on button press in test_svm_btn.
function test_svm_btn_Callback(hObject, eventdata, handles)
% hObject    handle to test_svm_btn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
img_g = handles.img_good;
img_b = handles.img_bad;

[L,M,N] = size(img_g);

% extract features
step = 10;
wnd_size = 10;
for i=step+1:step:L-step
    disp(['Progress: ' num2str(i/L)])
    for j=step+1:step:M-step
        for k=step+1:step:N-step
            block_g = double(img_g(i-wnd_size:i+wnd_size,j-wnd_size:j+wnd_size,k-wnd_size:k+wnd_size));
            block_b = double(img_b(i-wnd_size:i+wnd_size,j-wnd_size:j+wnd_size,k-wnd_size:k+wnd_size));
            if get(handles.cb_avg,'Value')
                avgs_g(i) = sum(block_g(:))/numel(block_g);
                avgs_b(i) = sum(block_b(:))/numel(block_b);
            end
            if get(handles.cb_var,'Value')
                vars_g(i) = var(block_g(:));
                vars_b(i) = var(block_b(:));
            end
            if get(handles.cb_ent,'Value')
                ents_g(i) = entropy(block_g+1);
                ents_b(i) = entropy(block_b+1);
            end
            if get(handles.cb_aut,'Value')
                [gx,gy] = gradient(block_g);
                g = gx.^2 + gy.^2; 
                grds_g(i) = sum(g(:));
                
                [gx,gy] = gradient(block_b);
                g = gx.^2 + gy.^2; 
                grds_b(i) = sum(g(:));
            end
        end
    end
end

features_g = [];
features_b = [];
if get(handles.cb_avg,'Value')
    features_g = [features_g,avgs_g'];
    features_b = [features_b,avgs_b'];
end
if get(handles.cb_var,'Value')
    features_g = [features_g,vars_g'];
    features_b = [features_b,vars_b'];
end
if get(handles.cb_ent,'Value')
    features_g = [features_g,ents_g'];
    features_b = [features_b,ents_b'];
end
if get(handles.cb_aut,'Value')
    features_g = [features_g,grds_g'];
    features_b = [features_b,grds_b'];
end

% apply PCA transformation
[~,score_good,~] = pca(features_g);
[~,score_bad,~] = pca(features_b);

% svm classification
[labels_good,~] = predict(handles.svm_model, score_good);
[labels_bad,~] = predict(handles.svm_model, score_bad);



