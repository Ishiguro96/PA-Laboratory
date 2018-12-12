clear variables;
close all;
clc;

run('ModelDataNonlinear.m'); % Informacje o obiekcie nieliniowym
run('ModelData.m'); % Informacje o obiekcie zlinearyzowanym

s = tf('s');
K = k/((1+s*T1)*(1+s*T2)*(1+s*T3));

deltah20max = 0.1*h20;

% Parametry przekaznika
a = 0.01;
B = deltah20max / k;

% ZADANIE 1 TRYB
% 1 - deltaw
% 2 - parametr a
zad1_tryb = 1;

%{
Nastawy z laboratorium 4 - PID
kr = 0.1075
Ti = 24.2748
Td = 4.2481

1) T1prim + T2prim = Ti
2) T1prim*T2prim / (T1prim + T2prim) = Td
%}

% Obliczanie parametrow Kprim, T1prim i T2prim
Ti = 24.2748;
Td = 4.2481;
kr = 0.1075;

syms x1;
syms x2;
eqns = [x1 + x2, x1*x2/(x1+x2)] == [Ti, Td];
[y1, y2] = solve(eqns, [x1, x2]);

T1prim = double(y2(1));
T2prim = double(y2(2));

eqns = (T1prim + T2prim)/(x1 * (T2prim - T1prim)) == kr;
y = solve(eqns, x1);
kprim = double(y);

% Regulator PID
    Tf = 0.05 * Td; %Stała czasowa inercji
    Kr = kr * (1 + 1/(Ti*s) + (Td*s)/(Tf*s+1));%Transmitancja regulatora
    
    K0 = K * Kr;
    GPID2 = K0/(1+K0); %Transmitancja układu zamkniętego (w --> y)
    


% Badanie wplywu deltyw na odpowiedz
if(zad1_tryb == 1)
    figure;
    %for i = 0:1:3
    i = 2;
        switch i
            case 0
                deltaw = deltah20max / 3;
            case 1
                deltaw = 2 * deltah20max / 3;
            case 2
                deltaw = deltah20max / 2;
            case 3
                deltaw = 3 * deltah20max / 2;
        end
        sim('Lab8_model.slx');
        hold on;
        plot(w2);
        plot(y2);
        title('Porownanie wymuszenia', 'FontSize', 24);
        legend({'w(t)', 'y(t)', 'w2(t)', 'y2(t)', 'w3(t)', 'y3(t)', 'w4(t)', 'y4(t)'}, 'FontSize', 16);
        xlabel('Czas [s]', 'FontSize', 16);
        ylabel('Odpowiedz(t)', 'FontSize', 16);
        hold off;
    %end
end

% Badanie wplywu parametru a na odpowiedz
if(zad1_tryb == 2)
    figure;
    deltaw = deltah20max / 2;
    for i = 0:1:2
        switch i
            case 0
                a = 0;
            case 1
                a = 0.001;
            case 2
                a = 0.1;
            case 3
                a = 10;
        end
        p_a(i+1) = a;
        sim('Lab8_model.slx');
        hold on;
        plot(w2);
        plot(y2);
        hold off;
    end
    title('Porownanie a', 'FontSize', 24);
    %legend({'w(t)', 'y(t)', 'w2(t)', 'y2(t)', 'w3(t)', 'y3(t)', 'w4(t)', 'y4(t)'}, 'FontSize', 16);
    legend({'y(t)', 'y2(t)', 'y3(t)', 'y4(t)'}, 'FontSize', 16);
    xlabel('Czas [s]', 'FontSize', 16);
    ylabel('Odpowiedz(t)', 'FontSize', 16);
end

% Zadanie 2

deltaw = deltah20max / 3;

kprim
T1prim
T2prim

T1prim*T2prim/(T1prim + T2prim)
T1prim + T2prim
(T1prim + T2prim)/(kprim*(T2prim - T1prim))

sim('Lab8_model.slx');
figure;
hold on;
plot(w2);
plot(w_pid);
plot(y2);
plot(pid);
%plot(e2);
%plot(e_pid);
title('Przypadek', 'FontSize', 24);
legend({'w(t)', 'w pid(t)', 'y(t)', 'y pid(t)'}, 'FontSize', 16);
xlabel('Czas [s]', 'FontSize', 16);
ylabel('Odpowiedz(t)', 'FontSize', 16);
hold off;

%[N, ~] = size(e2);
%usr = ( (T1prim + T2prim) / (kprim*(T2prim - T1prim)) ) * ( e2(1:N-1) + (1/(T1prim + T2prim)) * cumtrapz(e2(1:N-1)) + ((T1prim*T2prim)/(T1prim + T2prim)) * diff(e2(1:N)) );

% size(e2(1:N))
% size(1/(T1prim + T2prim)*cumtrapz(e2(1:N-1)))
% size((T1prim*T2prim)/(T1prim + T2prim)*diff(e2(1:N)))
