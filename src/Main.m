%in the name of Allah
%% initialize


clc;
clear all;
close all;
disp( 'This program is designed to determine the offloading of tasks to reduce mobile energy');
tasks=[5930,3900,1700,6880,6800,2400,5960,5400,8700,900,800,900,5900,7700,6200];%cycle/byte
N= size(tasks,2);

Decision_Matrix_Dynamic = dynamic7(tasks,N);
Decision_Matrix_GA = GA(tasks,N);
disp ('Based on the energy specified for each task, the final decision system is executed as follows:');
disp ('If the bit value is equal to 0, the work is done offloading and otherwise its done locally.');
disp('  ');
disp('Tasks ')
tasks
disp('Final Decision Matrix for GA Algorithm:  ' )
Decision_Matrix_GA
disp('Final Decision Matrix for Dynamic Method:  ');
Decision_Matrix_Dynamic

disp('Please enter a key to view plots');
pause

[E_min,E_min_GA,T_min,T_min_GA,TL1,TC1,EC1,EL1,TL1_GA,TC1_GA,EC1_GA,EL1_GA,Emin,Emin_GA,Tmin,Tmin_GA]=Plot(tasks,N);


disp('E_min for Dynamic ')
E_min

disp('E_min_GA for Genetic Algorithm ')
E_min_GA

% 
% T = table(TL1,TC1,EC1,EL1,TL1_GA,TC1_GA,EC1_GA,EL1_GA);
% csvwrite('trainlabels.csv',T)
% writetable(T,'report.xls','WriteVariableNames',true,'Sheet',1);