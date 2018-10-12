function varargout = vista(varargin)
% VISTA MATLAB code for vista.fig
%      VISTA, by itself, creates a new VISTA or raises the existing
%      singleton*.
%
%      H = VISTA returns the handle to a new VISTA or the handle to
%      the existing singleton*.
%
%      VISTA('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in VISTA.M with the given input arguments.
%
%      VISTA('Property','Value',...) creates a new VISTA or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before vista_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to vista_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help vista

% Last Modified by GUIDE v2.5 09-Oct-2018 01:36:35

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @vista_OpeningFcn, ...
                   'gui_OutputFcn',  @vista_OutputFcn, ...
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


% --- Executes just before vista is made visible.
function vista_OpeningFcn(hObject, eventdata, handles, varargin)
axes(handles.axes1);
a=imread('Izquierda.png');
axis off;
imshow(a);

axes(handles.axes2);
b=imread('Adelante1.png');
axis off;
imshow(b);

axes(handles.axes3);
c=imread('Derecha.png');
axis off;
imshow(c);

axes(handles.axes4);
d=imread('Atras.png');
axis off;
imshow(d);

axes(handles.axes5);
e=imread('Pajaro.png');
axis off;
imshow(e);
% Choose default command line output for vista
handles.output = hObject;
% Update handles structure
guidata(hObject, handles);

% UIWAIT makes vista wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = vista_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
