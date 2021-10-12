close all
clear all

load MedidasTF.mat;
Gtd=17.5;
Grd=17.5; % ganancia de las antenas

H_Luis= hD_28(:,:,:,:);
dimensionesMatrizH=size(H_Luis);
X=dimensionesMatrizH(1);
Y=dimensionesMatrizH(2);
T=dimensionesMatrizH(3);
Dist=dimensionesMatrizH(4);

realizaciones = X*Y;
Distancia = (150:5:420);
Dlog=10*log10(Distancia);

frec=28e9;
frec_ini=27.5e9;
frec_fin=28.5e9;

B=frec_fin-frec_ini;
N=2001;

tau=0:1/B:(N-1)/B;
tau_micro=tau/1e-6;


  
for Dist = 1:1: length(H_Luis(1,1,1,:))
    
    matrizh_d =squeeze(H_Luis(:,:,:,Dist));
      
     
            H=reshape(matrizh_d(:,:),X*Y,T);
            
 for jj=1:realizaciones

        H_temp=squeeze(H(jj,:));
        h_temp=ifft(ifftshift(hanning(N).'.*H_temp));
        matrizj(jj,:)=abs(H_temp).^2;
        matrizh(jj,:)=abs(h_temp).^2;
       
       
 end
 limiteDBdc(Dist)=-max(10*log10(matrizh));
 Ldc(Dist)=+Gtd+Grd-10*log10(mean(matrizj));
 Ldc_BestPDP(Dist)=Gtd+Grd+limiteDBdc(Dist);
 
    
end 


syms n;
syms l;

Lfreespace_1m=-20*log10(3e8/(4*pi*frec));
FreeSpace=Lfreespace_1m+2*Dlog;
N1=length(Distancia);


for k=1:N1
    P11(k)=(Ldc(1)+n*10*log10(Distancia(k)/Distancia(1)));
end
 NMSE=eval((sum((Ldc-P11).^2))/N1);
 dNMSE=diff(NMSE,n);
 nNMSE=solve(dNMSE==0,n);
 PL_CI_1m=Ldc(1);
 
 n_CI=eval(nNMSE);
 
%VArianza CI
 for k=1:N1
    P1(k)= (Ldc(1)+(n_CI*10*log10(Distancia(k)/Distancia(1))));
    
end
 NMSE1=(sum((Ldc-P1).^2))/N1;
 std_CI=sqrt(NMSE1);
 
 
Ldc_1m=Ldc(1)+n_CI*Dlog;

%Mejor Caso PDP

Pend_BestPDPdc=polyfit(Dlog,Ldc_BestPDP,1); 
LO_BestPDPdc=Pend_BestPDPdc(2);
np_BestPDPdc=Pend_BestPDPdc(1);
L1p_BestPDPdc=LO_BestPDPdc+np_BestPDPdc*Dlog;

Pend_PLdc=polyfit(Dlog,Ldc,1);
LO_PLdc=Pend_PLdc(2);
np_FI=Pend_PLdc(1);

Llp_PLdc=LO_PLdc+np_FI*Dlog;

PL_FI=LO_PLdc;
% PL_CI=Lcd(1);
 %varianza FI
 
 for k3=1:N1
    P3(k3)= -(-LO_PLdc-(np_FI*Dlog(k3)));
    %P3(k3)=eval(P3(k3))
end
 NMSE3=(sum((Ldc-P3).^2))/N1;
  std_FI=sqrt(NMSE3);

  
  MatrizMaxPDP=[Distancia;Ldc_BestPDP]';
      
save PerdidasDC.mat



% %Medidas
% semilogx(Distancia,Ldc,'ro');

% hold on

%BestPDP
plot(Distancia, Ldc_BestPDP,'bo');
% 
% %Espacio Libre
% semilogx(Distancia,FreeSpace,'k','linewidth',3);
% 
% %Recta Regresión BestPDP
% semilogx(Distancia,L1p_BestPDPdc,'b','linewidth',1)
% 
% %Recta Regresión FI
% semilogx(Distancia,Llp_PLdc,'r','linewidth',1);
% 
% %Recta Regresión CI
% semilogx(Distancia,Ldc_1m,'r--','linewidth',2);

title('Measurements 28 GHz');
ylabel('Pr (dBm)');
xlabel('High');
grid on
set(gca,'xtick',[150:10:420]);
% legend('Measurements Horn','BEST PDP','Free Space','FI BEST PDP','FI Horn','CI Horn')
legend('BEST PDP')
% hold off






