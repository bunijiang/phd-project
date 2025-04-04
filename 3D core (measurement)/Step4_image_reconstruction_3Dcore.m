% Step 4: In the image reconstruction step, the waveforms post-processed by the above steps should be synthetically focused at a specific point in the core sample.

M = 12; % M antenna positions in a circle
H = 5; % H layers in the axial direction 
deltaT = (time_points(2)-time_points(1))*10^-9; % time gap in nanosecond
radius = 0.025; % core radius. It is also the radius of the cylindrical antenna array, since the antenna is set very close to the core surface.
height = 0.05; % core height
height_base = 0.005; % The height of the first layer of the antenna array.
height_gap = 0.01; % The gap between antenna array layers
voxel = 0.001; % voxel size
rotation_degree = 360/M;
start_degree = 180;

Rm = zeros(M*H, 3); 
% Set coordinates of all antenna positions in Rm.
for i = 1:H
    degree_range = start_degree:rotation_degree:(start_degree+359+(i-1)*level_diff)
    circle = cat(1,radius.*cosd(degree_range), radius.*sind(degree_range)).';
    Rm(M*(i-1)+1:M*i,1:2) = circle;
    Rm(M*(i-1)+1:M*i,3) = (i-1)*height_gap + height_base;
end

% For image reconstruction, first, the propagation path distance between the antenna and each focal point is computed and converted to a time delay, which is used to identify the contribution from each post-processed waveform.
% The contributions obtained from all antenna locations are summed,
% and then this sum is squared to acquire the voxel value at the synthetic focal point.
n = radius*2/voxel;
h = height/voxel;
result = zeros(n+1, n+1, h+1); % result is the voxel intensity values
for i = 0:n
    for j = 0:n
        rm = [ (i-n/2) * voxel, (j-n/2) * voxel, 0 ]; % rm is focal points. Each synthetic focal point corresponds to a voxel.
        distanceToOrigin = sqrt(rm * rm.');
        if distanceToOrigin >= radius % Skip if the current point is not inside the core sample
            continue
        end
        for r = 0:h
            rm(3) = r*voxel;
            tau = int32((2*sqrt(sum(((rm - Rm).^2),2))/v + t_start)/deltaT); % time delay
            total = 0;
            for m = 1:(M*H)
                if tau(m) < size(compensation,1)
                    total = total + compensation(tau(m), m);
                end
            end
            result(j+1, i+1, r+1) = total^2;
        end
    end
end