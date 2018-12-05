clear all;
close all;
clc;

run('Lab2.m');

s = tf('s'); %Tworzenie zmiennej s

T3 = 0.5 * T1;
K = k/((1+s*T1)*(1+s*T2)*(1+s*T3)); %Utworzenie transmitancji K(s)
rlocus(K);

% Obliczanie wzmocnienia granicznego
kgr = margin(K); %Wyliczenie kgr z linii pierwiastkowych

K0gr = K * kgr; %Transmitancja układu otwartego z k granicznym
G0gr = K0gr/(1 + K0gr); %Transmitancja ukladu zamkniętego z k granicznym
step(G0gr, 0:0.01:1000);

%kgr = 0.5294;

% Czas oscylacji
Tosc = 31;

% ------------------------- %
% - PARAMETRY REGULATORÓW - %
% ------------------------- %
    % REGULATOR P
    kr = 0.5 * kgr
    Kr = kr; %Transmitancja regulatora
    
    K0 = K * Kr;
    GP = K0/(1+K0); %Transmitancja układu zamkniętego (w --> y)
    [DAP, DFP, DA_omegaP, DF_omegaP] = margin(K0);

    % REGULATOR PI
    kr = 0.45 * kgr
    Ti = Tosc/1.2
    Kr = kr*(1 + 1/(s*Ti)); %Transmitancja regulatora
    
    K0 = K * Kr;
    GPI = K0/(1+K0); %Transmitancja układu zamkniętego (w --> y)
    [DAPI, DFPI, DA_omegaPI, DF_omegaPI] = margin(K0);

    % REGULATOR PID
    kr = 0.6 * kgr
    Ti = Tosc / 2
    Td = Tosc / 8
    Tf = 0.05 * Td %Stała czasowa inercji
    Kr = kr * (1 + 1/(Ti*s) + (Td*s)/(Tf*s+1));%Transmitancja regulatora
    
    K0 = K * Kr;
    GPID = K0/(1+K0); %Transmitancja układu zamkniętego (w --> y)
    [DAPID, DFPID, DA_omegaPID, DF_omegaPID] = margin(K0);
    
    figure;
    step(GP, GPI, GPID, 0:0.01:400);
    stepinfo(minreal(GP))
    stepinfo(minreal(GPI))
    stepinfo(minreal(GPID))

% Transmitancje układu
K0 = K * Kr;
G = K0/(1+K0); %Transmitancja układu zamkniętego (w --> y)
Ge = 1/(1+K0); %Transmitancja uchybowa (w --> e)

% ------------------- %
% - Ocena regulacji - %
% ------------------- %
figure
bodemag(G); %Wskaźnik nadążania
[DA, DF, DA_omega, DF_omega] = margin(K0); %Zapas fazy i amplitudy

stepinfo(G)
step(G, 'k', Ge, 'b', 0:0.01:250); %Overshoot, czas regulacji, uchyb

[p,z] = pzmap(G); %Stopień stabilności i oscylacyjności

% --------------------------------------------- %
% - OBLICZANIE PARAMETRÓW OBIEKTU ZASTĘPCZEGO - %
% --------------------------------------------- %
K = k/((1+s*T1)*(1+s*T2)*(1+s*T3)); %Transmitancja obiektu
step(K, 0:0.01:100);

% Określenie punktów do stycznej z wykresu (Raise Time)
P1x = 16.6;
P1y = 4.81;
P2x = 29.7;
P2y = 10.8;

% Równanie prostej stycznej
x = 0:0.01:100;
a = (P1y - P2y) / (P1x - P2x);
b = (P1y - a * P1x);
y = a*x + b;

% Rysowanie stycznej
hold on;
plot(x, y, '--r');

% Metoda stycznej
t0 = (k - b)/a;
t3 = -b/a;
%T0 = t3;
%T = t0 - T0;

% Metoda punktu i stycznej
% T0 = t3;
% t1 = (0.632 * k - b)/a;
% T = t1 - T0;

% Metoda dwóch punktow
t1 = (0.632 * k - b)/a;
t2 = (0.283 * k - b)/a;
T = 1.5*(t1 - t2);
T0 = t1 - T;



% ------------ %
% - KRYTERIA - %
% ------------ %

% Kryterium QDR
    % Regulator P
    % kr = T / (k*T0);
    
    %Regulator PI
    % kr = 0.9 * T / (k*T0);
    % Ti = 3.33 * T0;
    
    %Regulator PID
    % kr = 1.2 * T / (k*T0);
    % Ti = 2 * T0;
    % Td = 0.5 * T0;
   
% Kryterium Cohena-Coona
    %alfa = T0 / T;
    % Regulator P
    % kr = T/(k*T0) * (1 + alfa/3);
    
    % Regulator PI
    % kr = T/(k*T0) * (0.9 + alfa/12);
    % Ti = T0 * (30 + 3*alfa)/(9 + 20*alfa);
    
    % Regulator PID
    % kr = T/(k*T0) * (4/3 + alfa/4);
    % Ti = T0 * (32 + 6*alfa)/(13 + 8*alfa);
    % Td = T0 * 4/(11 + 2*alfa);
    
% Kryterium Chiena, Hronesa i Reswicka (2...5% przeregulowania)
    % Regulator P
    % kr = 0.3*T/(k*T0);
    
    % Regulator PI
    % kr = 0.6*T/(k*T0);
    % Ti = 0.8*T0 + 0.5*T;
    
    % Regulator PID
    kr = 0.95*T/(k*T0)
    Ti = 2.4*T0
    Td = 0.42*T0
    Tf = 0.05 * Td %Stała czasowa inercji
    Kr = kr * (1 + 1/(Ti*s) + (Td*s)/(Tf*s+1));%Transmitancja regulatora
    
    K0 = K * Kr;
    GPID2 = K0/(1+K0); %Transmitancja układu zamkniętego (w --> y)
    [DAPID2, DFPID2, DA_omegaPID2, DF_omegaPID2] = margin(K0);
    
    figure;
    step(GPID, GPID2, 0:0.01:400);
    stepinfo(minreal(GPID2))
    
% Kryterium Chiena, Hronesa i Reswicka (20% przeregulowania)
    % Regulator P
    % kr = 0.7*T/(k*T0);
    
    % Regulator PI
    % kr = 0.7*T/(k*T0);
    % Ti = T0 + 0.3*T;
    
    % Regulator PID
    % kr = 1.2*T/(k*T0);
    % Ti = 2*T0;
    % Td = 0.42*T0;
    
% Kryterium ISE
    % Regulator PI
    % kr = T/(k*T0);
    % Ti = T0 + 0.3*T;
    
    % Regulator PID
    % kr = 1.4*T/(k*T0);
    % Ti = 1.3*T0;
    % Td = 0.5*T0;
    

    
sim('Zlinearyzowany.slx');
figure
plot(tout,sterowanie);
figure
plot(tout, nlin, tout, zlin);
figure;
plot(tout, uchyb_nlin, tout, uchyb_zlin);
stepinfo(nlin, tout)
