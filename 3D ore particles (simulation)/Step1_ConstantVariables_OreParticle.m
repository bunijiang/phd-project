% Step 1: Define some constant variables to be used in later steps.

mu0=4*pi*(10^(-7));
epsilon0=8.854*10^-12;
epsilon_r_quartz=3.8;
v_quartz=1/sqrt(epsilon_r_quartz*mu0*epsilon0)
epsilon_r_feld = 5.15;
v_feldspars = 1/sqrt(epsilon_r_feld*mu0*epsilon0)
v_S1ave = 0.5*v_feldspars + 0.5*v_quartz % Wave propagation velocity in gangue. The gangue in the ore particle model consists of approximately equal parts feldspars and quartz.
v_gangue = v_S1ave
epsilon_r_avg = 0.5*epsilon_r_feld + 0.5*epsilon_r_quartz