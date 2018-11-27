%% PLOT
function [E_min,E_min_GA,T_min,T_min_GA,TL1,TC1,EC1,EL1,TL1_GA,TC1_GA,EC1_GA,EL1_GA,Emin,Emin_GA,Tmin,Tmin_GA]=Plot(tasks,N)
mutation_probability = 0.5;
iter1=50;
Trate1=[3,5,8,10]*1e6;
Trate2=[20,5,75]*1e6;
E1=[];
TL2=[];
TC2=[];
TL1=[];
TC1=[];
EL2=[];
EC2=[];
EL1=[];
EC1=[];
Tmin2=[];
TL1_GA=[];
TC1_GA=[];
Tmin_GA=[];
EC1_GA=[];
EL1_GA=[];

Emin_GA=[];
T_constraint=700;
%initialize output data
% D_out=[3 3 2 2.5 3 3 3 3 3 2.5 3 3 2.5 3 2.8]*8e6; %between 1-3 MB
% D_in=8e6*[5 5 6 10 6 10 10 10 10 10 9 10 10 10 10]%randi([5,15],1,N); %between 10 -30 MB
D_out=[3 3 3 2.8 2.8 2.8 2.8 2 2 1.5 1 1 2 2 1]*8e6; %between 1-3 MB
D_in=8e6*[10 10 10 9 9 9 9 9 6 6 5 5 7 8 5];%randi([5,15],1,N); %between 10 -30 MB

for way=1:2
    M=[];
    T_rate=[];
    if way==1
        T_rate=Trate1;
    else
        T_rate=Trate2;
    end
    for tr=1:size(T_rate,2)
        
        [EL,EC,TL,TC,Cci]= Cal_E_T8(T_rate(tr),D_in,D_out,tasks,N);
%         [EL_GA,EC_GA,TL_GA,TC_GA,Cci]= Cal_E_T8(T_rate(tr),D_in,D_out,tasks,N);

        E_min=1e20;
        T_min=1e20;
        E_GA=zeros(1,N);
        %initialize time s/bit
        T_GA=zeros(1,N);
        E_min_GA=1e20;
        T_min_GA=1e20;
        E_total=zeros(1,iter1);
                    visited=zeros(N,N);
            E=zeros(N,N);
            %initialize time s/bit
            T=zeros(N,N);
        
            T_total=zeros(1,iter1);
            for iter=1:iter1
                %random bit stream
                M = randi([0,1],1,N);
                if (M==ones(1,N) )
                M = randi([0,1],1,N);
            end
            if M==zeros(1,N)
                M = randi([0,1],1,N);
            end
            
            i=1;
            j=1;
            table1=2*ones(N,N);
            
            for k=1:N
                if M(k)==0
                    i=i+1;
                    table1(i,j)=M(k);
                else
                    j=j+1;
                    table1(i,j)=M(k);
                end
                if visited(i,j)==0
                    E(i,j)= M(k)*EL(k)+(1-M(k))*EC(k);
                    T(i,j)= M(k)*TL(k)+(1-M(k))*TC(k);
                    E_total(iter)=E_total(iter)+1+E(i,j);
                    T_total(iter)=T_total(iter)+1+T(i,j);
                    visited(i,j)=1;
                    table2(i,j)=M(k);
                    E1(k)=E(i,j); %save energy for every tasks
                    T1(k)=T(i,j);
                else %this specific cell in table is visited before
                    e= M(k)*EL(k)+(1-M(k))*EC(k);
                    t= M(k)*TL(k)+(1-M(k))*TC(k);
                    if E(i,j)>e %the new Total Energy of the cell is less than the previous one
                        E1(k)=e;
                        T1(k)=t;
                        table2(i,j)=M(k);
                        E(i,j)=e;
                        T(i,j)=t;
                        
                    end
                    E_total(iter)=E_total(iter)+E(i,j)+1;
                    T_total(iter)=T_total(iter)+T(i,j)+1;
                end
            end

            
            Stream(:,:,iter)=M;
            
