% Parametry obiektu nieliniowego używane w innych ćwiczeniach %

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

%ODCHYLKA
w0 = q10;
deltaw = 0.1*w0;