% Step 1: Calculate the wave propagation velocity in gangue

mu0=4*pi*(10^(-7));
epsilon0=8.854*10^-12;
epsilon_r_pyrrho = 262;
epsilon_r_feld = 5.15;
epsilon_r_quartz = 3.8;
epsilon_r_chlorite = 7.01;
epsilon_r_micas = 9.15;
epsilon_r_carbonates = 7.9;
v_pyrrhotite = 1/sqrt(epsilon_r_pyrrho*mu0*epsilon0)
v_feldspars = 1/sqrt(epsilon_r_feld*mu0*epsilon0)
v_quartz = 1/sqrt(epsilon_r_quartz*mu0*epsilon0)
v_chlorite = 1/sqrt(epsilon_r_chlorite*mu0*epsilon0)
v_micas = 1/sqrt(epsilon_r_micas*mu0*epsilon0)
v_carbonates = 1/sqrt(epsilon_r_carbonates*mu0*epsilon0)
v_AtlanticGoldOre = v_pyrrhotite*0.0092 + v_carbonates*0.0157 + v_quartz*0.346 + v_chlorite*0.1626 + v_micas*0.4501 + v_feldspars*0.0165 %use volume percentage
v_gangue = v_AtlanticGoldOre % wave propagation velocity in gangue