%              E_total(iter)=sum(E1);
%                 T_total(iter)=sum(T1);
% %                 E_total(iter)=sum(sum(E))/2;
% %                 T_total(iter)=sum(sum(T))/2;
            if ( E_total(iter)<=E_min ) && ( T_total(iter) < T_constraint) && (size(E1,2)==N)
                E_min=E_total(iter);
                T_min=T_total(iter);
                it=iter ;
                M_min=M;
            end
            
            %**********************************GA*************************8
            for kk=1:1000
                x = randi([0,1],1,N);
                if (x==ones(1,N) )
                    x = randi([0,1],1,N);
                end
                if x==zeros(1,N)
                    x = randi([0,1],1,N);
                end
                
                %select point to cross over
                cut_point = round(2+rand*(N-2));
                
                %new individual AB
                x = x(1:cut_point);
                x11=randi([0,1],1,N-cut_point);
                x = [x x11];
                
                
                %mutation AB
                ran_mut = rand;
                if ran_mut < mutation_probability
                    gene_position = round(1 + rand(1,2)*(N-1));
                    a=x(gene_position);
                    fl=fliplr(a');
                    x(gene_position) = fl;
                end
                
                for k=1:N
                    E_GA(k)= x(k)*EL(k)+(1-x(k))*EC(k);
                    T_GA(k)= x(k)*TL(k)+(1-x(k))*TC(k);
                end
                Stream_GA(:,:,iter)=x;
                E_GA_total(iter)=sum(E_GA);
                T_GA_total(iter)=sum(T_GA);
                if (( sum(E_GA)<E_min_GA ) && ( sum(T_GA) < T_constraint) )
                    %disp('min');
                 for k=1:N
                    EL_GA1(k)=EL(k);
                    EC_GA1(k)=EC(k);
                    TC_GA1(k)=TC(k);
                    TL_GA1(k)=TL(k);
                 end
                    E_min_GA=sum(E_GA);
                    T_min_GA=sum(T_GA);
                    it_GA=iter;
                    
                end
            end
        end
        %dynamic
        TL1(way,tr)=sum(TL);
        TC1(way,tr)=sum(TC);
        Tmin(way,tr)=T_min;
        EC1(way,tr)=sum(EC)+TC1(way,tr);
        EL1(way,tr)=sum(EL);
        
        Emin(way,tr)=E_min+Tmin(way,tr);
        
        %GA
        TL1_GA(way,tr)=sum(TL_GA1);
        TC1_GA(way,tr)=sum(TC_GA1);
        Tmin_GA(way,tr)=T_min_GA;
        EC1_GA(way,tr)=sum(EC_GA1)+TC1_GA(way,tr);
        EL1_GA(way,tr)=sum(EL_GA1);
        
        Emin_GA(way,tr)=E_min_GA+Tmin_GA(way,tr);
        
    end
    
end


figure

plot(Trate1,Tmin(1,:),'-ro',Trate1,TL1(1,:),'--.b',Trate1,TC1(1,:),'-g*',Trate1,700*ones(1,4),'-*m','LineWidth',3)
hold on
 plot(Trate1,Tmin_GA(1,:),'--co',Trate1,TL1_GA(1,:),'--<y',Trate1,TC1_GA(1,:),'--b*',Trate1,700*ones(1,4),'--*k','LineWidth',2)
legend('Time for DPH with Dynemic','Time for All Local with Dynemic','Time for all on Cloud with Dynemic','fix with Dynemic','Time for DPH with GA','Time for All Local with GA','Time for all on Cloud with GA','fix with GA')
% plot(T_rate,y1,'Marker','o','MarkerSize',10,'MarkerFaceColor','M');

figure
plot(Trate1,Emin(1,:),'-ro',Trate1,EL1(1,:),'-.b',Trate1,EC1(1,:),'-g*','LineWidth',2)
hold on
plot(Trate1,Emin_GA(1,:),'--m',Trate1,EL1_GA(1,:),'--.k',Trate1,EC1_GA(1,:),'--y*','LineWidth',2)
legend('Energy for DPH with Dynamic','Energy for All Local with Dynamic','Energy for all on Cloud with Dynamic','Energy for DPH with GA','Energy for All Local with GA','Energy for all on Cloud with GA')

figure
y=[EL1(1) EL1_GA(1) Emin(2,1) Emin_GA(2,1) Emin(2,2) Emin_GA(2,2) Emin(2,3) Emin_GA(2,3);TL1(1) TL1_GA(1) Tmin(2,1) Tmin_GA(2,1) Tmin(2,2) Tmin_GA(2,2) Tmin(2,3) Tmin_GA(2,3)];
bar(y)
 somenames={'Energy'; 'Time'};
set(gca,'xticklabel',somenames)
legend('Energy and Time for all local with Dynamic','Energy and Time for all local with GA','Energy and Time for DPH with 20Mbps with Dynamic',...
    'Energy and Time for DPH with 20Mbps with GA','Energy and Time for DPH with 5Mbps with Dynamic','Energy and Time for DPH with 5Mbps with GA',...
    'Energy and Time for DPH with 72Mbps with Dynamic','Energy and Time for DPH with 72Mbps with GA')
% legend('Energy and Time for all local with Dynamic','Energy and Time for all local with GA','Energy and Time for DPH with 20Mbps with Dynamic',...
%     'Energy and Time for DPH with 5Mbps with Dynamic','Energy and Time for DPH with 72Mbps with Dynamic',...
%     'Energy and Time for DPH with 20Mbps with GA','Energy and Time for DPH with 5Mbps with GA','Energy and Time for DPH with 72Mbps with GA')
% 


figure
hh=plot([10,12,15,20,25,30],[118,130,144,160,220,279],'Marker','o','MarkerSize',10,'MarkerFaceColor','M');
axis([10 30 100 310])
xlabel('N(Number of tasks)')
ylabel('Time (ms)')