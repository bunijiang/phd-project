% Step 3: Postprocessing of the backscattered signals: integration and compensation.



% A matched filter is applied in the integration step to maximize signal-to-noise ratio (SNR) at the sampling points.

% Create the template waveform (P(t))
Fs = 80;
dt = 1/Fs;
N = size(Timepoints_in_Measurement, 1);
t = dt*(-(N-1)/2:(N-1)/2)';
dF = Fs/(N-1);
f = -Fs/2:dF:Fs/2;
p = [zeros([1,600]) ones([1,180]) zeros([1,40]) ones([1,180]) zeros([1,601])];
P = fftshift(ifft(p));
figure;
plot(t,real(P));
grid on;

% The matched filter employs the cross-correlation between the calibrated signal at the mth antenna position (calibration result from last step) and the template waveform (𝑃(𝜏)).
corr = zeros(N,M*H);
for i = 1:M*H
    corr(:,i) = xcorr(calibration(:,i), P(num_of_points:end));
end
plot(time_points,calibration)
integ = real(corr(num_of_points:end,:));
plot(time_points,integ)

% The compensation step is used to deal with the radial spreading loss.
start_index = ceil((t_start*(10^9) - time_points(1))/(time_points(2) - time_points(1))) + 1;
dist_from_antenna = ones(num_of_points);
dist_from_antenna(start_index:end) = (time_points(start_index:end)*(10^-9)-t_start)*v/2;
compensation= integ.*dist_from_antenna;
plot(time_points,compensation)