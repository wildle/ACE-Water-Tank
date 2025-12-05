%% Sensor Calibration (testbench 5)
% Sensor Offset
Offset_S1 = 2.131;
Offset_S2 = 2.1475;

% Senser K value
% Konstheigt1
V_S1 = 2.82;
V_S2 = 2.8;

% Konstheigt2
V_S1_1 = 3.18;
V_S2_1 = 3.17;

%% heigth measured
% 3.5 V _ KonstHeight 1
u1_1 = 3.5;
h1_1 = 0.088;
h2_1 = 0.080;

% 5 V/4.5 _ KonstHeight 2
u1_2 = 4.5;
h1_2 = 0.134;
h2_2 = 0.130;

VSens1 = [V_S1_1, V_S1];
VSens2 = [V_S2_1, V_S2];

Height1 = [h1_2, h1_1];
Height2 = [h2_2, h2_1];

kSens1 = polyfit(Height1,VSens1,1)
kSens2 = polyfit(Height2,VSens2,1)

K_s1 = kSens1(1);
u0_1 = kSens1(2);

K_s2 = kSens2(1);
u0_2 = kSens2(2);



%% Parameter Identification
b = 1/(1000*(pi*(0.045^2)));

kp = 0.0167; %[kg/s*V] aus Anleitung
u0 = 0.25; %[V] aus Anleitung

% dh1 = - a1*sqrt(h1) + b*(u_in - u0)*Kp
%a1 = (b*(u1-u0)*kp)/sqrt(h1);
a1_1 = (b*(u1_1-u0)*kp)/sqrt(h1_1);
a1_2 = (b*(u1_2-u0)*kp)/sqrt(h1_2);

% dh2 = a1*sqrt(h1)-a2*sqrt(h2)
%a2 = a1*(sqrt(h1)/sqrt(h2));
a2_1 = a1_1*(sqrt(h1_1)/sqrt(h2_1));
a2_2 = a1_2*(sqrt(h1_2)/sqrt(h2_2));

Verh1 = a1_1/a2_1;
Verh2 = a1_2/a2_2;
