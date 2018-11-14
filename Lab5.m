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

REGULATOR = 'PD';
switch REGULATOR
    case 'PI'
        % EDIT HERE
        Tc = T3;
        % END EDIT

        Kr = minreal(kr_gwiazdka * (1 + s*Tc) / s);
    case 'PD'
        % EDIT HERE
        beta = 0.01;
        Tb = beta * T3;
        Ta = T1;
        % END EDIT
        
        Kr = minreal(kr_gwiazdka * (1 + s*Ta) / (1 + s*Tb));
    case 'PID'
        % EDIT HERE
        beta = 0.1;
        Tb = beta * T3;
        Ta = T1;
        Tc = T2;
        % END EDIT
        
        Kr = minreal(kr_gwiazdka * ((1 + s*Ta) * (1 + s*Tc)) / (s*(1 + s*Tb)));
end
        
K0 = Kr * K;
figure;
rlocus(K0);

% EDIT HERE
kr_gwiazdka = 0.0629; %ODCZYT Z WYKRESU
% END EDIT

switch REGULATOR
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

figure;
step(G, Ge, Gw, 0:0.01:100);

fprintf("----- REGULATOR %s -----\n", REGULATOR);
fprintf("Theta: %0.3f, Zapas amplitudy: %0.3f, Zapas fazy: %0.3f\n",theta, DA, DF);