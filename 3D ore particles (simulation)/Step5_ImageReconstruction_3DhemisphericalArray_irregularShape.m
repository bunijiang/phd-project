% Step 5: Implement the confocal microwave imaging algorithm to post-process backscattered microwave signals and reconstruct image.
% A hemispherical antenna array were applied to illuminate the ore particle model.


M = 12; % Totally 72 antenna positions in the hemispherical antenna array.
H = 6;
deltaT = 0.0001333*10^-9;
t_start = 5.42*10^-10; % time zero
sphere_r = 0.075; % radius of the hemispherical array
delta_theta = 360/M; % theta is the azimuthal angle
delta_phi = 90/H; % phi is the polar angle
start_theta = 180;
start_phi = 0;
c = 3*10^8;
epsilon_r = epsilon_r_avg;

calibration = S1goldhemisphericalnew3_voltage-S1onlyantennahemisphericalnew_voltage; % Subtracting returns without the ore particle present
integration = cumtrapz(standard_time,calibration);

% Set coordinates of all antenna positions in Rm.
Rm = []; 
theta_range = start_theta:delta_theta:(start_theta+359);
phi_range = start_phi:delta_phi:89;
for y = phi_range
    for x = theta_range
        Rm(end+1,:) = [sphere_r*cosd(x)*cosd(y), sphere_r*sind(x)*cosd(y), sphere_r*sind(y)];
    end
end

% D_out stores the distance between each antenna and each edge point for later use
D_out = [];
for m = 1:(M*H)
    S_k = Rm(m,:);
    d_out = vecnorm(S_k - verts, 2, 2);
    D_out = [D_out;d_out];
end

% For image reconstruction, first, the propagation path distance between the antenna and each focal point is computed and converted to a time delay, which is used to identify the contribution from each post-processed waveform.
% For irregularly shaped ore particle models, we need to know the location of a particle’s edge in advance to know the proportion of air on a specific propagation path,
% thereby considering the propogation velocity in air into the calculation of time delay. Additionally, only the area inside the ore particle would be imaged.
% The contributions obtained from all antenna locations are summed,
% and then this sum is squared to acquire the voxel value at the synthetic focal point.
n = width/gap;
h = height/gap;
n_verts = size(verts,1);
result = zeros(n+1, n+1, h+1); % result is the voxel intensity values
p_bar = waitbar(0, 'Starting');
for i = 0:n
    for j = 0:n
        for r = 0:h
            rm = [ (i-n/2) * gap, (j-n/2) * gap, r*gap]; % rm is focal points. Each synthetic focal point corresponds to a voxel.

            if isnan(tn(i*(n+1)*(h+1)+j*(h+1)+r+1))  % Skip if the current point is not inside the ore particle
                continue
            end
            d_in = vecnorm(verts - rm, 2, 2);
            total = 0;
            for m = 1:(M*H)
                d_out = D_out(((m-1)*n_verts+1):m*n_verts,:);
                [~,idx] = min(d_out + sqrt(epsilon_r) * d_in);
                tau = int32((2*d_out(idx)/c + 2*d_in(idx)/v_gangue + t_start)/deltaT); % time delay
                if tau < size(integration,1)
                    total = total + integration(tau, m);
                end
            end
            result(j+1,i+1,r+1) = total^2;
        end
        waitbar(i/(n+1), p_bar, sprintf('Progress: i:%d j:%d r:%d %d %%', i, j, r, floor(i/(n+1)*100)));
    end
end
close(p_bar);