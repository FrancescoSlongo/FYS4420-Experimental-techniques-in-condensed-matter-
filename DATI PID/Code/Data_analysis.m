%% Data analysis for EXP 1 - PID Control
zzz
%% Task 3
load('task_3_temp_check.mat','T');
Troom = mean(T(1,1:2853));
dTroom = std(T(1,1:2853));
clear T;

%% Task 4 (4.1 and 4.2)
load('task_4_temp_check','T');
Tinf_1 = mean(T(1,8000:10000));
dTinf_1 = std(T(1,8000:10000));
clear T;

load('task_4_1_temp_check','T');
Tinf_2 = mean(T(1,6000:10800));
dTinf_2 = std(T(1,6000:10800));
clear T;

%% Task 5-6 (calcolo H0, T1, T2)
load('task_5.mat');
% parametri
t = 0.6*[1:length(T)]; %[s]
Vpulse = 3.5; % [V]
Vstep = 3;
eps = 18; % [s] +- 1s
T = T - Troom * ones(1, length(T));
H0_1 = (Tinf_1-Troom)/Vstep; %[T/V] dati merdosi!
H0_2 = (Tinf_2-Troom)/Vstep; 
dH0_1 = sqrt(dTinf_1^2 + dTroom^2)/Vstep; 
dH0_2 = sqrt(dTinf_2^2 + dTroom^2)/Vstep; 


% Trovare il punto di massimo
figure();
plot(t,T);
% coordinate del punto di massimo
rp = 2.62816; % trovare a occhio e inserire a mano
tp = 27.6;

% Funzione rp = f(T12)
% vettore con T12
T12 = [1,0:0.1:400]; 
% funzione rp = f(T12)
rp_func = Vpulse*H0_1.*exp(-tp./T12).*(exp(eps./T12) - 1);
% plot della funzione con la retta di intersezione
figure();
plot(T12,rp_func,'linewidth', 1.5,'color', 'r');
hold on
plot(T12,rp.*ones(1, length(T12)),'linewidth', 1.5,'color', 'b');
xl = xlabel('$T_{12} [s]$', 'interpreter', 'latex');
set(xl, 'FontSize', 12);
yl = ylabel('$r_P [K]$', 'interpreter', 'latex');
set(yl, 'FontSize', 12);
grid on;
% Legend
legend('rp as function of T_{12}','Value of the peak r_P','location','northeast');
% Trovare a occhio T1 e T2
T1 = 3.941;
T2 = 188.304;

%% Task 7
P=(1/3)*((T1+T2)^2)/(T1*T2)-1;
I=(1/27)*((T1+T2)^3)/((T1*T2)^2);
Kp=P/H0_1;
dKp = P/H0_1^2*dH0_1;
Ki=I/H0_1;
dKi = I/H0_1^2*dH0_1;
%% Task 12
% Calcolo il rapporto fra i comportamenti asintotici
delete T cm Tref
load('task_12_pid_control.mat');
% Rapporto sperimentale prima reference temperature
Tas1 = mean(T(327:483)) - Troom;
dTas1 = sqrt(std(T(327:483))^2+dTroom^2);
Tref1 = Tref(327) - Troom;
dTref1 = dTroom;
Rapp1 = Tas1/Tref1;
dRapp1 = sqrt((dTas1/Tref1)^2 + ((Tas1/Tref1^2)*dTref1)^2);
% Rapporto sperimentale seconda reference temperature
Tas2 = mean(T(1183:1500)) - Troom;
dTas2 = sqrt(std(T(1183:1500))^2+dTroom^2);
Tref2 = Tref(1400) - Troom;
dTref2 = dTroom;
Rapp2 = Tas2/Tref2;
dRapp2 = sqrt((dTas2/Tref2)^2 + ((Tas2/Tref2^2)*dTref2)^2);
% Rapporto teorico
RapTeo = Kp/(H0_1^(-1) + Kp);
dRapTeo = sqrt((H0_1/(1+Kp*H0_1)^2*dKp)^2+(Kp/(1+Kp*H0_1)^2*dH0_1)^2);
% Residui per compatibilitÓ
Res1 = abs(Rapp1 - RapTeo);
dRes1 = sqrt(dRapp1^2+dRapTeo^2);
Res2 = abs(Rapp2 - RapTeo);
dRes2 = sqrt(dRapp2^2+dRapTeo^2);