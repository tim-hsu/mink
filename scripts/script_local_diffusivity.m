%% Rememebr to Load the Data (.mat file)
clearvars -except field
clc
baseNameString = 'MSRI_CAT_5um';
T   = 1073; % temperature (K)
M_i = 32;   % molecular weight of O2 (g/mol)


%% Set Voxel Size (nm)
vox_size = [55 55 50];  % (nm)
mean_vox_size_in_cm = prod(vox_size)^(1/3) * 1e-7; % (cm)


%% Set Shrink Diameter/Distance at Each Step
shrink_d    = 2.5; % (um)
shrink_vox  = round(0.5 .* shrink_d ./ vox_size .* 1000);


%% Set Subvolume Size (um)
subvol_size = [12.5 12.5 12.5];  % (um)


%% Check Number of Phases
num_of_phases(field.data);


%% Divide the Data into Subvolumes
SubvolumeData = subvolume_division(field.data, vox_size, subvol_size);


%% Automated for-loop
% for i = 1:length(SubvolumeData)
for i = 1
    %% Sequential Dilation
    SubvolumeData{i} = sequenceDilate(SubvolumeData{i});
    
    
    %% Initiate LabelField Class
    BOX = LabelField(SubvolumeData{i}, vox_size);
    
    
    %% Append Electrolyte Layer    
    layerThickness = 5; % (um)
    BOX.addElectrolyteLayer(layerThickness);
    
    
    %% Compute Local Pore Diameter
    pores = zeros(size(BOX.field));
    pores(BOX.field == 1) = 1;
    [r_pore, N_pore, diams_3d_pore] = dia_dist_v3(pores,2,30);
    diams_in_cm = diams_3d_pore * mean_vox_size_in_cm;
    D_iK{i} = 4580 * diams_in_cm * (T / M_i)^0.5; 
end


%% Write to Image Stack
[~,~,numSlices] = size(diams_3d_pore);
for i = 1:numSlices
    imgSlice(:,:) = diams_3d_pore(:,:,i);
    fnameIndex = sprintf('%03d',i);
    imwrite(imgSlice,['box1_shrink4_',fnameIndex,'.png'],'png');
end


%% Read Image Stack [Debug]
for i = 1:100
    fnameIndex = sprintf('%03d',i);
    IMG = imread(['box1_shrink4_',fnameIndex,'.png']);
    figure(1);
    imagesc(IMG,[0 20]);
    title(['slice: ',num2str(i)]);
    colorbar;
%     pause(0.2);
    M(i)=getframe;
end

% for i = 1:14
%     histogram(D_iK{i}(D_iK{i}~=0))
%     pause(0.5);
% end
