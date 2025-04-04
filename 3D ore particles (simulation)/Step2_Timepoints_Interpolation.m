% Step 2: In FDTD simulations, the obtained backscattered waveform does not have uniform time step.
% Thus, in this script, the time points with uniform time step (𝛥𝑡 = 0.0001333 ns) are interpolated.

standard_time = 0.001:0.0001333:3.63;
% S1goldhemisphericalnew3_voltage is the backscattered signals acquired from the microwave scattering simulation of a ore particle model.
% S1onlyantennahemisphericalnew_voltage is the backscattered signals acquired from the microwave scattering simulation with the ore particle model removed.
S1goldhemisphericalnew3_voltage = get_uniformed_voltage(S1goldhemisphericalnew3, standard_time); % Get the voltage at each time point.
S1onlyantennahemisphericalnew_voltage = get_uniformed_voltage(S1onlyantennahemisphericalnew, standard_time);
%%
function uniformed_voltage = get_uniformed_voltage(dataset, standard_time)
uniformed_voltage = zeros(size(standard_time,2), int32(size(dataset, 2)/2));
hold on
for i = 1:size(dataset, 2)/2
    x_time = dataset(~isnan(dataset(:,2*i-1)),2*i-1);
    y_voltage = dataset(~isnan(dataset(:,2*i)),2*i);
    uniformed_voltage(:,i) = interp1(x_time, y_voltage, standard_time)';
    plot(standard_time, uniformed_voltage(:,i))
end
hold off
end