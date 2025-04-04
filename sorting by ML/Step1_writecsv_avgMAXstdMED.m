% The microwave scattering measurents were performed for 15 gold ore core samples. 
% We attempt to create a sorting algorithm to make the accept/reject decision for each core sample based on its microwave image.

% Step 1: The maximum, median, average, and standard deviation of the 3D volume data (intensity values) of each core’s image are calculated.


radius = 0.025; % core radius
height = 0.05; % core height
voxel = 0.001; % voxel size
n = 2*radius/voxel;
h = height/voxel;
[XX, YY] = meshgrid(-n/2:n/2,-n/2:n/2);
mask = XX.^2 + YY.^2 < (n/2).^2;
flatten_voxels_for_all_results = [];

% results is the 3D volume data (intensity values) of 15 cores images
results = {
    realcore2712731601time_result_2_filter, 
    realcore3033111601time_result_2_filter, 
    realcore3223231601time_result_2_filter,
    realcoreplugAB1601time_result_2_filter,
    realcore2432511601time_result_2_filter,
    realcore2612621601time_result_2_filter,
    realcore2912921601time_result_2_filter,
    realcore2912921601time_result_2_filter,
    realcore2932941601time_result_2_filter,
    realcore3133241601time_result_2_filter,
    realcore2723011601time_result_2_filter,
    realcore2743021601time_result_2_filter,
    realcore2963041601time_result_2_filter,
    realcore2752951601time_result_2_filter,
    realcore3123211601time_result_2_filter,
    realcore2412421601time_result_2_filter
    };

for j = 1:length(results)
    voxels_of_one_sample = [];
    for i = 1:(h+1)
         voxels_of_one_sample = cat(2, voxels_of_one_sample, results{j}(:,:,i)(mask)');
    end
    flatten_voxels_for_all_results = cat(1, flatten_voxels_for_all_results, voxels_of_one_sample);
end

avg = mean(flatten_voxels_for_all_results,2);
MAX = max(flatten_voxels_for_all_results,[],2);
STD = std(flatten_voxels_for_all_results,0,2);
med = median(flatten_voxels_for_all_results,2);
combined_features = cat(2,avg,MAX,STD,med)
writematrix(combined_features,'CoreImageData_15reordered_matchedfilter_avgMAXstdmed.txt')