clear

% Parameter
A_t = 50e-4;
A_out = 25e-6;
xi = 0.05;
rho = 1000;
g = 9.81;
h_max = 0.3;
U_max = 10;

K_pump = 1.55e-2;
u_max = K_pump * U_max;

a = A_out/A_t * sqrt((2*g)/(1+xi));

h2_rl = 5e-2;
h1_rl = h2_rl;
u_rl = rho*A_t*a*sqrt(h1_rl);
U_rl = u_rl/K_pump;

A = [-a/(2*sqrt(h1_rl)) 0
    a/(2*sqrt(h1_rl)) -a/(2*sqrt(h2_rl))];
b = [1/(rho*A_t); 0];
cT = [0 1];
d = 0;


%% Labor
U_rl = 3.5; %spannung
u_rl = U_rl * K_pump;
a1 = 3.744e-2;
a2 = 3.812e-2;

A = [-a1/(2*sqrt(h1_rl)) 0
    a1/(2*sqrt(h1_rl)) -a2/(2*sqrt(h2_rl))];
b = [1/(rho*A_t); 0];
cT = [0 1];
d = 0;

sys = ss(A,b,cT,d);
G = tf(sys);
pid_tune = pidtune(sys,'PID');
pid_tune_fast.Kp = pid_tune.Kp;
pid_tune_fast.Ki = pid_tune.Ki;
pid_tune_fast.Kd = pid_tune.Kd;

% Filter
s = tf('s');
tau = 5 / 5; % 10s für Überführung
lambda = 1/tau;
Gf_y = lambda^2/(s+lambda)^2;
