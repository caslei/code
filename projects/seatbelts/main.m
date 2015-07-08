function varargout = main(varargin)
% MAIN MATLAB code for main.fig
%      MAIN, by itself, creates a new MAIN or raises the existing
%      singleton*.
%
%      H = MAIN returns the handle to a new MAIN or the handle to
%      the existing singleton*.
%
%      MAIN('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in MAIN.M with the given input arguments.
%
%      MAIN('Property','Value',...) creates a new MAIN or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before main_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to main_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help main

% Last Modified by GUIDE v2.5 28-Oct-2014 15:01:28

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @main_OpeningFcn, ...
                   'gui_OutputFcn',  @main_OutputFcn, ...
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


% --- Executes just before main is made visible.
function main_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to main (see VARARGIN)

% Choose default command line output for main
handles.output = hObject;
handles.min_gray_lvl = 20;
handles.max_gray_lvl = 128;
handles.min_offset_dist = 1;
handles.max_offset_dist = 10;
offsets = zeros(8,2);
offsets(1,:) = [-1 0];
offsets(2,:) = [-1 1];
offsets(3,:) = [0 1];
offsets(4,:) = [1 1];
offsets(5,:) = [1 0];
offsets(6,:) = [1 -1];
offsets(7,:) = [0 -1];
offsets(8,:) = [-1 -1];
handles.offsets = offsets;
handles.gray_lvl = 50;
handles.offset_dir = offsets(1,:);
handles.offset_dir_num = 1;
handles.offset_dist = handles.min_offset_dist;
handles.param_h_thresh = 10;
handles.param_w_thresh = 10;
handles.param_a_thresh = 10;
handles.param_b_thresh = 10;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes main wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = main_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in load_im_btn.
function load_im_btn_Callback(hObject, eventdata, handles)
% hObject    handle to load_im_btn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[filename, user_canceled] = imgetfile;
if ~user_canceled
    % Load main_image
    handles.main_image = imread(filename);
    axes(handles.main_fig_axes);
    imshow(handles.main_image);
    
    guidata(hObject, handles);
end


% --- Executes on button press in select_region_btn.
function select_region_btn_Callback(hObject, eventdata, handles)
% hObject    handle to select_region_btn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[x, y] = getpts(handles.main_fig_axes);
if (numel(x) == 2 && numel(y) == 2)
    % Load sub_image
    I = handles.main_image;
    handles.x0 = round(y(1));
    handles.x1 = round(y(2));
    handles.y0 = round(x(1));
    handles.y1 = round(x(2));
    handles.sub_image = I(handles.x0:handles.x1, handles.y0:handles.y1);
    axes(handles.sub_fig_axes);
    imshow(handles.sub_image);
    
    % Compute co-occurence matrix
    compute_co_occ_matrix(hObject, eventdata, handles);
    
    guidata(hObject, handles);
end


% --- Executes during object creation, after setting all properties.
function load_im_btn_CreateFcn(hObject, eventdata, handles)
% hObject    handle to load_im_btn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes on slider movement.
function gray_lvls_slider_Callback(hObject, eventdata, handles)
% hObject    handle to gray_lvls_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
handles.gray_lvl = round(get(hObject,'Value'));
set(handles.gray_lvls_text, 'String', num2str(handles.gray_lvl));
compute_co_occ_matrix(hObject, eventdata, handles);

guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function gray_lvls_slider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to gray_lvls_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on selection change in offset_dir_popup.
function offset_dir_popup_Callback(hObject, eventdata, handles)
% hObject    handle to offset_dir_popup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns offset_dir_popup contents as cell array
%        contents{get(hObject,'Value')} returns selected item from offset_dir_popup
handles.offset_dir = handles.offsets(get(hObject,'Value'),:);
handles.offset_dir_num = get(hObject,'Value');
compute_co_occ_matrix(hObject, eventdata, handles);

guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function offset_dir_popup_CreateFcn(hObject, eventdata, handles)
% hObject    handle to offset_dir_popup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on slider movement.
function offset_dist_slider_Callback(hObject, eventdata, handles)
% hObject    handle to offset_dist_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
handles.offset_dist = round(get(hObject,'Value'));
set(handles.offset_dist_text, 'String', num2str(handles.offset_dist));
compute_co_occ_matrix(hObject, eventdata, handles);

guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function offset_dist_slider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to offset_dist_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


function compute_co_occ_matrix(hObject, eventdata, handles)
% Compute co occurrence matrix
handles.glcm = graycomatrix(handles.sub_image, 'NumLevels', handles.gray_lvl, 'Offset', handles.offset_dist .* handles.offset_dir);

% Visualise
opacity = 0.50;
if handles.offset_dir_num == 1 || handles.offset_dir_num == 5
    % Fit square
    [h, w] = fit_square(handles.glcm);
    
    % Draw rectangle
    square_overlay = ones(size(handles.glcm, 1), size(handles.glcm, 2));
    square_overlay(h, 1:w) = 1-opacity;
    square_overlay(1:h, w) = 1-opacity;
    
    axes(handles.co_occ_axes);
    r = zeros(size(handles.glcm,1), size(handles.glcm,2),3);
    r(:,:,1) = 255;
    imshow(r);
    hold on;
    h = imshow(handles.glcm);
    hold off;
    set(h, 'AlphaData', square_overlay);
else
    if handles.offset_dir_num == 3 || handles.offset_dir_num == 7
        % Fit ellipse
        ellipse = fit_ellips(handles.glcm);
        
        % Draw ellipse
        rotated_ellipse = ceil(ellipse.rotated_ellipse);
        ellipse_overlay = ones(size(handles.glcm, 1), size(handles.glcm, 2));
        for i=1:numel(rotated_ellipse(1,:))
            ellipse_overlay(rotated_ellipse(2,i),rotated_ellipse(1,i)) = 1-opacity;
        end
        handles.ellipse = ellipse;
        
        axes(handles.co_occ_axes);
        r = zeros(size(handles.glcm,1), size(handles.glcm,2),3);
        r(:,:,1) = 255;
        imshow(r);
        hold on;
        h = imshow(handles.glcm);
        hold off;
        set(h, 'AlphaData', ellipse_overlay);
    else
        axes(handles.co_occ_axes);
        imshow(handles.glcm);
    end
end

guidata(hObject, handles);


function ellipse = fit_ellips(glcm)
[non_zero_ys, non_zero_xs] = find(glcm);
unique_xs = unique(non_zero_xs);
new_xs = zeros(2*numel(unique_xs), 1);
new_ys = zeros(2*numel(unique_xs), 1);
for i=1:numel(unique_xs)
    coords = find(non_zero_xs == unique_xs(i));
    [min_value, ~] = min(non_zero_ys(coords));
    [max_value, ~] = max(non_zero_ys(coords));
    
    new_xs(2*(i-1)+1) = unique_xs(i);
    new_xs(2*(i-1)+2) = unique_xs(i);
    new_ys(2*(i-1)+1) = min_value;
    new_ys(2*(i-1)+2) = max_value;
end
ellipse = fit_ellipse(new_xs, new_ys);



function [h, w] = fit_square(glcm)
i = size(glcm, 1);
while sum(glcm(i,:) ~= 0) == 0 && i>1
    i = i-1;
end
h = i;
i = size(glcm, 2);
while sum(glcm(:,i) ~= 0) == 0 && i>1
    i = i-1;
end
w = i;


% --------------------------------------------------------------------
function Untitled_1_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in predict_btn.
function predict_btn_Callback(hObject, eventdata, handles)
% hObject    handle to predict_btn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
h_thresh = handles.param_h_thresh;
w_thresh = handles.param_w_thresh;
a_thresh = handles.param_a_thresh;
b_thresh = handles.param_b_thresh;

glcm_N = graycomatrix(handles.sub_image, 'NumLevels', handles.gray_lvl, 'Offset', [-1 0]);
glcm_S = graycomatrix(handles.sub_image, 'NumLevels', handles.gray_lvl, 'Offset', [1 0]);
glcm_E = graycomatrix(handles.sub_image, 'NumLevels', handles.gray_lvl, 'Offset', [0 1]);
glcm_W = graycomatrix(handles.sub_image, 'NumLevels', handles.gray_lvl, 'Offset', [0 -1]);
glcm_H = (glcm_E + glcm_W)/2;
glcm_V = (glcm_N + glcm_S)/2;

[h, w] = fit_square(glcm_V);
ellipse = fit_ellips(glcm_H);
a = ellipse.a;
b = ellipse.b;

h
w
a
b

if (h < h_thresh && w < w_thresh && a < a_thresh && b < b_thresh)
    set(handles.prediction_text, 'String', 'Correct');
else
    set(handles.prediction_text, 'String', 'Error');
end

guidata(hObject, handles);


function param_h_thresh_Callback(hObject, eventdata, handles)
% hObject    handle to param_h_thresh (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of param_h_thresh as text
%        str2double(get(hObject,'String')) returns contents of param_h_thresh as a double
handles.param_h_thresh = str2double(get(hObject,'String'));

guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function param_h_thresh_CreateFcn(hObject, eventdata, handles)
% hObject    handle to param_h_thresh (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function param_w_thresh_Callback(hObject, eventdata, handles)
% hObject    handle to param_w_thresh (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of param_w_thresh as text
%        str2double(get(hObject,'String')) returns contents of param_w_thresh as a double
handles.param_w_thresh = str2double(get(hObject,'String'));

guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function param_w_thresh_CreateFcn(hObject, eventdata, handles)
% hObject    handle to param_w_thresh (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function param_a_thresh_Callback(hObject, eventdata, handles)
% hObject    handle to param_a_thresh (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of param_a_thresh as text
%        str2double(get(hObject,'String')) returns contents of param_a_thresh as a double
handles.param_a_thresh = str2double(get(hObject,'String'));

guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function param_a_thresh_CreateFcn(hObject, eventdata, handles)
% hObject    handle to param_a_thresh (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function param_b_thresh_Callback(hObject, eventdata, handles)
% hObject    handle to param_b_thresh (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of param_b_thresh as text
%        str2double(get(hObject,'String')) returns contents of param_b_thresh as a double
handles.param_b_thresh = str2double(get(hObject,'String'));

guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function param_b_thresh_CreateFcn(hObject, eventdata, handles)
% hObject    handle to param_b_thresh (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
