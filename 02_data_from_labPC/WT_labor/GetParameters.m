r_tank = 0.045;
b = 1 / (1000 * (pi * r_tank^2));
kp = 0.0167;
u0 = 0.25;

u_pump = [3.5, 4.5];
h1 = [0.088, 0.134];
h2 = [0.080, 0.130];
v_sens1 = [2.82, 3.18];
v_sens2 = [2.80, 3.17];

p_sens1 = polyfit(h1, v_sens1, 1);
p_sens2 = polyfit(h2, v_sens2, 1);

K_s1 = p_sens1(1);
Offset_S1 = p_sens1(2);

K_s2 = p_sens2(1);
Offset_S2 = p_sens2(2);

a1_vec = (b * kp * (u_pump - u0)) ./ sqrt(h1);
a2_vec = a1_vec .* (sqrt(h1) ./ sqrt(h2));

a1 = mean(a1_vec)
a2 = mean(a2_vec)
ratio_a1_a2 = a1 / a2;