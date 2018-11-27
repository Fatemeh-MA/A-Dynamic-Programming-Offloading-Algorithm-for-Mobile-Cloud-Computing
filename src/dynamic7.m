function [Decision_Matrix,E_min,T_min]=dynamic7(tasks,N)

iter1=50; %number of iteration
E_min=1;
T_constraint=700; %time constraint
T_rate=3e6; %bit/s

EC=[];
EL=[];
TL=[];
TC=[];


%calculate energy and time for tasks
[EL,EC,TL,TC,Cci]= Cal_E_T7(T_rate,tasks,N);

%initialize table of tasks
table1=2*ones(N,N);

%initialize energy j/bit
E=zeros(N,N);
E_total=zeros(1,iter1);

%initialize time s/bit
T=zeros(N,N);
T_total=zeros(1,iter1);

%visited matrix if bit visit before set 1 else 0
visited=zeros(N,N);
table2=[];

%final matrix if task is offloading, bit is 0 else 1
Decision_Matrix=zeros(1,N);


E1=[];


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
%             disp('not visited');
            E(i,j)= M(k)*EL(k)+(1-M(k))*EC(k);
            T(i,j)= M(k)*TL(k)+(1-M(k))*TC(k);
%                        E_total(iter)=E_total(iter)+E(i,j);
%                        T_total(iter)=T_total(iter)+T(i,j);
            visited(i,j)=1;
            table2(i,j)=M(k);
            E1(k)=E(i,j); %save energy for each tasks
            if E1(k)<2e-7
                Decision_Matrix(k)=M(k);
            end
        else %this specific cell in table is visited before
           
%             disp('visited');
            e= M(k)*EL(k)+(1-M(k))*EC(k);
            t= M(k)*TL(k)+(1-M(k))*TC(k);
            
            if E(i,j)>e %the new Total Energy of the cell is less than the previous one
                E1(k)=e;
                Decision_Matrix(k)=M(k);
                table2(i,j)=M(k);
                E(i,j)=e;
                T(i,j)=t;
            else if E(i,j)==e
                    %  disp('two energies are equal');
                    if e<2e-7
                        
                        Decision_Matrix(k)=M(k);
                    end
                end
            end
            
%                        E_total(iter)=E_total(iter)+E(i,j);
%                        T_total(iter)=T_total(iter)+T(i,j);
        end
    end
    E_total(iter)=sum(sum(E));
T_total(iter)=sum(sum(T));
    Stream(:,:,iter)=M;
    
    %change the situation of system
    if (iter==(iter1/3)) && (size(Decision_Matrix,2)==N ) %Replace the amount of T_rate in 1/3 of iteration and calculate energy and time
        disp('new D_in1********************************');
        T_rate=5e6;
        [EL,EC,TL,TC,Cci]= Cal_E_T7(T_rate,tasks,N);
        
    else if (iter==(2*iter1/3)) && (size(Decision_Matrix,2)==N) %Replace the amount of T_rate in 2/3 of iteration and calculate energy and time
            disp('new D_in2****************************');
            T_rate=8e6;
            [EL,EC,TL,TC,Cci]= Cal_E_T7(T_rate,tasks,N);
            
        end
    end
    
    
    if ( E_total(iter)<=E_min ) && ( T_total(iter) < T_constraint) && (size(E1,2)==N)
        E_min=E_total(iter);
        T_min=T_total(iter);
        it=iter;
    end
    
end
disp('Dynamic')
E_min
T_min
end
