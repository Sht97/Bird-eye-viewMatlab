%--------------------------------------------------------------------------
%--1. Carga de elementos del sistema --------------------------------------
%--------------------------------------------------------------------------
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



%--------------------------------------------------------------------------
%--5 Aplicamos la vista de pajaro a cada frame del video
%--------------------------------------------------------------------------
figure 
for w= 1:120

 %Carga de videos en el frame W y se amplian
    
    I = readframe(a,w);I = imresize(I,2.5);%Carga el video trasero en el frame w y se amplica en 2.5%
    J = readframe(b,w);J = imresize(J,2.5);%Carga el video delantero en el frame w y se amplica en 2.5%
    K = readframe(c,w);K = imresize(K,2.5);%Carga el video izquierdo en el frame w y se amplica en 2.5%
    L = readframe(d,w);L = imresize(L,2.5);%Carga el video derecho en el frame w y se amplica en 2.5%

    % Transform the input image to bird's-eye-view image.
    B = transformImage(birdsEye,I);%Transformamos la imagen trasera 
    A = transformImage(birdsEye,J);%Transformamos la imagen delantera 
    C = transformImage(birdsEye1,K);%Transformamos la imagen izquierda 
    D = transformImage(birdsEye1,L);%Transformamos la imagen derecha 
    
    %Seleccionamos que pareja de vistas se quiere enseñar
    imshow([A,B])%Frontal y trasera
    %imshow([C,D])%Izquierda y derecha

end
