% -------------------------------- %
% -      PA LABORATORIUM 5       - %
% - METODA LINII PIERWIASTKOWYCH - %
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

kr_gwiazdka = 1;

REGULATOR = 'PID';
switch REGULATOR
    case 'P'
        Kr = kr_gwiazdka;
    case 'PI'
        % EDIT HERE
        Tc = T3;
        % END EDIT

        Kr = minreal(kr_gwiazdka * (1 + s*Tc) / s);
    case 'PD'
        % EDIT HERE
        beta = 0.02;
        Tb = beta * T1;
        Ta = T2;
        % END EDIT
        
        Kr = minreal(kr_gwiazdka * (1 + s*Ta) / (1 + s*Tb));
    case 'PID'
        % EDIT HERE
        beta = 0.02;
        Tb = beta * T1;
        Ta = T2;
        Tc = T3;
        % END EDIT
        
        Kr = minreal(kr_gwiazdka * ((1 + s*Ta) * (1 + s*Tc)) / (s*(1 + s*Tb)));
end
        
K0 = Kr * K;
figure;
rlocus(K0);

% EDIT HERE
%kr_gwiazdka = 0.0278; %P
%kr_gwiazdka = 0.0577; %PD T1

kr_gwiazdka = 0.00524; %PID T23
%kr_gwiazdka = 0.00265; %PID T12 = T13

% END EDIT

switch REGULATOR
    case 'P'
        Kr = kr_gwiazdka;
    case 'PI'
        Kr = minreal(kr_gwiazdka * (1 + s*Tc) / s);
    case 'PD'
        Kr = minreal(kr_gwiazdka * (1 + s*Ta) / (1 + s*Tb));
    case 'PID'
        Kr = minreal(kr_gwiazdka * ((1 + s*Ta) * (1 + s*Tc)) / (s*(1 + s*Tb)));
end

K0 = Kr * K;

G = K0/(1+K0); %Transmitancja układu zamkniętego (w --> y)
Ge = 1/(1+K0); %Transmitancja uchybowa (w --> e)
Gw = Kr/(1+K0); %Transmitancja sygnału sterującego (w --> u)

[p, ~] = pzmap(G); %Stopień stabilności i oscylacyjności
theta = max((abs( imag(p) ./ real(p) )));
eta = min(abs(real(p)));

[DA, DF, ~, ~] = margin(K0);

figure;
h = nyquistplot(K0);
setoptions(h, 'MagUnits', 'abs', 'ShowFullContour', 'off');

stepinfo(G)
figure;
step(G, Ge, Gw, 0:0.01:250);


fprintf("----- REGULATOR %s -----\n", REGULATOR);
fprintf("Theta: %0.3f, Zapas amplitudy: %0.3f, Zapas fazy: %0.3f\n",theta, DA, DF);


%kr_gwiazdka = 0.0708; %PD T2,T3
%kr_gwiazdka = 0.00524; %PID T23

kr_gwiazdka = 1;

switch REGULATOR
    case 'P'
        Kr = kr_gwiazdka;
    case 'PI'
        Kr = minreal(kr_gwiazdka * (1 + s*Tc) / s);
    case 'PD'
        Kr = minreal(kr_gwiazdka * (1 + s*Ta) / (1 + s*Tb));
    case 'PID'
        Ta = 1.1*T2;
        Tc = 1.1*T3;
        Kr = minreal(kr_gwiazdka * ((1 + s*Ta) * (1 + s*Tc)) / (s*(1 + s*Tb)));
end

K0 = Kr * K;
figure;
rlocus(K0);

kr_gwiazdka = 0.00491;
Kr = minreal(kr_gwiazdka * ((1 + s*Ta) * (1 + s*Tc)) / (s*(1 + s*Tb)));
K0 = Kr * K;

G2 = K0/(1+K0); %Transmitancja układu zamkniętego (w --> y)
Ge2 = 1/(1+K0); %Transmitancja uchybowa (w --> e)
Gw2 = Kr/(1+K0); %Transmitancja sygnału sterującego (w --> u)

[p, ~] = pzmap(G2); %Stopień stabilności i oscylacyjności
theta = max((abs( imag(p) ./ real(p) )));
eta = min(abs(real(p)));

[DA, DF, ~, ~] = margin(K0);

figure;
h = nyquistplot(K0);
setoptions(h, 'MagUnits', 'abs', 'ShowFullContour', 'off');

stepinfo(G2)
figure;
step(G2, Ge2, Gw2, 0:0.01:250);


fprintf("----- REGULATOR %s -----\n", REGULATOR);
fprintf("Theta: %0.3f, Zapas amplitudy: %0.3f, Zapas fazy: %0.3f\n",theta, DA, DF);

figure;
step(G, G2, 0:0.01:200);
figure;
step(Ge, Ge2, 0:0.01:200);
figure;
step(Gw, Gw2, 0:0.01:200);
