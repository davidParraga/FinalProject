%load('medidas_3.5ghz.mat');
load('3.5ghz.mat')
lat = str2double(a(:,5));
long = str2double(a(:,6));
% lat=cell2mat(lat);
% long=cell2mat(long);
[x,y,utmzone1] = deg2utm(lat,long);
posicion_tx = [37.880904,-1.289244];
[z,t,zone2] = deg2utm (posicion_tx(1),posicion_tx(2));
z(1:length(x),:) = z;
t(1:length(x),:) = t;
dist = (sqrt((x-z).^2+(y-t).^2)).';

% save('distancia','dist');

%Pérdidas y ganancia de antenas
Gt=0;
Gr=0;
Pt=8;
Pr=str2double((a(:,1))).';
L_medidas=Pt+Gt+Gr-Pr;

%Espacio libre
frec=3.5e9;
Lfreespace_1m=-20*log10(3e8/(4*pi*frec));
FreeSpace=Lfreespace_1m+2*10*log10(dist);

% Método CI
syms n;
syms l; 
N1=length(dist);
Lfreespace_ref=-20*log10(3e8/(4*pi*frec*100));
Ldc=L_medidas;
% Ldc(1)=Lfreespace_ref;
% for k=1:1
%  P11(k)=Ldc(1)+n*10*log10(dist(k)/dist(1));
% end
P11=Ldc(1)+n*10*log10(dist/100);
NMSE=eval((sum((Ldc-P11).^2))/N1); 
dNMSE=diff(NMSE,n);
nNMSE=solve(dNMSE==0,n); 
n_CI=eval(nNMSE);
%Varianza CI
% for k=1:N1
% P1(k)= (Ldc(1)+(n_CI*10*log10(dist(k)/dist(1))));     
%  end
P1= Ldc(1)+(n_CI*10*log10(dist/100));
NMSE1=(sum((Ldc-P1).^2))/N1;
std_CI=sqrt(NMSE1);
% Dlog=10*log10(dist);
Lp_CI=Ldc(1)+n_CI*10*log10(dist./100);

%Método FI
Dlog=10*log10(dist);
Pend_FI=polyfit(Dlog,Ldc,1); 
LO_FI=Pend_FI(2);
np_FI=Pend_FI(1);
Lp_FI=LO_FI+np_FI*Dlog;

 %varianza FI
 
 for k3=1:N1
    P3(k3)= -(-LO_FI-(np_FI*Dlog(k3)));
    %P3(k3)=eval(P3(k3))
end
 NMSE3=(sum((Ldc-P3).^2))/N1;
  std_FI=sqrt(NMSE3);

%representación
figure(2)
semilogx(dist,Ldc,'bo')
axis([100 500 65 105])
x=[100 200 300 400 500];
set(gca,'XTick',x)
grid on
hold on
title('Pérdidas - distancia ')
xlabel('Distancia (m)')
ylabel('Pérdidas(dB)')
%Espacio Libre
semilogx(dist,FreeSpace,'k','linewidth',3);
%Método CI
semilogx(dist,Lp_CI,'g','linewidth',2)
%Método FI
semilogx(dist,Lp_FI,'r','linewidth',1);
legend('Medidas','FreeSpace','CI','FI');

hold off