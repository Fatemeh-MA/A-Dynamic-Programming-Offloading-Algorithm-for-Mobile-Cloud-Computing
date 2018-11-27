%in the name of allah
function [Decision_Matrix,E_min,T_min]=GA(tasks,N)

mutation_probability = 0.5;
number_of_generations = 100000;
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

%random genetic cells
x = randi([0,1],1,N);
if (x==ones(1,N) )
    x = randi([0,1],1,N);
end
if x==zeros(1,N)
    x = randi([0,1],1,N);
end
E=zeros(1,N);
T=zeros(1,N);
for k=1:N
    E(k)= x(k)*EL(k)+(1-x(k))*EC(k);
    T(k)= x(k)*TL(k)+(1-x(k))*TC(k);
end


E_min=1e20;
T_min=1e20;

%Starting GA loop
for o=1:number_of_generations
    
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
        E(k)= x(k)*EL(k)+(1-x(k))*EC(k);
        T(k)= x(k)*TL(k)+(1-x(k))*TC(k);
    end
    if (( sum(E)<=E_min ) && ( sum(T) < T_constraint) )
        E_min=sum(E);
        T_min=sum(T);
        Xmin=x;
    end
    
    
    
end
disp('GA')
T_min
E_min
Decision_Matrix=Xmin;
end

