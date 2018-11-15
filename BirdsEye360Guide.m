%--------------------------------------------------------------------------
%------- Birds eye view car 360--------------------------------------------
%------- Coceptos básicos de PDI-------------------------------------------
%------- Por: Daniel Felipe Rivera daniel.riveraa@udea.edu.co--------------
%------------ Juan Pablo Jaramillo Tobon juan.jaramillo62@udea.edu.co------
%--------Estudiantes ingenieria de sistemas -------------------------------
%------- Curso Básico de Procesamiento de Imágenes y Visión Artificial----
%-------        PROFESOR DEL CURSO ----------------------------------------
%-------David Fernandez    david.fernandez@udea.edu.co -------------------
%-------Profesor Facultad de Ingenieria BLQ 21-409  -----------------------
%-------CC 71629489, Tel 2198528,  Wpp 3007106588 -------------------------
%------- Curso Bï¿½sico de Procesamiento de Imágenes y Visión Artificial---
%------- Noviembre 16  de 2018---------------------------------------------
%--------------------------------------------------------------------------

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

% Last Modified by GUIDE v2.5 14-Nov-2018 12:08:58

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

%--------------------------------------------------------------------------
%--1. Carga de elementos del sistema --------------------------------------
%--------------------------------------------------------------------------
car=imread('imagen/Car.png');imresize(car,0.1);%Carga imagen del carro en todo el centro
a=VideoReader('Grabaciones/animacionTrasera.avi');%Carga video del lado de atras
b=VideoReader('Grabaciones/video.avi');%Carga video de la vista delantera
c=VideoReader('Grabaciones/AnimacionIzquierda.avi');%Carga video del lado izquierdo
d=VideoReader('Grabaciones/animacionDerecha.avi');%Carga video del lado derecho

%--------------------------------------------------------------------------
%--2. Configuración de camaras
%--------------------------------------------------------------------------
% Definimos las intrinsicas de la camara frontal y trasera

focalLength = [650 650];%Definimos la distancia focal
principalPoint = [480 340];%Definimos el punt principal 
imageSize = [540 960];%Definimos el tamaño de la imagen 
camIntrinsics = cameraIntrinsics(focalLength,principalPoint,imageSize);% Creamos los objetos que contienen las intrinsicas de la camara

% Definimos las intrinsicas de la camara izquierda y derecha
focalLength1 = [320 320];%Definimos la distancia focal
principalPoint1 = [480 50];%Definimos el punt principal  
imageSize1 = [540 960];%Definimos el tamaño de la imagen 
camIntrinsics1 = cameraIntrinsics(focalLength1,principalPoint1,imageSize1);% Creamos los objetos que contienen las intrinsicas de la camara

%Definimos la configuración del sensor delantero y trasero.
height = 0.5;%Definimos la altura
pitch = 12;%Definimos el angulo 
sensor = monoCamera(camIntrinsics,height,'Pitch',pitch);%Creamos un objeto que contiene toda la configuración de la camara.

%Definimos la configuración del sensor izquierdo y derecho.
height1 = 1.3;%Definimos la altura
pitch1 = 23;%Definimos el angulo 
sensor1 = monoCamera(camIntrinsics1,height1,'Pitch',pitch1);%Creamos un objeto que contiene toda la configuración de la camara.



%--------------------------------------------------------------------------
%--3. Configuración de imagen de salida
%--------------------------------------------------------------------------
%Definimos la región de interés o parametros de la vista de pajaro delantera y trasera
bottomOffset = 0.9;%Definimos desde donde queremos ver en metros
distAheadOfSensor = 6;%Definimos hasta donde queremos ver en metros
spaceToOneSide = 3;%Definimos la distancia que se ve a los lados en metros
outView = [bottomOffset,distAheadOfSensor,-spaceToOneSide,spaceToOneSide];%Creamos un objeto con la configuración de la imagen de salida
outImageSize = [NaN,800];%Tamaño por defecto

%Definimos la región de interés o parametros de la vista de pajaro izquierda y derecha
bottomOffset1 = 0.4;%Definimos desde donde queremos ver en metros
distAheadOfSensor1 = 2;%Definimos hasta donde queremos ver en metros
spaceToOneSide1 = 3;%Definimos la distancia que se ve a los lados en metros
outView1 = [bottomOffset1,distAheadOfSensor1,-spaceToOneSide1,spaceToOneSide1];%Creamos un objeto con la configuración de la imagen de salida
outImageSize1 = [NaN,800];%Tamaño por defecto


%--------------------------------------------------------------------------
%--4. Objetos bird eye view
%--------------------------------------------------------------------------
%Creamos los objetos birds eye view con lo obtenido anteriormente.
birdsEye = birdsEyeView(sensor,outView,outImageSize);%Objeto para la vista frontal y trasera
birdsEye1 = birdsEyeView(sensor1,outView1,outImageSize1);%Objeto para la vista izquierda y derecha


axes(handles.axes9);
axis off;
imshow(car);
%--------------------------------------------------------------------------
%--5 Aplicamos la vista de pajaro a cada frame del video
%--------------------------------------------------------------------------
for w= 1:120%Desde el frame 1 hasta el 120
%Carga de videos en el frame W y se amplian
    
    I = readframe(a,w);I = imresize(I,2.5);%Carga el video trasero en el frame w y se amplica en 2.5%
    J = readframe(b,w);J = imresize(J,2.5);%Carga el video delantero en el frame w y se amplica en 2.5%
    K = readframe(c,w);K = imresize(K,2.5);%Carga el video izquierdo en el frame w y se amplica en 2.5%
    L = readframe(d,w);L = imresize(L,2.5);%Carga el video derecho en el frame w y se amplica en 2.5%

%Aplica su transformación birdsEye correspondiente
    B = transformImage(birdsEye,I);B=imrotate(B,-90);%Transformamos la imagen trasera y rotamos a la derecha
    A = transformImage(birdsEye,J);A=imrotate(A,90);%Transformamos la imagen delantera y rotamos a la izquierda
    C = transformImage(birdsEye1,K);C=imrotate(C,180);%Transformamos la imagen izquierda y rotamos gacua abajo
    D = transformImage(birdsEye1,L);%Transformamos la imagen derecha

%--------------------------------------------------------------------------
%--6 Carga imagen en el axe de pantalla
%--------------------------------------------------------------------------    
    axes(handles.axes1);%Selecciona el axe delantero
    axis off;
    imshow(A);%Enseñamos en este la imagen delantera

    axes(handles.axes2);%Selecciona el axe derecho
    axis off;
    imshow(D);%Enseñamos en este la imagen derecha

    axes(handles.axes3);%Selecciona el axe trasero
    axis off;
    imshow(B);%Enseñamos en este la imagen trasera

    axes(handles.axes4);%Selecciona el axe izquierdo
    axis off;
    imshow(C);%Enseñamos en este la imagen izquierda
end%Fin del loop




% Choose default command line output for vista
handles.output = hObject;
% Update handles structure
guidata(hObject, handles);



% --- Outputs from this function are returned to the command line.
function varargout = vista_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;
