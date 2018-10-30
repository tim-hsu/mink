%% Function - Extract Russian Doll Subvolumes
function russianSubvol = russ_doll_subvol(volume,vox_size_nm,subvol_size_um)



%% Compute Required Number of Voxels in X, Y, Z Directions for a Subvolume
volume_size_vox = size(volume);
subvol_size_vox = zeros(1,3);
true_subvol_size_um = zeros(1,3);
for i = 1:3
    subvol_size_vox(i) = round(subvol_size_um(i) * 1000 / vox_size_nm(i));
    if subvol_size_vox(i) > volume_size_vox(i)
        error('Subvolume is larger than entire data.');
    elseif subvol_size_vox(i) < 1
        error('Subvolume is smaller than a voxel.');
    end
    true_subvol_size_um(i) = subvol_size_vox(i) * vox_size_nm(i) / 1000;
    disp(['True subvolume dimension ', num2str(i),...
          ': ', num2str(true_subvol_size_um(i)), ' um']);
end


%% Compute Matrix Indices for Subvolume Extraction
size_diff_vox = (volume_size_vox - subvol_size_vox);
margin_vox = size_diff_vox ./ 2;
mat_indices{3} = [];
for i = 1:3
    indMax = volume_size_vox(i);
    if floor(margin_vox(i)) == margin_vox(i) % check if it's integer
        mat_indices{i} = (1+margin_vox(i)):(indMax-margin_vox(i));
    else
        mat_indices{i} = (1+margin_vox(i)-0.5):(indMax-margin_vox(i)-0.5);
    end
end
russianSubvol = volume(mat_indices{1},mat_indices{2},mat_indices{3});