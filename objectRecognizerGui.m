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

% Last Modified by GUIDE v2.5 03-Jan-2025 20:45:45

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
    errordlg('No image uploaded. Please upload an image.', 'Image Not Loaded');
end


% --- Executes on button press in convertToGrayscaleBtn.
function convertToGrayscaleBtn_Callback(hObject, eventdata, handles)
% Check if the image is loaded
if isfield(handles, 'ImageData') && ~isempty(handles.ImageData)
    % Convert the image to grayscale and get weights
    [grayImage, weights] = convertToGrayscale(handles.ImageData);
    
    % Store the grayscale image in handles for later use
    handles.GrayImage = grayImage; % Store grayscale image
    
    % Update handles structure
    guidata(hObject, handles);
    
    % Display the grayscale image in the appropriate axes
    axes(handles.uploadImageAxes);
    imshow(grayImage, []);
    title(handles.uploadImageAxes, 'Grayscale Image');
    
    % Display the weights used for conversion
    set(handles.weightsText, 'String', ...
        sprintf('Weights: R=%.4f, G=%.4f, B=%.4f', weights(1), weights(2), weights(3)));
    set(handles.maxContrast, 'String', ...
        sprintf('Maximum Contrast: %.4f', weights(4)));
else
    % Show error if no image is loaded
    errordlg('No image uploaded. Please upload an image.', 'Image Not Loaded');
end



% --- Executes on button press in generateHistogram.
function generateHistogram_Callback(hObject, eventdata, handles)
    % Check if the grayscale image is available in handles
    if isfield(handles, 'GrayImage') && ~isempty(handles.GrayImage)
        % Retrieve the stored grayscale image
        grayImage = handles.GrayImage;

        % Generate the histogram using the custom function
        histData = generateHistogram(grayImage);

        % Plot the histogram in the axes with tag 'histogramAxes'
        axes(handles.histogramAxes); % Ensure this is the correct axes tag in your GUI
        bar(0:255, histData, 'BarWidth', 1, 'FaceColor', 'k');
        xlabel('Pixel Intensity');
        ylabel('Frequency');
        title('Histogram of Grayscale Image');
        xlim([0 255]);
    else
        % Display an error if no grayscale image is available
        errordlg('No grayscale image available.', 'Error');
    end


% --- Executes on button press in enhanceTumorEdges.
function enhanceTumorEdges_Callback(hObject, eventdata, handles)
% hObject    handle to enhanceTumorEdges (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    % Retrieve the uploaded image
    if isfield(handles, 'GrayImage') && ~isempty(handles.GrayImage)
        img = handles.GrayImage;
    else
        errordlg('No image uploaded. Please upload an image.', 'Error');
        return;
    end

    % Convert to grayscale if the image is RGB
    if size(img, 3) == 3
        img = rgb2grayOptimized(img);
    end

    % Pre-processing: Apply median filter to reduce noise
    filteredImg = medfilt2(img, [5, 5]);

    % Thresholding: Adaptive thresholding for binarization
    binarizedImg = imbinarize(filteredImg, 'adaptive', 'Sensitivity', 0.6);

    % Morphological filtering: Remove noise and enhance edges
    structuringElement = strel('disk', 3);
    cleanedImg = imopen(binarizedImg, structuringElement); % Remove small noise
    enhancedImg = imclose(cleanedImg, structuringElement); % Fill small gaps

    % Update the processed image to the GUI
    axesEnhanced = findobj(handles.figure1, 'Tag', 'enhancedImage');
    if isempty(axesEnhanced)
        errordlg('Enhanced image axes not found. Ensure the axes has the tag "enhancedImage".', 'Error');
        return;
    end

    % Display the enhanced image in the axes
    axes(handles.enhancedImage); % Set focus to the desired axes
    imshow(enhancedImg);
    title('Enhanced Image');

    % Store the enhanced image in the handles structure for future use
    handles.enhancedImage = enhancedImg;
    guidata(hObject, handles);
