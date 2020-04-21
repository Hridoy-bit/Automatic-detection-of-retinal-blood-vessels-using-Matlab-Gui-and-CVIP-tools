function varargout = Project_retina(varargin)
% PROJECT_RETINA MATLAB code for Project_retina.fig
%      PROJECT_RETINA, by itself, creates a new PROJECT_RETINA or raises the existing
%      singleton*.
%
%      H = PROJECT_RETINA returns the handle to a new PROJECT_RETINA or the handle to
%      the existing singleton*.
%
%      PROJECT_RETINA('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in PROJECT_RETINA.M with the given input arguments.
%
%      PROJECT_RETINA('Property','Value',...) creates a new PROJECT_RETINA or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Project_retina_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Project_retina_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Project_retina

% Last Modified by GUIDE v2.5 26-Oct-2019 19:00:33

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Project_retina_OpeningFcn, ...
                   'gui_OutputFcn',  @Project_retina_OutputFcn, ...
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


% --- Executes just before Project_retina is made visible.
function Project_retina_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Project_retina (see VARARGIN)

% Choose default command line output for Project_retina
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes Project_retina wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = Project_retina_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in input.
function input_Callback(hObject, eventdata, handles)
% hObject    handle to input (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA) 
global cvipImage

    [filename, pathname] = uigetfile({'*.*', 'All Files (*.*)';...
        '*.tif','TIFF (*.tif)'; '*.bmp','BMP (*.bmp)';...
        '*.jpg', 'JPEG/JPEG2000 (*.jpg)'; '*.png','PNG (*.png)';...
        '*.pbm ; *.ppm;*.pgm; *.pnm',...
        'PBM/PPM/PGM/PNM (*.pbm,*.ppm,*.pgm, *.pnm)';...
        '*.gif','GIF (*.gif)'}, ...
        'Select an input image file', 'MultiSelect','off'); %mulitple file selection option is OFF, single image file only 

    %check if user has successfuly made the file selection
    if ~isequal(filename,0)
        % read the selected image from given path
        [cvipImage,map]=imread([pathname filename]);
        
        %check image is either indexed image or rgb image
        %indexed image consists of a data matrix and a colormap matrix.
        %rgb image consists of a data matrix only.        
        if ~isempty(map) %indexed image if map is not empty
            cvipImage = ind2rgb(cvipImage,map);%convert indexed image into rgb image 
        end
        
    else 
        warning('Image file not selected!!!');  %warn user if cancelled
        cvipImage=[];             %return empty matrix if user has cancelled the selection
    end

axes(handles.axes1)
imshow(cvipImage)

    



% --- Executes on button press in post.
function post_Callback(hObject, eventdata, handles)
% hObject    handle to post (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%% Remove small pixels
global BW
global B
global vv
%% Remove small pixels

 BW2 = bwareaopen(BW, 100);
 
%% Overlay
BW2 = imcomplement(BW2);
out = imoverlay(B, BW2, [0 0 0]);
imshow(out)
           
vv = rgb2gray(out);
axes(handles.axes1)
%imshow(vv)
imshow(out)



% --- Executes on button press in thresholding.
function thresholding_Callback(hObject, eventdata, handles)
% hObject    handle to thresholding (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global Z
global level
level=isodata(Z);
axes(handles.axes1);
imshow(level)


% --- Executes on button press in binary.
function binary_Callback(hObject, eventdata, handles)
% hObject    handle to binary (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global Z
global BW
global level
BW = imbinarize(Z, level-.008);
axes(handles.axes1);
imshow(BW);


% --- Executes on button press in morphological.
function morphological_Callback(hObject, eventdata, handles)
% hObject    handle to morphological (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in reshape.
function reshape_Callback(hObject, eventdata, handles)
% hObject    handle to reshape (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global cvipImage
global gray
I = imresize(cvipImage,.8);
I2 = rgb2gray(I);
[r,c] = size(I2);
B = imresize(I2, [r c]);
                    % Read image
gray = im2double(B);
axes(handles.axes1)
imshow(gray)




% --- Executes on button press in rgb_gray.
function rgb_gray_Callback(hObject, eventdata, handles)
% hObject    handle to rgb_gray (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton5.
function pushbutton5_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global JF
global J
global gray
J = adapthisteq(gray,'numTiles',[8 8],'nBins',128);
%% Background Exclusion                    % Apply Average Filter
 h = fspecial('average', [9 9]);
 JF = imfilter(J, h);
 axes(handles.axes1)
 imshow(JF)

% --- Executes on button press in average_filter.
function average_filter_Callback(hObject, eventdata, handles)
% hObject    handle to average_filter (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in subtruction.
function subtruction_Callback(hObject, eventdata, handles)
% hObject    handle to subtruction (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global JF
global J
global Z

Z = imsubtract(JF, J);
axes(handles.axes1)
imshow(Z)

% --- Executes during object creation, after setting all properties.
function axes1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to axes1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: place code in OpeningFcn to populate axes1


% --- Executes on button press in subtraction.
function subtraction_Callback(hObject, eventdata, handles)
% hObject    handle to subtraction (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global JF
global J
global Z

Z = imsubtract(JF, J);
axes(handles.axes1)
imshow(Z)


% --- Executes on button press in final_output.
function final_output_Callback(hObject, eventdata, handles)
% hObject    handle to final_output (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global BW2
global vv
binaryImage = vv > 60;
BW2 = bwmorph(binaryImage,'clean');
%figure, imshow(BW2);
%imwrite(BW2, fullFileName);
final = BW2;
axes(handles.axes1)
imshow(final)



function edit1_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit1 as text
%        str2double(get(hObject,'String')) returns contents of edit1 as a double


% --- Executes during object creation, after setting all properties.
function edit1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit2_Callback(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit2 as text
%        str2double(get(hObject,'String')) returns contents of edit2 as a double


% --- Executes during object creation, after setting all properties.
function edit2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
