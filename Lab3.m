clear all;
close all;
clc;

run('Lab2.m');

s = tf('s'); %Tworzenie zmiennej s

K = k/((1+s*T1)*(1+s*T2)) %Utworzenie transmitancji K(s)

T3 = 0.5*T1;
Kw = 1/(s*T3 + 1)
Kr = 0.14; %DLA WSK. NADAZANIA
%Kr = 0.2416; %DLA ZAPASU FAZY

K0 = K*Kw*Kr;

G = K0/(1+K0) %Transmitancja układu zamkniętego (w --> y)
Ge = 1/(1+K0) %Transmitancja uchybowa (w --> e)

deltaw = 0;

%ZE WSKAZNIKA NADAZANIA (kr = 0.14 --> 1.1)
M = G; %wskaźnik nadążania
bodemag(M);

[DA, DF, DA_omega, DF_omega] = margin(K0); %Zapasy fazy i amplitudy

%figure;
%h = nyquistplot(K0); %Char. Nyquista z uchwytem
%setoptions(h, 'MagUnits', 'abs', 'ShowFullContour', 'off'); %Wyłączenie ujemnych częstotliwości

%Z ZAPASU FAZY (kr = 0.28 --> 30.2 deg)
%Z ZAPASU AMPLITUDY (kr = 0.331 --> 2.0023)

figure;
step(G, 'k', Ge, 'b', 0:0.01:250);

%figure;
%plot(tout, nlin);

%figure;
[p,z] = pzmap(G);

plot(tout, nlin);
figure;
plot(tout, uchyb_nlin);
stepinfo(nlin, tout)