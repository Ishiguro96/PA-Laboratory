% ----------------------------------- %
% -         PA LABORATORIUM 7       - %
% - ZAKLOCENIA W UKLADZIE REGULACJI - %
% -                                 - %
% - AUTOR: Dawid Tobor              - %
% ----------------------------------- %

% Specjalnie dla Gronusia LAB7DT %

clear all;
close all;
clc;

% Pobranie informacji o sterowanym obiekcie
run('ModelData.m');

% Tworzenie transmitancji obiektu sterowanego K(s)
s = tf('s');
K = k/((1+s*T1)*(1+s*T2)*(1+s*T3)); %t0 = 71.2 [s]
stepinfo(K)

%{
  Odczytujemy SETTLING TIME ze STEPINFO(K) i wpisujemy to do t0.
  Nastepnie ustawiamy wartosci zmiennych (mi, omega, ksi), aby spelnic
  warunki zadania. Czas SETTLING TIME (tr) ze STEPINFO(Gm) ma byc 2 RAZY MNIEJSZY
  od czasu t0;
%}
% EDIT HERE %
t0 = 71.2;

mi = 5; % Czym wieksze, tym wolniejszy uklad
omega = 0.54; % Czym mniejsze, tym wolniejszy uklad
ksi = 2; % Jesli osc., to ksi < 1, jesli aper. to ksi > 1
% END EDIT %

Gm = (1 / (1 + mi*s)) * ((omega^2) / (s^2 + 2*ksi*omega*s + omega^2));
Kff = Gm / K;

stepinfo(Gm)
step(Gm);

% PUNKT 1 %
figure;
sim('Lab7_pkt1.slx', 200);
e = 1 - y_1;
plot(tout, y_1, tout, u_1, tout, e);

% PUNKT 2 %
figure;
Kr = (1 / K) * (Gm / (1 - Gm));
sim('Lab7_pkt2.slx', 250);
plot(tout, y_2, tout, u_2, tout, e_2);

% PUNKT 3 %
figure;

%{
    Zmieniamy BETE w zaleznosci od podanych danych na labkach. Zmieniamy
    kr, aby osiagnac zadany zapas amplitudy/fazy.
%}

% EDIT HERE %
kr = 0.02;
beta = 0.2;
% END EDIT %

% SPOSOB A
Kr3 = kr * ((s*T1 + 1) * (s*T2 + 1) * (s*T3 + 1)) / ((beta*s + 1)^3);
% SPOSOB B
Kr3 = kr * ((s*T1 + 1) * (s*T2 + 1) * (s*T3 + 1)) / (s*((beta*s + 1)^2));

K0 = ((Kff) + (Gm * Kr3)) * K;
[DA, DF, ~, ~] = margin(K0);

sim('Lab7_pkt3.slx', 250);
plot(tout, y_3, tout, u_3, tout, e_3);
