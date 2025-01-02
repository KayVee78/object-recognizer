function varargout = objectRecognizerGui(varargin)
% OBJECTRECOGNIZERGUI MATLAB code for objectRecognizerGui.fig
%      OBJECTRECOGNIZERGUI, by itself, creates a new OBJECTRECOGNIZERGUI or raises the existing
%      singleton*.
%
%      H = OBJECTRECOGNIZERGUI returns the handle to a new OBJECTRECOGNIZERGUI or the handle to
%      the existing singleton*.
%
%      OBJECTRECOGNIZERGUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in OBJECTRECOGNIZERGUI.M with the given input arguments.
%
%      OBJECTRECOGNIZERGUI('Property','Value',...) creates a new OBJECTRECOGNIZERGUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before objectRecognizerGui_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to objectRecognizerGui_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help objectRecognizerGui

% Last Modified by GUIDE v2.5 02-Jan-2025 19:44:31

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @objectRecognizerGui_OpeningFcn, ...
                   'gui_OutputFcn',  @objectRecognizerGui_OutputFcn, ...
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


% --- Executes just before objectRecognizerGui is made visible.
function objectRecognizerGui_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to objectRecognizerGui (see VARARGIN)

% Choose default command line output for objectRecognizerGui
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes objectRecognizerGui wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = objectRecognizerGui_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in uploadImageBtn.
function uploadImageBtn_Callback(hObject, eventdata, handles)
% hObject    handle to uploadImageBtn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Prompt the user to select an image file
[fileName, filePath] = uigetfile({'*.jpg;*.jpeg;*.png;*.bmp;*.tif;*.dcm;*.webp', 'Image Files (*.jpg, *.jpeg, *.png, *.bmp, *.tif, *.dcm, *.webp)'; '*.*', 'All Files (*.*)'}, ...
                                 'Select an Image');
% Check if the user cancelled the file selection
if isequal(fileName, 0)
    errordlg('No file selected. Please select a valid image.', 'File Selection Error');
    return;
end

% Get the full path of the selected file
fullPath = fullfile(filePath, fileName);

try
    % Determine if the file is a DICOM file or another image format
    [~, ~, ext] = fileparts(fullPath); % Get the file extension

    if strcmpi(ext, '.dcm')
        % If DICOM, use dicomread
        img = dicomread(fullPath);
        % Retrieve DICOM metadata (optional, can be used later)
        handles.DICOMInfo = dicominfo(fullPath);
    else
        % Otherwise, use imread for standard image formats
        img = imread(fullPath);
    end

    % Display the image in the specified axes
    axes(handles.uploadImageAxes); % Select the target axes
    imshow(img, []);               % Display the image
    title(handles.uploadImageAxes, 'Uploaded Image'); % Optional title

    % Store the image in the handles structure for later use
    handles.ImageData = img;

    % Save the updated handles structure
    guidata(hObject, handles);

catch ME
    % Handle errors in reading or displaying the file
    errordlg(['Failed to upload image: ', ME.message], 'File Upload Error');
end

% --- Executes on button press in calculateContrastBtn.
function calculateContrastBtn_Callback(hObject, eventdata, handles)
% hObject    handle to calculateContrastBtn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Check if image data is loaded
if isfield(handles, 'ImageData') && ~isempty(handles.ImageData)
    % Calculate the contrast using the RMS method
    contrastValue = calculateRMSContrast(handles.ImageData);
    
    % Display the contrast value below the button
    set(handles.contrastDisplayText, 'String', sprintf('Contrast: %.4f', contrastValue));
else
    % Show error if no image is loaded
    errordlg('Please upload an image first.', 'Image Not Loaded');
end
