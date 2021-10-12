load('filas.mat');
posicion_tx = [37.880904,-1.289244];


miscalles = {f1, f2, f3, f4, f5, f6, f7, f8, f9, f10, f11, f12, f13, f14, f15, f16, f17, f18, f19, f20, f21};         
   
for i = 1:length(miscalles)         
    lat = str2double(miscalles{i}(:,5));
    long = str2double(miscalles{i}(:,6));
    [x,y,utmzone1] = deg2utm(lat,long);
    [z,t,zone2] = deg2utm (posicion_tx(1),posicion_tx(2));
    z(1:length(x),:) = z;
    t(1:length(x),:) = t;
    distpot = (sqrt((x-z).^2+(y-t).^2)).';
    distpot(2,:) = str2double(miscalles{i}(:,1));
    figure(i)
    plot(distpot(1,:),distpot(2,:),'bo');
    titulo1 = 'potencia-distancia f';
    titulo2 = num2str(i);
    titulo = strcat(titulo1,titulo2);
    title(titulo)
    xlabel('distancia(m)')
    ylabel('pérdidas (db)')
    % save('distancia','dist');
hold off
end




% lat = str2double(b(:,5));
% long = str2double(b(:,6));
% % lat=cell2mat(lat);
% % long=cell2mat(long);
% [x,y,utmzone1] = deg2utm(lat,long);
% posicion_tx = [37.880904,-1.289244];
% [z,t,zone2] = deg2utm (posicion_tx(1),posicion_tx(2));
% z(1:length(x),:) = z;
% t(1:length(x),:) = t;
% distpot = (sqrt((x-z).^2+(y-t).^2)).';
% distpot(2,:) = str2double(b(:,1));
% close all
% figure(1)
% plot(distpot(1,:),distpot(2,:),'bo');
% title('Variación potencia')
% xlabel('distancia(m)')
% ylabel('pérdidas (db)')
% % save('distancia','dist');
% hold off