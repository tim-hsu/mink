%% Script - Template
% 3D_Micro_Mat is a Matlab library developed by Tim Hsu and Rubayyat Mahbub
% to analyzie and process 3D reconstruction images of SOFC microstructures.
% Write your own script to perform customized analysis using 3D_Micro_MAT.
% Below is an example template that you can learn from.
clearvars -except field
clc


%% Name Your Data
Watershed.Data = field.data;


%% Divide Your Data along X/Y/Z direction:1
n1= 2286;
n2= 1326; %% total number of voxels in the Z direction
Watershed.Data=field.data(n1/2+1:n1,1:n2/2,:);


%% Divide Your Data along Z direction:2
%n=250;       %% total number of voxels in the Z direction
%Watershed.Data=field.data(:,:,((n/2)+1):n);


%% Set Voxel Size (nm)
vox_size = [65 65 65];  % (nm)


%% Set Subvolume Size (um)
subvol_size = [8 8 8];  % (um)


%% Check Number of Phases
Watershed.Global.Num_Phases = num_of_phases(Watershed.Data);


%% If Neccessary, Convert Phase '0' to Phase 1
if num_of_phases(Watershed.Data) == 4
    subject_phase   = 0;
    target_phase    = 1;
    Watershed.Data  = convert_phase(Watershed.Data, subject_phase, target_phase);
end


%% Compute Total Volume
Watershed.Global.Total_Vol = total_volume(Watershed.Data, vox_size);


%% Compute Volume Fractions (GLOBAL)
Watershed.Global.Vol_Frac = volume_fraction(Watershed.Data);


%% Plot Volume Fractions vs. Axis
direction = 3; % X = 1, Y = 2, Z = 3
plot_volume_fraction_vs_axis(Watershed.Data, vox_size, direction);


%% Divide the Data into Subvolumes
Watershed.Subvol.Data = subvolume_division(Watershed.Data, vox_size, subvol_size);


%% Save Subvolumes
 for i=1:1%% length(Watershed.Subvol.Data)
Wtd.Data(i)=Watershed.Subvol.Data(i);
subvol=cell2mat(Wtd.Data(i));

save('subvol.mat','subvol');
 end 
%% Compute Volume Fractions of Each Subvolume
for i = 1:length(Watershed.Subvol.Data)
    Watershed.Subvol.Vol_Fracs{i} = volume_fraction(Watershed.Subvol.Data{i});
end


%% Plot Combined Histogram for Volume Fractions
bin_array = 0:0.01:1;
subvol_vol_fracs = plot_all_phases_histogram(Watershed.Subvol.Vol_Fracs, bin_array);


%% Save Data
save('subvol5_Synthetic_Volume Fraction_N675_STD080.mat','subvol_vol_fracs');


%% Survace Area
Watershed.Global.Surface_Area=surface_area(Watershed.Data,vox_size);


%%  Compute Surface Area of Each Subvolume (~5 Sec for each subvolume of 5um3 and ~480 sec for subvolume of 12.5 um3)
for i = 1:length(Watershed.Subvol.Data)
    Subvol=i
    Watershed.Subvol.Surface_Area{i} = surface_area(Watershed.Subvol.Data{i},vox_size);
end


%% Plot Combined Histogram for Surface Area
bin_array = 1:10:500;
subvol_surface_area = plot_all_phases_histogram(Watershed.Subvol.Surface_Area, bin_array);


%% Save Data
save('subvolsuracearea_5_Volume Normalized_watershed_180x100x10.1_N700_Z78-end.mat','subvol_surface_area');


%% Normalize Surface Area
for i = 1:length(Watershed.Subvol.Data)
   Watershed.NormalizedSubvol.Surface_Area{i} = Watershed.Subvol.Surface_Area{i} ./ 125.4;  
end



%% Plot Combined Histogram for Normalized Surface Area
bin_array = 1:.1:4;
subvol_surface_area = plot_all_phases_histogram(Watershed.NormalizedSubvol.Surface_Area, bin_array);



%% %% Compute TPB  of Each Subvolume (~10 MINS for ech subvolume of 5um AND ~ 6 hrs for each 12.5 um subvolume) %
% First Choose Options in the optionsfile.m
for i = 49:50%length(Watershed.Subvol.Data)
    Subvolume=i
    Watershed.Subvol.TPB{i} = main_TPB_find_and_smooth_v2(Watershed.Subvol.Data{i});
end



%% Plot Combined Histogram for TPB
bin_array = 1:.1:8;
subvol_TPB = plot_all_phases_histogram(Watershed.Subvol.TPB, bin_array);



