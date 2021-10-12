
% potencias= zeros(1000,1);
% i=1;
% for i=1:1000
%  fprintf(Anritsu,':FETCH:CHPOWER:DENSITY?');
%  psd = str2double(fscanf(Anritsu));
%  potencias(i, 1)=psd;
%  i=i+1;
% end

% medidas= zeros(1000,5);
% i=1;

%% Instrument Connection

% Find a tcpip object.
Anritsu = instrfind('Type', 'tcpip', 'RemoteHost', '192.168.0.197', 'RemotePort', 9001, 'Tag', '');

% Create the tcpip object if it does not exist
% otherwise use the object that was found.
if isempty(Anritsu)
    Anritsu = tcpip('192.168.0.197', 9001);
else
    fclose(Anritsu);
    Anritsu = Anritsu(1);
end

% Connect to instrument object, obj1.
fopen(Anritsu);


%% Instrument Configuration and Control

% Communicating with instrument object, obj1.
fprintf(Anritsu, 'SENS:FREQ:STAR 2 GHz');
fprintf(Anritsu, 'SENS:FREQ:STOP 2.8 GHz');

% Ancho de banda de resolución:
fprintf(Anritsu, 'BAND:RES 30 KHz');
% Fija el nivel de refetencia a -30 dbm. El nivel de refencia es el 
% valor donde se ubicará el eje x
fprintf(Anritsu, 'DISP:WIND:TRAC:Y:SCAL:RLEV -30');
% activa el barrido continuo
fprintf(Anritsu, 'INIT:CONT ON');
fprintf(Anritsu,'CONFigure:CHPower');
fprintf(Anritsu, '*WAI');
%fija el type del trace a quedarse con los valores máximos
fprintf(Anritsu,':TRACe1:TYPE MAX');
%Fija la anchura de integración
fprintf(Anritsu,':CHPower:BWIDth:INTegration 0.2 GHZ');
fprintf(Anritsu, '*WAI');




%Este comando devuelve el valor de la potencia en dbm/hz:
fprintf(Anritsu,':FETCH:CHPOWER:DENSITY?');
psd = str2double(fscanf(Anritsu));

tic
for i=1:10
%Este comando devuelve TOTAL CHPOWER en dbm:
fprintf(Anritsu,':FETCh:CHPower:CHPower?');
chpower = fscanf(Anritsu);
end
toc

%Devuelve marca de tiempo, latitud, longitud y altura
% fprintf(Anritsu,':FETCh:GPS?');
fprintf(Anritsu,':FETCh:GPS:LAST?');
gps = fscanf(Anritsu);
fprintf(Anritsu, '*WAI');

% Vamos a comprobar si se guardan bien las medidas concatenando.
%  medidas(i)=strcat(psd,gps);

%%
gps2=split(gps,[" ",","]);
gps3 = gps2.';
medidas = [psd gps3];
