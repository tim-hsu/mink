%% Function - Compute Global (Average) Volume Fraction
function total_vol = total_volume(data, voxel_size)
% This function computes the total volume of a defined, segmented
% microstructure volume. Input data should be a 3D matrix with phases
% labelled as 1, 2, 3, ...etc. Also, the second input 'voxel_size' should
% be an array of 3 numbers, indicating voxel dimension in X, Y, and Z
% direction in NANOMETER.

data_size = size(data);

dimension_nm(3) = 0;
dimension_um(3) = 0;

for i = 1:3
    dimension_nm(i) = data_size(i) * voxel_size(i);
    dimension_um(i) = dimension_nm(i) / 1000;
    disp(['Dimension ', num2str(i), ': ', num2str(dimension_um(i)), ' um.']);
end

total_vol = prod(dimension_um);
disp(['Total volume: ', num2str(total_vol), ' um^3.']);








end