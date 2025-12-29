%% Advanced Control Engineering II: Water Tank Laboratory
% Full Linearization and Control Design Script
clear; clc; close all;

%% 1. SYSTEM PARAMETERS [cite: 27]
% Physical constants
At    = 50 * 1e-4;   % Area of tank [m^2] (50 cm^2)
Aout  = 25 * 1e-6;   % Area of outlet [m^2] (25 mm^2)
zeta  = 0.05;        % Pressure loss coefficient
rho   = 1000;        % Density of Water [kg/m^3]
g     = 9.81;        % Gravity [m/s^2]

% Calculated System Coefficients (a1 and a2)
% Note: You can adjust these if the tanks are physically different.
% Standard theoretical value based on manual[cite: 41]:
a_theoretical = (Aout / At) * sqrt(2 * g / (1 + zeta));

a1 = 0.0574;  % Coefficient for Tank 1 (Example value)
a2 = 0.0524;  % Coefficient for Tank 2 (Example value)

%% 2. OPERATING POINT SELECTION [cite: 88]
% We linearize around a desired height for Tank 2.
h2_bar = 0.05;  % Target height for Tank 2 [m] (5 cm)

% Calculate steady-state height for Tank 1
% Condition: Flow out of T1 = Flow out of T2 -> a1*sqrt(h1) = a2*sqrt(h2)
h1_bar = ( (a2 * sqrt(h2_bar)) / a1 )^2;

% Calculate steady-state Input Flow (u_bar)
% Condition: Flow in = Flow out of T1
u_bar = rho * At * a1 * sqrt(h1_bar);

fprintf('--------------------------------------------------\n');
fprintf('OPERATING POINT \n');
fprintf('--------------------------------------------------\n');
fprintf('Target Height h2: %.4f m (%.1f cm)\n', h2_bar, h2_bar*100);
fprintf('Required Height h1: %.4f m (%.1f cm)\n', h1_bar, h1_bar*100);
fprintf('Required Input Flow: %.6f kg/s\n', u_bar);
fprintf('--------------------------------------------------\n\n');

%% 3. LINEARIZATION [cite: 39, 40]
% State Space: dx/dt = Ax + Bu
% x = [h1; h2], u = m_dot_in

% Jacobian terms evaluated at the operating point
term1 = a1 / (2 * sqrt(h1_bar));
term2 = a2 / (2 * sqrt(h2_bar));

% Matrix A (System Matrix)
A = [-term1,       0;
      term1,  -term2];

% Matrix B (Input Matrix)
B = [1 / (rho * At);
     0];

% Matrix C (Output Matrix) -> We measure h2
C = [0, 1];

% Matrix D (Feedthrough)
D = 0;

% Create State-Space Object
sys_lin = ss(A, B, C, D);
sys_lin.InputName = {'u_flow'};
sys_lin.OutputName = {'h2'};
sys_lin.StateName = {'h1', 'h2'};

disp('Linearized State-Space Model (sys_lin):');
sys_lin

%% 4. PUMP MODEL (Voltage Conversion) [cite: 48, 49]
% The PID controller calculates mass flow (kg/s), but the pump needs Voltage.
% We need the slope K_pump from Fig 2 in the manual.
% Approx points from graph: (1V, 500ml/min) to (5V, 4800ml/min)
flow_min = 500;   % ml/min
flow_max = 4800;  % ml/min
volt_min = 1;     % V
volt_max = 5;     % V

slope_ml_min = (flow_max - flow_min) / (volt_max - volt_min); % ml/min/V
% Convert to kg/s/V: (ml/min * 1g/1ml * 1kg/1000g * 1min/60s)
K_pump = slope_ml_min * (1/1000) * (1/60); 

fprintf('Pump Characteristic:\n');
fprintf('Estimated K_pump: %.5f kg/s per Volt\n\n', K_pump);

%% 5. PID CONTROLLER DESIGN [cite: 90]
% Tuned for fast response with minimal overshoot (~0%)
% These gains assume the input is MASS FLOW (kg/s)
Kp_flow = 0.775;
Ki_flow = 0.054;
Kd_flow = 0;      % Derivative often 0 for noisy level control

% Convert gains for VOLTAGE control
% K_volts = K_flow / K_pump
Kp_volt = Kp_flow / K_pump;
Ki_volt = Ki_flow / K_pump;
Kd_volt = Kd_flow / K_pump;

fprintf('PID GAINS (for Mass Flow model):\n');
fprintf('Kp: %.4f\nKi: %.4f\nKd: %.4f\n\n', Kp_flow, Ki_flow, Kd_flow);

fprintf('PID GAINS (for Hardware/Voltage input):\n');
fprintf('Kp: %.4f\nKi: %.4f\nKd: %.4f\n', Kp_volt, Ki_volt, Kd_volt);
fprintf('(Use these values in Simulink if your output goes to the Pump)\n\n');

%% 6. SIMULATION CHECK
% Create a PID object (Flow domain)
Controller = pid(Kp_flow, Ki_flow, Kd_flow);

% Closed Loop System T = (L) / (1 + L)
sys_cl = feedback(Controller * sys_lin, 1);

% Step Response Plot
figure;
step(sys_cl);
title('Closed-Loop Step Response (Linearized Model)');
ylabel('Height h2 [m]');
xlabel('Time [s]');
grid on;

%% 7. OPEN TUNER (Optional)
% Uncomment the line below to open the PID Tuner app manually
pidTuner(sys_lin, 'PID');