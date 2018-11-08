clear all;
clc; %Clear everything

s = tf('s'); %Tworzenie zmiennej s

T1 = 3;
T2 = 4;
T3 = 8;
k = 5;

K = k/((1+s*T1)*(1+s*T2)*(1+s*T3)); %Utworzenie transmitancji K(s)

zpk(K); %Postać zero-biegunowa

[zera, bieguny, wzmocnienia] = zpkdata(K, 'v'); %Zwraca zera, bieguny i wzmocnienie. Opcja 'v' oznacza, że zwraca Array, a nie Cell

[L, M] = tfdata(K, 'v'); %Zwraca postać licznika i mianownika z transmitancji

[A, B, C, D] = tf2ss(L, M); %Zwraca macierze ABCD

figure, step(K, '--r', 0:0.01:40); %Definiowanie czasu obliczania algorytmu (maksymalny czas)
hold;
impulse(K, '--c', 0:0.01:60);
grid; %Wyświetlenie siatki na wykresie

xlabel('Czas'); %Opisanie osi X
ylabel('y(t)'); %Opisanie osi Y

figure;
nyquist(K); %Char. Nyquista

figure;
h = nyquistplot(K); %Char. Nyquista z uchwytem
setoptions(h, 'MagUnits', 'abs', 'ShowFullContour', 'off'); %Wyłączenie ujemnych częstotliwości

figure;
bode(K);
h = bodeplot(K);
setoptions(h, 'MagUnits', 'abs', 'PhaseVisible', 'off');

bodemag(K);

%Linie pierwiastkowe
rlocus(K);
kr = 1.84/2; %Połowa wzmocnienia granicznego
K0 = kr*K; %Transmitancja układu otwartego

[DA, DF, DA_omega, DF_omega] = margin(K0); %Zapasy fazy i amplitudy

G = K0/(1+K0) %Transmitancja układu zamkniętego (w --> y)
Ge = 1/(1+K0) %Transmitancja uchybowa (w --> e)

minreal(G) %Postać minimalna transmitancji układu zamkniętego

figure;
step(G, 'k', Ge, 'b', 0:0.01:80); %Do sprawka setting time i rise time na wykresie!
 
M = G; %wskaźnik nadążania
bodemag(M); %wskaźnik nadążania
hold on;

q = Ge; %wskaźnik regulacji
bodemag(q); %wskaźnik regulacji
