%% Function - Subvolume Division
function Struc_Subvolumes = subvolume_division(data, voxel_size, subvolume_size)
% This function divides the total volume of a defined, segmented
% microstructure into multiple smaller subvolume based on user's specified
% subvolume size. The first input 'data' should be a 3D matrix with phases
% labelled as 1, 2, 3, ...etc. The second input 'voxel_size' should be an
% array of 3 numbers, indicating voxel dimension in X, Y, and Z direction
% in NANOMETER (nm). The third input 'subvolume_size' should be an array of
% 3 numbers, indicating desired subvolume dimension in X, Y, and Z
% direction in MICROMETER (um).


%% Compute Required Number of Voxels in X, Y, Z Direction for a Subvolume
data_num_voxels = size(data);
for i = 1:3
    subvol_num_voxels(i) = round(subvolume_size(i) * 1000 / voxel_size(i));
    if subvol_num_voxels(i) > data_num_voxels(i)
        error('Subvolume is larger than entire data.');
    elseif subvol_num_voxels(i) < 1
        error('Subvolume is smaller than a voxel.');
    end
    true_subvol_size_um(i) = subvol_num_voxels(i) * voxel_size(i) / 1000;
    disp(['True subvolume dimension ', num2str(i), ': ', num2str(true_subvol_size_um(i)), ' um']);
end


%% Compute Number of Subvolumes in X, Y, Z Direction
for i = 1:3
    num_subvols(i) = floor(data_num_voxels(i) / subvol_num_voxels(i));
end
total_num_subvols = prod(num_subvols);
disp(['Number of subvolumes: ', num2str(num_subvols)]);



%% Divide the Volume!
range_X0 = 1:subvol_num_voxels(1);
range_Y0 = 1:subvol_num_voxels(2);
range_Z0 = 1:subvol_num_voxels(3);
count = 1;

for i = 1:num_subvols(1)
    for j = 1:num_subvols(2)
        for k = 1:num_subvols(3)
            range_X = range_X0 + (i-1) * subvol_num_voxels(1);
            range_Y = range_Y0 + (j-1) * subvol_num_voxels(2);
            range_Z = range_Z0 + (k-1) * subvol_num_voxels(3);
            Struc_Subvolumes{count} = data(range_X, range_Y, range_Z);
            count = count + 1;
        end
    end
end







end