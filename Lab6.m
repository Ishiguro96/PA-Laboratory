% -------------------------------- %
% -      PA LABORATORIUM 6       - %
% - REGULACJA DYSKRETNA W CZASIE - %
% -                              - %
% - AUTOR: Dawid Tobor           - %
% -------------------------------- %

clear all;
close all;
clc;

% Pobranie informacji o sterowanym obiekcie
run('ModelData.m');

% Tworzenie transmitancji obiektu sterowanego K(s)
s = tf('s');
K = k/((1+s*T1)*(1+s*T2)*(1+s*T3));

Tkoniec = 250;

% EDIT HERE
% Trzeba ustawić kk, aby DA było równe 2
kk = 0.264;
% END EDIT

% Obliczanie DA
Kr = kk;
K0 = Kr * K;
[DA, DF, ~, ~] = margin(K0);

% Rysowanie charakterystyki amplitudowo-fazowej
figure;
handle = nyquistplot(K0);
setoptions(handle, 'MagUnits', 'abs', 'ShowFullContour', 'off');

sim('Lab6_ciagly.slx', Tkoniec);

% REGULACJA DYSKRETNA

% EDIT HERE
h1 = 0.1 * Tmax;
h2 = 0.5 * Tmax;
% END EDIT

% REGULATOR DYKRETNY
h = h1;
sim('Lab6_dyskretny.slx', Tkoniec);

y_dysk_1 = y_dysk;
u_dysk_1 = u_dysk;
e_dysk_1 = e_dysk;
tout_dysk_1 = tout_dysk;

h = h2;
sim('Lab6_dyskretny.slx', Tkoniec);

% APROKSYMACJA CIĄGŁA

L1=(1-s*h1/2)*K;
L2=(1-s*h2/2)*K;

% EDIT HERE
% Trzeba ustawić kL1 i kL2, aby DA_d1 i DA_d2 były równe 2
kL1 = 0.22;
kL2 = 0.132;
% END EDIT

K0_d1 = kL1 * L1;
K0_d2 = kL2 * L2;
[DA_d1, DF_d1, ~, ~] = margin(K0_d1);
[DA_d2, DF_d2, ~, ~] = margin(K0_d2);

kL = kL1;
L = L1;
sim('Lab6_aproks.slx', Tkoniec);

y_aproks_1 = y_aproks;
u_aproks_1 = u_aproks;
e_aproks_1 = e_aproks;
tout_aproks_1 = tout_aproks;

kL = kL2;
L = L2;
sim('Lab6_aproks.slx', Tkoniec);

% WYŚWIETLANIE WYKRESÓW
plot(tout, y_ciagly, tout_aproks_1, y_aproks_1, tout_aproks, y_aproks);

% OPCJONALNE, JEŚLI BĘDZIE WYMAGANE
%{
hold on;
stem(tout_dysk_1, y_dysk_1, 'LineStyle', 'none');
stem(tout_dysk, y_dysk, 'LineStyle', 'none');
hold off;
%}





% PUNKT 2
h = h1;
z = tf('z', h);

L_pid = exp(-s*h/2) * K;
step(L_pid, 0:0.01:100);

% EDIT HERE - 28.3% -> 63.2%
t1 = 30.2;
t2 = 17.1;
% END EDIT

T = 1.5*(t1 - t2);
T0 = t1 - T;

kr_pid = 0.95*T/(k*T0);
Ti_pid = 2.4*T0;
Td_pid = 0.42*T0;
Tf_pid = 0.05 * Td_pid; %Stała czasowa inercji

Kr_pid_1 = kr_pid * (1 + 1/(Ti_pid*s) + (Td_pid*s));
Kr_pid_2 = kr_pid * (1 + 1/(Ti_pid*s) + (Td_pid*s)/(Tf_pid*s+1));

Hr1 = c2d(Kr_pid_1, h, 'Tustin');
Hr2 = c2d(Kr_pid_2, h, 'Tustin');
Hr3 = kr_pid * (1 + (h/Ti_pid) * (z/(z-1)) + (Td_pid / h) * ((z-1)/z));

Hr = Hr1;
sim('Lab6_dysk_PID.slx', Tkoniec);
tout_PID_1 = tout_PID;
y_PID_1 = y_PID;
ui_PID_1 = ui_PID;
u_PID_1 = u_PID;

Hr = Hr2;
sim('Lab6_dysk_PID.slx', Tkoniec);
tout_PID_2 = tout_PID;
y_PID_2 = y_PID;
ui_PID_2 = ui_PID;
u_PID_2 = u_PID;

Hr = Hr3;
sim('Lab6_dysk_PID.slx', Tkoniec);
tout_PID_3 = tout_PID;
y_PID_3 = y_PID;
ui_PID_3 = ui_PID;
u_PID_3 = u_PID;

figure;
plot(tout_PID_1, y_PID_1, tout_PID_2, y_PID_2, tout_PID_3, y_PID_3);

figure;
hold on;
plot(ui_PID_1.time, ui_PID_1.signals.values);
plot(ui_PID_2.time, ui_PID_2.signals.values);
plot(ui_PID_3.time, ui_PID_3.signals.values);
hold off;

% PUNKT 3
% REGULATOR CIĄGŁY

% EDIT HERE
t1 = 29.7;
t2 = 16.6;
% END EDIT


T = 1.5*(t1 - t2);
T0 = t1 - T;

kr_pid = 0.95*T/(k*T0);
Ti_pid = 2.4*T0;
Td_pid = 0.42*T0;
Tf_pid = 0.05 * Td_pid; %Stała czasowa inercji
Kr_pid = kr_pid * (1 + 1/(Ti_pid*s) + (Td_pid*s)/(Tf_pid*s+1)); %Transmitancja regulatora

sim('Lab6_pid_ciagly.slx', Tkoniec);

figure;
plot(tout_PID_3, y_PID_3, tout_PID_ciagly, y_PID_ciagly);

figure;
plot(ui_PID_3.time, ui_PID_3.signals.values, tout_PID_ciagly, u_PID_ciagly);


