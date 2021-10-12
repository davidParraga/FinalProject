load('filas.mat');
posicion_tx = [37.880904,-1.289244];
miscalles = {f1, f2, f3, f4, f5, f6, f7, f8, f9, f10, f11, f12, f13, f14, f15, f16, f17, f18, f19, f20, f21};   
tangente = {f1{108,:}; f2{18,:}; f3{104,:}; f4{17,:}; f5{98,:}; f6{15,:}; f7{104,:}; f8{9,:}; f9{113,:}; f11{132,:}; f10{22,:}; f12{12,:}; f13{120,:}; f14{22,:}; f15{12,:}; f16{91,:}; f17{10,:}; f18{98,:}; f19{10,:}; f20{92,:}; f21{12,:}};

for i = 1:length(tangente)
lat_angle = str2double(tangente(:,5));
long_angle = str2double(tangente(:,6));
[j,k,utmzoneang] = deg2utm(lat_angle,long_angle);
[l,m,zoneang] = deg2utm (posicion_tx(1),posicion_tx(2));
 l(1:length(j),:) = l;
 m(1:length(j),:) = m;
 disttangente = (sqrt((j-l).^2+(k-m).^2)).'; %Distancia del tx con medida de referencia
end

for i = 1:length(miscalles)         
    lat = str2double(miscalles{i}(:,5));
    long = str2double(miscalles{i}(:,6));
    [x,y,utmzone1] = deg2utm(lat,long);
    [z,t,zone2] = deg2utm (posicion_tx(1),posicion_tx(2));
    z(1:length(x),:) = z;
    t(1:length(x),:) = t;
    dist = (sqrt((x-z).^2+(y-t).^2)).';
    pot = str2double(miscalles{i}(:,1));
    angle = acos (disttangente(i) ./ dist);
    angle_test = angle;
for r = 1:length(angle)
       if imag(angle(r)) ~= 0
           angle(r) = NaN;
           pot (r) = NaN;
       end
end
angle = radtodeg (angle);

% % for f = 1:length(angle)
%     if angle(f) ~= 0
    figure(i)
    plot(angle,pot,'bo');
    titulo1 = 'potencia-angulo f';
    titulo2 = num2str(i);
    titulo = strcat(titulo1,titulo2);
    title(titulo)
    xlabel('ángulo(grados)')
    ylabel('potencia (dbm)')
    hold off
%     end
end
