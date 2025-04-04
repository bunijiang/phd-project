% Step 2: Postprocessing of the backscattered signals: calibration.
% A cylindrical antenna array were applied in the microwave scattering measurements with 12 elements in a circle and 5 layers.

t_start = 1.27*10^-9; % time zero
M = 12; % M antenna positions in a circle
H = 5; % H layers in the axial direction 

num_of_points = floor(size(Timepoints_in_Measurement, 1) / 2) + 1
time_points = Timepoints_in_Measurement(num_of_points:end,1)*10^9; % discrete time points

% Calibration step 1: subtracting returns without the core sample present removes the incident pulse.
% waveform is the backscattered signals acquired from the microwave scattering measurements with core sample.
% waveform_blank is the backscattered signals acquired from the microwave scattering measurements with core sample removed.
waveform_diff = waveform - waveform_blank;

% Calibration step 2: Subtracting the average of the received signals of each element in the circular antenna array for every layer removes the initial surface reflection generated at the air-core interface.
waveform_diff_mean = zeros(num_of_points,M*H);
for i = 0:(H-1)
   for j = 1:M
       waveform_diff_mean(:,i*12+j) = mean(waveform_diff(:,(i*12+1):(i+1)*12),2);
   end
end
calibration = waveform_diff - waveform_diff_mean;
