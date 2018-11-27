function [EL,EC,TL,TC,Cci]= Cal_E_T8(T_rate,D_in,D_out,tasks,N)

Beta=5e-7; 

%based on tabel 1,2 in article
Cff=730e6; %cycle/energy(j)
Dff=860e3 ; %byte/energy(j)



% tasks=[330,300,900,100,900,960,900];%cycle/byte
%tasks=[5330,6300,4900,2000,190,1960,8900,800,10,8900];%cycle/byte
%tasks=randi([10,10000],1,10);
N= size(tasks,2);

%initialize energy j/bit
EL=zeros(1,N);
Et=zeros(1,N);
Er=zeros(1,N);

%initialize time s/bit
TL=zeros(1,N);
Tr=zeros(1,N);
Tt=zeros(1,N);

F_local=500e6; %cpu frequence cycle/s in local
F_cloud=10e9;  %cpu frequence cycle/s in cloud

 


Cci= D_in;

for i=1:N
   EL(i)= D_in(i)*tasks(i)/(8*Cff); %conver byte to bit
   TL(i)=D_in(i)*tasks(i)/(8*F_local); %s/bit
   
   Er(i)=D_out(i)/(8*Dff);
   Tr(i)=D_out(i)/T_rate;
   Tc1(i)=D_in(i)*tasks(i)/(8*F_cloud); %s/bit
   
   Et(i) =D_in(i)/(8*Dff);
   Tt(i)=D_in(i)/T_rate;
   TC(i)=Tr(i)+Tt(i)+Tc1(i);
   EC(i)=Er(i) + Et(i) +D_in(i)* Beta;
   
end
