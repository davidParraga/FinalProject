
function varargout = sicomo(varargin)
% SICOMO MATLAB code for sicomo.fig
%      SICOMO, by itself, creates a new SICOMO or raises the existing
%      singleton*.
%
%      H = SICOMO returns the handle to a new SICOMO or the handle to
%      the existing singleton*.
%
%      SICOMO('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in SICOMO.M with the given input arguments.
%
%      SICOMO('Property','Value',...) creates a new SICOMO or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before sicomo_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to sicomo_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help sicomo

% Last Modified by GUIDE v2.5 04-Mar-2020 16:06:34

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @sicomo_OpeningFcn, ...
                   'gui_OutputFcn',  @sicomo_OutputFcn, ...
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


% --- Executes just before sicomo is made visible.
function sicomo_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to sicomo (see VARARGIN)

% Choose default command line output for sicomo

handles.output = hObject;
handles.unidades = 'HZ';
handles.unidades2 = 'HZ';
handles.unidades3 = 'HZ';
handles.preamp = '0';
handles.sweep = '0';


% Update handles structure
guidata(hObject, handles);

% UIWAIT makes sicomo wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = sicomo_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure

varargout{1} = handles.output;


% --- Executes on button press in Medir.
function Medir_Callback(hObject, eventdata, handles)
global medidas i gpstotal chpower chpower2;
i = i + 1;
Anritsu=handles.Anritsu;
fclose(Anritsu);
fopen(Anritsu);
%Este comando devuelve TOTAL CHPOWER en dbm
fprintf(Anritsu,':FETCh:CHPower:CHPower?');
chpower1 = fscanf(Anritsu);
chpower2{i,1} = chpower1;
chpower(i,1) = str2double(chpower1);

% % % Representar la potencia % % %
cla(handles.axes1,'reset');
plotTitle = 'Measures campaing'; % plot title
xLabel = 'Samples (n)'; % x-axis label
yLabel = 'Power (dBm)'; % y-axis label
plotGrid = 'on'; % 'off' to turn off grid
hold on;
title(handles.axes1, plotTitle,'FontSize',10);
xlabel(handles.axes1, xLabel,'FontSize',8);
ylabel(handles.axes1, yLabel,'FontSize',8);
grid(plotGrid);
plot(handles.axes1,1:1:length(chpower),chpower);
hold off;
%Devuelve marca de tiempo, latitud, longitud y altura
 fprintf(Anritsu,':FETCh:GPS:FULL?');
% fprintf(Anritsu,':FETCh:GPS:LAST?');
gps = fscanf(Anritsu);
C = 'NO FIX';
C = [C newline ''];
tf = strcmp(C,gps);
 if tf == 1
     for j=1:7
     gpstotal{i,j} = 'NF';
     end
 else
gps2=split(gps,[" ",","]);
gps3 = gps2.';
% [m,n]=size(gps3);
for j=1:7
gpstotal{i,j} = gps3{1,j};
end
 end
medidas = horzcat(chpower2,gpstotal);
% save('double_chpower.mat','chpower');
% save('datosgps_cell.mat','gpstotal');
% save('medidas','medidas');
set(handles.Tomas,'String',i);
fclose(Anritsu);
guidata(hObject,handles);

% hObject    handle to Medir (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)





% --- Executes on button press in Conectar.
function Conectar_Callback(hObject, eventdata, handles)
% hObject    handle to Conectar (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global medidas gpstotal chpower chpower2 i;
medidas = {};
gpstotal = {};
chpower = zeros ();
chpower2 = {};
i = 0;

%Comprobamos que el usuario haya rellenado todos los campos.
if isempty (get(handles.Center_Frequency_edit_text,'String')) || isempty(get(handles.SPAN_edit_text,'String')) || isempty(handles.unidades) || isempty(get(handles.Sweep_point_edit_text,'String')) || isempty(get(handles.Sweep_point_edit_text,'String')) || isempty(get(handles.Integration_BW,'String'))
    errordlg('Fill in the blanks','Warning')
else
%% Instrument Connection
% Find a tcpip object.
% 192.168.1.100 (Para router de Leandro)
% 192.168.0.197 (Para router Sicomo)
Anritsu = instrfind('Type', 'tcpip', 'RemoteHost', '192.168.43.53', 'RemotePort', 9001, 'Tag', '');

% Create the tcpip object if it does not exist
% otherwise use the object that was found.

if isempty(Anritsu)
    Anritsu = tcpip('192.168.43.53', 9001);
else
    fclose(Anritsu);
    Anritsu = Anritsu(1);
end

% Connect to instrument object, obj1.
handles.Anritsu = Anritsu;
fopen(Anritsu);
%% Instrument Configuration and Control
% Fijamos el span
fprintf(Anritsu, [':FREQuency:SPAN ',get(handles.SPAN_edit_text,'String'),' ',handles.unidades]);
% Fijamos la frecuencia central
fprintf(Anritsu, [':FREQuency:CENTer ',get(handles.Center_Frequency_edit_text,'String'),' ',handles.unidades2]);
% Fija el nivel de refetencia (eje x) a -30 dbm.
fprintf(Anritsu, 'DISP:WIND:TRAC:Y:SCAL:RLEV -30');
% Modo de medida Channel power.
fprintf(Anritsu,'CONFigure:CHPower');
%Fija el type del trace en AVG
fprintf(Anritsu,':TRACe1:TYPE AVER');
% Activa el preamplificador según lo indicado
fprintf(Anritsu,[':POWer:RF:GAIN:STATe',' ',handles.preamp]);
%Fija la anchura de integración como indicamos en la interfaz
fprintf(Anritsu,[':CHPower:BWIDth:INTegration ',get(handles.Integration_BW,'String'),' ', handles.unidades3]);
% Configuramos el barrido como indicamos en la interfaz
fprintf(Anritsu, ['INIT:CONT', ' ',handles.sweep]);
fprintf(Anritsu, [':DISPlay:POINtcount ', get(handles.Sweep_point_edit_text,'String')]);
guidata(hObject,handles);
end
% medidas(i)=strcat(psd,gps);
% i+1;



% medidas= zeros(1000,5);
% i=1;


%Este comando devuelve TOTAL CHPOWER en dbm/HZ
% fprintf(Anritsu,':FETCH:CHPOWER:DENSITY?');
% chpower = fscanf(Anritsu);
% fprintf(Anritsu, '*WAI');
%Devuelve marca de tiempo, latitud, longitud y altura
% fprintf(Anritsu,':FETCh:GPS?');
% gps = str2double(fscanf(Anritsu));
% fprintf(Anritsu, '*WAI');
 



function Center_Frequency_edit_text_Callback(hObject, eventdata, handles)
% hObject    handle to Center_Frequency_edit_text (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Center_Frequency_edit_text as text
%        str2double(get(hObject,'String')) returns contents of Center_Frequency_edit_text as a double


% --- Executes during object creation, after setting all properties.
function Center_Frequency_edit_text_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Center_Frequency_edit_text (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function SPAN_edit_text_Callback(hObject, eventdata, handles)
% hObject    handle to SPAN_edit_text (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of SPAN_edit_text as text
%        str2double(get(hObject,'String')) returns contents of SPAN_edit_text as a double


% --- Executes during object creation, after setting all properties.
function SPAN_edit_text_CreateFcn(hObject, eventdata, handles)
% hObject    handle to SPAN_edit_text (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in Start_drive_testing.
function Start_drive_testing_Callback(hObject, eventdata, handles)

% hObject    handle to Start_drive_testing (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global medidas i chpower gpstotal chpower2 end_drive_test;
end_drive_test = 0;
Anritsu=handles.Anritsu;
fclose(Anritsu);
fopen(Anritsu);
while (end_drive_test==0)
i = i + 1;
%Este comando devuelve TOTAL CHPOWER en dbm
fprintf(Anritsu,':FETCh:CHPower:CHPower?');
chpower1 = fscanf(Anritsu);
chpower2{i,1} = chpower1;
chpower(i,1) = str2double(chpower1);

% % % Representar la potencia % % %
cla(handles.axes1,'reset');
plotTitle = 'Measures campaing'; % plot title
xLabel = 'Samples (n)'; % x-axis label
yLabel = 'Power (dBm)'; % y-axis label
plotGrid = 'on'; % 'off' to turn off grid
hold on;
title(handles.axes1, plotTitle,'FontSize',10);
xlabel(handles.axes1, xLabel,'FontSize',8);
ylabel(handles.axes1, yLabel,'FontSize',8);
grid(plotGrid);
plot(handles.axes1,1:1:length(chpower),chpower);
hold off;

%Devuelve marca de tiempo, latitud, longitud y altura
fprintf(Anritsu,':FETCh:GPS:FULL?');
%  fprintf(Anritsu,':FETCh:GPS:LAST?');
gps = fscanf(Anritsu);
C = 'NO FIX';
C = [C newline ''];
tf = strcmp(C,gps);
 if tf == 1
     for j=1:7
     gpstotal{i,j} = 'NF';
     end
 else
gps2=split(gps,[" ",","]);
gps3 = gps2.';
% [m,n]=size(gps3);
for j=1:7
gpstotal{i,j} = gps3{1,j};
end
 end
medidas = horzcat(chpower2,gpstotal);
% save('double_chpower.mat','chpower');
% save('datosgps_cell.mat','gpstotal');
save('medidas','medidas');
set(handles.Tomas,'String',i);
pause(0.5);
end
guidata(hObject,handles);

% --- Executes on button press in pause_drive_test.
function pause_drive_test_Callback(hObject, eventdata, handles)
% hObject    handle to pause_drive_test (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global end_drive_test
end_drive_test=1;
guidata(hObject,handles);


% --- Executes on button press in Save.
function Save_Callback(hObject, eventdata, handles)
% hObject    handle to Save (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global medidas
global chpower
global gpstotal
global chpower2

prompt = 'Name campaing: ';
campaing_name = input(prompt,'s');
if isempty(campaing_name)
    campaing_name = 'no_name';
end
save(campaing_name,'chpower','gpstotal','medidas');
Anritsu=handles.Anritsu;
fclose(Anritsu);
msgbox('Closed connection and saved campaign','OK')
guidata(hObject,handles);

function Save_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Integration_BW (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on selection change in unidades.
function unidades_Callback(hObject, eventdata, handles)
% hObject    handle to unidades (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns unidades contents as cell array
%        contents{get(hObject,'Value')} returns selected item from unidades
v=get(hObject,'Value');
switch v
    case 1
handles.unidades = 'HZ';
    case 2
handles.unidades = 'KHZ';
    case 3
handles.unidades = 'MHZ';
    case 4
handles.unidades = 'GHZ';
    otherwise
handles.unidades = 'HZ';      
end 
guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function unidades_CreateFcn(hObject, eventdata, handles)
% hObject    handle to unidades (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in unidades_2.
function unidades_2_Callback(hObject, eventdata, handles)
% hObject    handle to unidades_2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns unidades_2 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from unidades_2
v=get(hObject,'Value');
switch v
    case 1
handles.unidades2 = 'HZ';
    case 2
handles.unidades2 = 'KHZ';
    case 3
handles.unidades2 = 'MHZ';
    case 4
handles.unidades2 = 'GHZ';
    otherwise
handles.unidades2 = 'HZ';      
end 
guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function unidades_2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to unidades_2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Pream_edit_text_Callback(hObject, eventdata, handles)
% hObject    handle to Pream_edit_text (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Pream_edit_text as text
%        str2double(get(hObject,'String')) returns contents of Pream_edit_text as a double


% --- Executes during object creation, after setting all properties.
function Pream_edit_text_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Pream_edit_text (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Sweep_point_edit_text_Callback(hObject, eventdata, handles)
% hObject    handle to Sweep_point_edit_text (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Sweep_point_edit_text as text
%        str2double(get(hObject,'String')) returns contents of Sweep_point_edit_text as a double


% --- Executes during object creation, after setting all properties.
function Sweep_point_edit_text_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Sweep_point_edit_text (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in radiobutton1.
function radiobutton1_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if (get(handles.radiobutton1,'Value') == 0)
   handles.preamp = 'OFF';
else
    handles.preamp = 'ON';
end
guidata(hObject,handles);

% Hint: get(hObject,'Value') returns toggle state of radiobutton1


% --- Executes on button press in radiobutton2.
function radiobutton2_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if (get(handles.radiobutton2,'Value') == 0)
   handles.sweep = 'OFF';
else
    handles.sweep = 'ON';
end
guidata(hObject,handles);
% Hint: get(hObject,'Value') returns toggle state of radiobutton2


% --- Executes on selection change in popupmenu5.
function popupmenu5_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu5 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu5


% --- Executes during object creation, after setting all properties.
function popupmenu5_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Integration_BW_Callback(hObject, eventdata, handles)
% hObject    handle to Integration_BW (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Integration_BW as text
%        str2double(get(hObject,'String')) returns contents of Integration_BW as a double


% --- Executes during object creation, after setting all properties.



% --- Executes on selection change in Integration_BW.

% --- Executes during object creation, after setting all properties.
function Integration_BW_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Integration_BW (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in unidades3.
function unidades3_Callback(hObject, eventdata, handles)
% hObject    handle to unidades3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
v=get(hObject,'Value');
switch v
    case 1
handles.unidades3 = 'HZ';
    case 2
handles.unidades3 = 'KHZ';
    case 3
handles.unidades3 = 'MHZ';
    case 4
handles.unidades3 = 'GHZ';
    otherwise
handles.unidades3 = 'HZ';      
end 
guidata(hObject,handles);

% Hints: contents = cellstr(get(hObject,'String')) returns unidades3 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from unidades3


% --- Executes during object creation, after setting all properties.
function unidades3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to unidades3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function axes1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to axes1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: place code in OpeningFcn to populate axes1
