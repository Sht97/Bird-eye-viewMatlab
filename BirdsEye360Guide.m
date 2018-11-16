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
%------- Curso Basico de Procesamiento de Imágenes y Visión Artificial---
%------- Noviembre 16  de 2018---------------------------------------------
%--------------------------------------------------------------------------

function varargout = vista(varargin)
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

function vista_OpeningFcn(hObject, eventdata, handles, varargin)

%--------------------------------------------------------------------------
%--1. Carga de elementos del sistema --------------------------------------
%--------------------------------------------------------------------------
car=imread('imagen/Car.png');imresize(car,0.1);%Carga imagen del carro en todo el centro
a=VideoReader('Grabaciones/VidTras.avi');%Carga video del lado de atras
b=VideoReader('Grabaciones/VidFro.avi');%Carga video de la vista delantera
c=VideoReader('Grabaciones/VidIzq.avi');%Carga video del lado izquierdo
d=VideoReader('Grabaciones/VidDer.avi');%Carga video del lado derecho

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
   
    I = read(a,w);I = imresize(I,2.5);%Carga el video trasero en el frame w y se amplica en 2.5%
    J = read(b,w);J = imresize(J,2.5);%Carga el video delantero en el frame w y se amplica en 2.5%
    K = read(c,w);K = imresize(K,2.5);%Carga el video izquierdo en el frame w y se amplica en 2.5%
    L = read(d,w);L = imresize(L,2.5);%Carga el video derecho en el frame w y se amplica en 2.5%
    M = read(b,w);
    N = read(a,w);
    
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
    
    axes(handles.axes10);%Selecciona el axe izquierdo
    axis off;
    imshow(M);
    
    axes(handles.axes11);%Selecciona el axe izquierdo
    axis off;
    imshow(N);
end%Fin del loop
handles.output = hObject;

guidata(hObject, handles);


function varargout = vista_OutputFcn(hObject, eventdata, handles) 

varargout{1} = handles.output;
