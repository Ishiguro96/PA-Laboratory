clear variables;
close all;
clc;

run('ModelDataNonlinear.m'); % Informacje o obiekcie nieliniowym
run('ModelData.m'); % Informacje o obiekcie zlinearyzowanym

s = tf('s');
K = k/((1+s*T1)*(1+s*T2)*(1+s*T3));

deltah20max = 0.1*h20;

% Parametry przekaznika
a = 0.1;
B = deltah20max / k;

% ZADANIE 1 TRYB
% 1 - deltaw
% 2 - parametr a
zad1_tryb = 1;

kprim = -1.8;
T1prim = 0.7;
T2prim = 3;

% Badanie wplywu deltyw na odpowiedz
if(zad1_tryb == 1)
    for i = 0:1:3
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
        figure;
        hold on;
        plot(w3);
        plot(y3);
        title(['Przypadek ', char(65+i)], 'FontSize', 24);
        legend({'w(t)', 'y(t)'}, 'FontSize', 16);
        xlabel('Czas [s]', 'FontSize', 16);
        ylabel('Odpowiedz(t)', 'FontSize', 16);
        hold off;
    end
end

% Badanie wplywu parametru a na odpowiedz
if(zad1_tryb == 2)
    deltaw = deltah20max / 2;
    for i = 0:1:3
        switch i
            case 0
                a = 0.001;
            case 1
                a = 0.01;
            case 2
                a = 0.05;
            case 3
                a = 0.1;
        end
        sim('Lab8_model.slx');
        figure;
        hold on;
        plot(w3);
        plot(y3);
        title(['Przypadek a = ', num2str(a)], 'FontSize', 24);
        legend({'w(t)', 'y(t)'}, 'FontSize', 16);
        xlabel('Czas [s]', 'FontSize', 16);
        ylabel('Odpowiedz(t)', 'FontSize', 16);
        hold off;
    end
end

deltaw = deltah20max / 3;

sim('Lab8_model.slx');
figure;
hold on;
plot(w2);
plot(y2);
plot(u2);
title('Przypadek LULUULUL', 'FontSize', 24);
legend({'w(t)', 'y(t)', 'u(t)'}, 'FontSize', 16);
xlabel('Czas [s]', 'FontSize', 16);
ylabel('Odpowiedz(t)', 'FontSize', 16);
hold off;

[N, ~] = size(e2);
usr = ( (T1prim + T2prim) / (kprim*(T2prim - T1prim)) ) * ( e2(1:N-1) + (1/(T1prim + T2prim)) * cumtrapz(e2(1:N-1)) + ((T1prim*T2prim)/(T1prim + T2prim)) * diff(e2(1:N)) );

% size(e2(1:N))
% size(1/(T1prim + T2prim)*cumtrapz(e2(1:N-1)))
% size((T1prim*T2prim)/(T1prim + T2prim)*diff(e2(1:N)))
