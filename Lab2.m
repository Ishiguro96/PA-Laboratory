clear all;
close all;
clc;

% -------------------------------------------------------------------------
% - PLIK ZAWIERAJĄCY OPIS MATEMATYCZNY ZLINEARYZOWANEGO UKLADU,           -
% - UŻYWANEGO W INNYCH ZADANIACH LABORATORYJNYCH                          -
% -------------------------------------------------------------------------

%DEFINICJE STALYCH
C1 = 1.372;
C2 = 0.332756;
R1 = 1.8712;
R2 = 0.907668;
H2 = 16;
H1 = 2;

A = pi*R1*R1;
B = (pi*R2*R2)/(3*H2*H2);

h2max = 16;
q1max = 1.4;

%PUNKT PRACY
h20 = h2max/2;
q10 = C2*sqrt(h20);
h10 = (q10/C1).^2;

%PARAMETRY TRANSMITANCJI UCHYBOWEJ
k = (2*sqrt(h20))/C2;
T1 = 2*pi*R1*R1*sqrt(h10)/C1;
T2 = 2*A*sqrt(h10)/C1;

%ODCHYLKA
deltaq1 = 0.1*q10;
deltaw = deltaq1;

%CHARAKTERYSTYKA STATYCZNA
fq1 = 0:0.01:q1max;
h2 = (fq1/C2).^2; %f. charakterystyki

% %CHARAKTERYSTYKA STATYCZNA UKLADU ZLINEARYZOWANEGO
% h2_l = 2*sqrt(h20)/C2 * (fq1-q10) + h20;
% figure;
% plot(fq1, h2, 'b');
% hold on;
% plot(fq1, h2_l, '--r');
% hold on;
% scatter(q10, h20, 200, 'b*');
% ax = gca;
% ax.FontSize = 16;
% xlabel('q1');
% ylabel('h2');
% xlim([0 q1max]);
% ylim([0 h2max]);
% title('Charakterystyka statyczna układu zlinearyzowanego');
% 
% %POROWNANIE ODPOWIEDZI UKLADU NIELINIWEGO I ZLINEARYZOWANEGO
% sim('Porownanie');
% figure;
% plot(tout, porownanie_h2, 'b');
% hold on;
% plot(tout, porownanie_deltah2, 'r');
% hold on;
% ax = gca;
% ax.FontSize = 16;
% xlabel('t');
% ylabel('y(t)');
% title('Porównanie odpowiedzi układu nieliniowego i zlinearyzowanego');
