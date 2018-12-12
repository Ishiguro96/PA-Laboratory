% ----------------------- %
% - PODSTAWY AUTOMATYKI - %
% -    LABORATORIUM 9   - %
% -  REGULATOR KROKOWY  - %
% -                     - %
% - AUTOR: DAWID TOBOR  - %
% ----------------------- %

% Jest problem dla ludzi z wersja matlaba < 2015b, bo nie ma tam wtedy funkcji string(). Rozwiazanie to po prostu zakomentowanie wszystkiego, co zwiazane z legenda w zadaniu 1.

%% Zadanie 1 - Badanie wplywu parametrow regulatora krokowego

clear variables;
close all;
clc;

CZAS_KONCA_SYMULACJI = 25;

legend_str = zeros(1, 4);

for i = 1:6 % Ilosc badanych parametrow
    figure;
    for k = 1:4 % Ilosc porownan
        
        % Parametry bazowe
            a = 0.01;
            delta = 0.005;
            B = 0.4;
            Ts = 10;
            ks = 10;
            Tm = 5;
        
        switch(i)
            case 1 % Porownanie parametru a
                switch(k)
                    case 2
                        a = 0.001;
                    case 3
                        a = 0.3;
                    case 4
                        a = 0.7;
                end
                legend_str(k) = a;
                
            case 2 % Porownanie parametru delta
                switch(k)
                    case 2
                        delta = 0.0005;
                    case 3
                        delta = 0.05;
                    case 4
                        delta = 0.5;
                end
                legend_str(k) = delta;
                
            case 3 % Porownanie parametru B
                switch(k)
                    case 2
                        B = 0.1;
                    case 3
                        B = 1;
                    case 4
                        B = 10;
                end
                legend_str(k) = B;
                
            case 4 % Porownanie parametrow Ts
                switch(k)
                    case 2
                        Ts = 30;
                    case 3
                        Ts = 10;
                    case 4
                        Ts = 2;
                end
                legend_str(k) = Ts;
                
            case 5 % Porownanie parametru ks
                switch(k)
                    case 2
                        ks = 15;
                    case 3
                        ks = 4;
                    case 4
                        ks = 0.2;
                end
                legend_str(k) = ks;
                
            case 6 % Porownanie parametru Tm
                switch(k)
                    case 2
                        Tm = 10;
                    case 3
                        Tm = 30;
                    case 4
                        Tm = 1;
                end
                legend_str(k) = Tm;
        end
     
        sim('Lab9_zadanie1.slx', CZAS_KONCA_SYMULACJI);
        hold on;
        plot(u);
    end
    
    hold off;
    legend_str = string(legend_str); % Konwersja tablicy intow na stringi
    
    switch(i)
        case 1
            title('Porownanie parametru a', 'FontSize', 24);
            legend_str = 'a = ' + legend_str;
        case 2
            title('Porownanie parametru Δ', 'FontSize', 24);
            legend_str = 'Δ = ' + legend_str;
        case 3
            title('Porownanie parametru B', 'FontSize', 24);
            legend_str = 'B = ' + legend_str;
        case 4
            title('Porownanie parametru Ts', 'FontSize', 24);
            legend_str = 'Ts = ' + legend_str;
        case 5
            title('Porownanie parametru ks', 'FontSize', 24);
            legend_str = 'ks = ' + legend_str;
        case 6
            title('Porownanie parametru Tm', 'FontSize', 24);
            legend_str = 'Tm = ' + legend_str;
    end
    
    legend(legend_str, 'FontSize', 18);
    xlabel('Czas [s]', 'FontSize', 16);
    ylabel('Przeiegi czasowe', 'FontSize', 16);
end

%% Zadanie 2 - Badanie regulatora krokowego w ukladzie zamknietym

clear variables;
close all;
clc;

run('ModelData.m');

s = tf('s');
K = k/((1+s*T1)*(1+s*T2)*(1+s*T3));

CZAS_KONCA_SYMULACJI = 250;

% Parametry regulatora krokowego
    a = 0.01;
    delta = 0.005;
    B = 0.4;
    ks = 10;

% Regulator PI z cwiczen 4
    kr = 0.0679;
    Ti = 17.823;

    Kr = kr * (1 + 1/(Ti * s));
    K0 = Kr * K;

% Obliczanie nastaw regulatora krokowego
Ts = Ti;
Tm = Ts/(kr*ks);

sim('Lab9_zadanie2.slx', CZAS_KONCA_SYMULACJI);

figure;
hold on;
plot(u);
plot(u_pi);
hold off;

figure;
hold on;
plot(y);
plot(y_pi);
hold off

%% Zadanie 3 - badanie wplywu szybkosci zmian na jakosc sledzenia

clear variables;
close all;
clc;

run('ModelData.m');

s = tf('s');
K = k/((1+s*T1)*(1+s*T2)*(1+s*T3));

CZAS_KONCA_SYMULACJI = 100;

% Parametry regulatora krokowego
    a = 0.01;
    delta = 0.005;
    B = 0.4;
    ks = 10;

% Regulator PI z cwiczen 4
    kr = 0.0679;
    Ti = 17.823;

    Kr = kr * (1 + 1/(Ti * s));
    K0 = Kr * K;

% Obliczanie nastaw regulatora krokowego
Ts = Ti;
Tm = Ts/(kr*ks);

sim('Lab9_zadanie3.slx', CZAS_KONCA_SYMULACJI);

figure;
hold on;
plot(u);
plot(u_pi);
hold off;

figure;
hold on;
plot(y);
plot(y_pi);
hold off
