function [EL,EC,TL,TC,Cci]= Cal_E_T7(T_rate,tasks,N)

Beta=5e-7; 

%based on tabel 1,2 in article
Cff=730e6; %cycle/energy(j)
Dff=860e3 ; %byte/energy(j)

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

 %initialize output data
D_out=(3*rand(1,N)); %between 1-3 MB
%initialize input data [.1 .1 .1 .1 .1 .1 .1]
D_in=randi([10,30],1,N); %between 10 -30 MB
 for ii=1:N
     D_in(ii)=1/D_in(ii);
     D_out(ii)=1/D_out(ii);
 end
 


Cci= D_in;

for i=1:N
   EL(i)= tasks(i)/(8*Cff); %conver byte to bit
   TL(i)=tasks(i)/(8*F_local); %s/bit
   
   Er(i)=1/(8*Dff);
   Tr(i)=D_out(i)/T_rate;
   Tc1(i)=D_in(i)*tasks(i)/(8*F_cloud); %s/bit
   
   Et(i) =1/(8*Dff);
   Tt(i)=D_in(i)/T_rate;
   TC(i)=Tr(i)+Tt(i)+Tc1(i);
   EC(i)=Er(i) + Et(i) + Beta*Cci(i);
end