%% Save Data
%correct plot_all_phases_histogram (i= )before saving values od subvolumes
save('subvol_TPB-38-50.mat','subvol_TPB');



%%  Compute Interface Surface Area(With Smoothing Operation) of Each Subvolume (~5 Sec for each subvolume of 5um3 and ~480 sec for subvolume of 12.5 um3)

for i = 1:length(Watershed.Subvol.Data)
    Subvol=i
    Watershed.Subvol.Multi_SA{i} = patch_surface_area(Watershed.Subvol.Data{i});
end


%% Plot Combined Histogram for Multi_Surface Area
bin_array = 1:100:3000;
subvol_Multi_SA = plot_all_phases_histogram(Watershed.Subvol.Multi_SA, bin_array);


%% Save Data
save('subvol12-5_msri_anode_Normalized_multi_surfacearea__watershed_126x73x12.5_N50.mat','subvol_Multi_SA');


%% Normalized Multi_Surface Area
for i = 1:length(Watershed.Subvol.Data)
   Watershed.NormalizedSubvol.Multi_SA{i} = Watershed.Subvol.Multi_SA{i} ./ 1948.4;  %% divide by the mean of Multi_SA
end



%% Plot Combined Histogram for Normalized Multi_Surface Area
bin_array = 0:.1:3;
NormalizedSubvol_Multi_SA = plot_all_phases_histogram(Watershed.NormalizedSubvol.Multi_SA, bin_array);



%% %%  Compute Particle Size Distribution of whole volume ( ------Sec for whole volume)
% First Choose Options in the optionsfile_f.m
% Change L value in main_diam_dist

% % for i = 1:length(Watershed.Subvol.Data)
% %     Subvol=i
    Watershed.Global.Particle_size_dist{i} = main_diam_dist(Watershed.Data); % end



%%  Compute Avg. Particle Size of Each Subvolume ( ~4-6 hrs for each 12.5um subvolume)
% First Choose Options in the optionsfile_f.m
% Change L value in main_diam_dist

for i = 1:length(Watershed.Subvol.Data)
    Subvol=i
    Watershed.Subvol.Particle_size_dist{i} = main_diam_dist(Watershed.Subvol.Data{i});
end


%% Plot Combined Histogram for Avg. Particle Size Distribution
bin_array = 0:.1:1;
subvol_particle_size= plot_all_phases_histogram(Watershed.Subvol.Particle_size_dist, bin_array);


%% Save Data
save('subvol12-5_msri_anode_Avg_Particle_size__watershed_126x73x12.5_N50_1-4.mat','subvol_particle_size');




%%  Compute tortuosity of Each Subvolume ( ~ mins for each 5um subvolume)
%%Works for Binary Data only, where 1 is the target phase
dim=4;  %% TRANSP_DIM, optional, an integer: 1, 2, 3, or 4 (see below).
        %       Default is 4.
        %       Represents the dimension in DATA along which transport occurs. The
        %       tortuosity will be calculated along that dimension. So e.g. if you
        %       choose 3, the tortuosity will be based on the transport distance
        %       between z=1 and z=end.
        %       If 4, it will do all 3 dimensions and then average them together.

for i = 1:length(Watershed.Subvol.Data)
    Subvol=i
    Watershed.Subvol.tort_fact{i} = tortuosity_factor(Watershed.Subvol.Data{i},dim);
end


%% Plot Combined Histogram for Tortuosity %% modify plot_all_phases_histogram
bin_array = 1:0.04:3;
subvol_tortuosity_f = plot_all_phases_histogram(Watershed.Subvol.tort_fact, bin_array);


%% Save Data
%correct plot_all_phases_histogram before saving values of subvolumes
save('MSRI_Anode_82x124x8__subvol_8_Tortuosity_YSZ.mat','subvol_tortuosity_f');


%% Compute Grayscale Gradient (GLOBAL)
Watershed.Global.Gray_Intensity=grayscale_intensity(Watershed.Data,vox_size);


%% Compute Grayscale Graduent (Local)
for i = 1:length(Watershed.Subvol.Data)
    Watershed.Subvol.Gray_Intensity{i} = grayscale_intensity(Watershed.Subvol.Data{i},vox_size, subvol_size);
end
%% Plot Combined Histogram for Grayscale Gradient
bin_array = 0:0.01:1;
subvol_gray_intensity = plot_all_phases_histogram( Watershed.Subvol.Gray_Intensity, bin_array);

%% Save Data
%correct plot_all_phases_histogram before saving values od subvolumes
save('MSRI_Cathode_subvol_5_GSIntensity_LSM.mat','subvol_gray_intensity');

