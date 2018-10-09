%--------------------------------------------------------------------------
%------- RECONOCIMIENTO DE PLACAS EN MOVIMIENTO ---------------------------
%------- Coceptos básicos de PDI-------------------------------------------
%------- Por: Melissa Barba Bolivar    gloria.barba@udea.edu.co -----------
%------- CC 1045519955 ----------------------------------------------------
%------- Por:  Jefferson Jimenez Molina   jefferson.jimenez@udea.edu.co ---
%------- CC 1017254573 ----------------------------------------------------
%------- Estudiantes de Ingenieria de Sistemas UdeA -----------------------
%-------      -------------------------------------------------------------
%-------        PROFESOR DEL CURSO ----------------------------------------
%-------      David Fernández    david.fernandez@udea.edu.co --------------
%-------      Profesor Facultad de Ingenieria BLQ 21-409  -----------------
%-------      CC 71629489, Tel 2198528,  Wpp 3007106588 -------------------
%------- Curso Básico de Procesamiento de Imágenes y Visión Artificial-----
%------- Octubre 2017--------------------------------------------------
%--------------------------------------------------------------------------

function varargout = interfaz(varargin)

gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @interfaz_OpeningFcn, ...
    'gui_OutputFcn',  @interfaz_OutputFcn, ...
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


% --- Executes just before interfaz is made visible.
function interfaz_OpeningFcn(hObject, eventdata, handles, varargin)

    % --------------------------------------------------------------------------
    %-- 1. Fondo de la Interfaz ----------------
    %--------------------------------------------------------------------------
    
axes(handles.fondo);%Se selecciona el axi "fondo", al cual se le ha de cargar 
%el fondo
a = imread('foto.jpg');%Se leerá la imagen que servirá como fondo de la 
%interfaz
axis off;%Se desactiva el axis al cual se le ha hecho el llamado anteriormente
imshow(a);%Mostramos la imagen de fondo
axes(handles.pantalla);%%Se selecciona el axi "pantalla"
axis off;%Se desactiva el axis al cual se le ha hecho el llamado anteriormente
axes(handles.placa);%%Se selecciona el axi "placa"
axis off;%Se desactiva el axis al cual se le ha hecho el llamado anteriormente

    % --------------------------------------------------------------------------
    %-- 2. Personalización de los Botones ----------------
    %--------------------------------------------------------------------------
    
[a,map]=imread('cam.jpg');%Cargamos en a la imagen que servirá de fondo
%para los botones
[r,c,d]=size(a);%Obtenemos el tamaño de la imagen que servirá de fondo 
%para los botones
x=ceil(r/70);%Redondea el tamaño de la matriz r / 38
y=ceil(c/180);%Redondea el tamaño de la matriz c / 51
g=a(1:x:end,1:y:end,:);%Crea una matriz g, con elementos de la matriz "a", 
%pero considerando intervalos x y y
g(g==255)=5.5*255;%Redimensionamos g, donde hayan pixels de valor 255 los 
%reemplazamos por 5.5*255
set(handles.cargar,'CData',g);%Asignacd mos al boton "cargar" en campo CData 
%los valores de g 
set(handles.detectar,'CData',g);%Asignamos al boton "detectar" en campo 
%CData los valores de g 
set(handles.pushbutton3,'CData',g);
% Choose default command line output for interfaz
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes interfaz wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = interfaz_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in cargar.
function cargar_Callback(hObject, eventdata, handles)
% hObject    handle to cargar (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

    % --------------------------------------------------------------------------
    %-- 3. Configuración Boton Cargar ----------------
    %--------------------------------------------------------------------------
    
[filename, pathname]=uigetfile({'*.mp4;*.avi;*.wmv;*.mkv;*.mts'},'Select A Video');
% Obtener la ruta absoluta de la imagen
fullPath = strcat(pathname,filename);%Obtemos en el fullPath el archivo seleccionado
handles.v = VideoReader(fullPath);%Leemos el video que ha sido cargado en el fullPath
guidata(hObject, handles);




% --- Executes on button press in detectar.
function detectar_Callback(hObject, eventdata, handles)
% hObject    handle to detectar (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

    % --------------------------------------------------------------------------
    %-- 4. Configuración Boton Detectar ----------------
    %--------------------------------------------------------------------------

while hasFrame(handles.v)%While cuya condición es que el video posea frames, es decir, mientras 
    %el video no se haya acabado
    axes(handles.pantalla);%Seleccionamos el axi "Pantalla"
    cdt = readFrame(handles.v);%Capturamos el frame de ese instante
    cdt2 = cdt;%Realizamos una copia de la imagen
    
    % --------------------------------------------------------------------------
    %-- 5. Reconociendo la Placa ----------------
    %--------------------------------------------------------------------------
    
    cdt2(1:500,:,:)= 0;%
    cdt2(:,1400:end,:)= 0;%
    
    r = cdt2(:,:,1);%Obtenemos la capa que contiene el color rojo de la imagen
    g = cdt2(:,:,2);%Obtenemos la capa que contiene el color verde de la imagen
    b = cdt2(:,:,3);%Obtenemos la capa que contiene el color azul de la imagen
    justGreen = r - g/2 - b/2;%A la capa verde le restamos las capas roja y azul
    %dividas entre 2 cada una, esto con la finalidad de obtener de la
    %imagen el color verde presente en la misma.
    bw = justGreen > 33;%Binarizamos la imagen, obteniendo así los objetos
    %donde el color amarillo se encuentre presente
    cdt3 = bwareaopen(bw, 21);%La Funcion bwareaopen elimina todos los
    cdt3 = imclearborder(cdt3);%Limpiamos los bordes de la imagen
    
    imshow(cdt);%Mostramos la imagen del video en ese instante
    st = regionprops(cdt3, 'BoundingBox', 'Area' );%Obtenemos de la imagen las propiedades
    %de BoundingBox y Area
    
    if isempty(st)%Condicional que se encargará de reconocer si el vector con objetos
        %que cumplen con la mascara de reconocimiento, se encuentra vacio.
        
    else
        
        [~, indexOfMax] = max([st.Area]);%Obtenemos el objeto con mayor Area
        p = [st(indexOfMax).BoundingBox(1),st(indexOfMax).BoundingBox(2),st(indexOfMax).BoundingBox(3),st(indexOfMax).BoundingBox(4)];
        %Obtenemos de ese objeto con mayor Area, las coordenadas para
        %dibujar un rectangulo
      
        
        hold on;%Comando para sobre escribir imagenes en pantalla
        axis on;%Activamos los axis
        rectangle('Position',p, 'EdgeColor','r','LineWidth',6 );%Se dibuja el
        %Rectangulo correspondiente al objeto de mayor ARea
        hold off;%Comando para dejar de sobre escribir imagenes en pantalla
        X2 = imcrop(cdt,p);%Recortamos el rectangulo y la imagen que se encuentra 
        %contenida
        axes(handles.placa);%Seleccionamos el axi "Placa" para posteriormente usarlo
        imshow(X2);%Mostramos en el axi "Placa" la placa recortada del video
        pause(1/(handles.v.FrameRate*8));%Asignamos una pausa de acuerdo al rango de los frames
        
    end
end



guidata(hObject, handles);


% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%--------------------------------------------------------------------------
%---------------------------  FIN DEL PROGRAMA ----------------------------
%--------------------------------------------------------------------------

