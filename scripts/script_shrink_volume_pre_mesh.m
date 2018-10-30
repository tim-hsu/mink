%% Rememebr to Load the Data (.mat file)
clc
baseNameString = 'MSRI_CAT_';


%% Set Voxel Size (nm)
vox_size = [55 55 50];  % (nm)


%% Set Shrink Diameter/Distance at Each Step
shrink_d    = 2.5; % (um)
shrink_vox  = round(0.5 .* shrink_d ./ vox_size .* 1000);


for i = 1:length(SubvolumeData)
    %% Define the Volume to Shrink from
    shrinkVolume{1} = SubvolumeData{i};
    
    
    %% Shrink Volume to Specified Size
    j = 1;
    size_um = size(shrinkVolume{j}) .* vox_size ./ 1000;
    while size_um(1) > 5
        shrinkVolume{j+1} = shrinkVolume{j}(...
            (1 +   shrink_vox(1)):(end - shrink_vox(1)),...
            (1 +   shrink_vox(2)):(end - shrink_vox(2)),...
            (1 + 2*shrink_vox(3)): end);
        size_um = size(shrinkVolume{j+1}) .* vox_size ./ 1000;
        j = j + 1;
    end
        
    
    for j = 1:length(shrinkVolume)
        %% Sequential Dilation
        shrinkVolume{j} = sequenceDilate(shrinkVolume{j});
        
        
        %% Initiate LabelField Class
        BOX = LabelField(shrinkVolume{j}, vox_size);
        
        
        %% Append Electrolyte Layer
        layerThickness = 5; % (um)
        BOX.addElectrolyteLayer(layerThickness);
        
        
        %% Find and Label Isolated Phases
        BOX.findIsoPhases();
        
        
        %% Label TPB Voxels
        BOX.getTPBs();
        
        
        %% Display Volume Fractions and Dimensions
        volume_fraction(BOX.fieldTPB);
        disp(['Size (vox): ', num2str(size(BOX.fieldTPB))]);
        
        
        %% Write to .raw files
        fileID = fopen([baseNameString, 'box', num2str(i) ,...
            '_shrink', num2str(j),'.raw'],'w');
        fwrite(fileID,BOX.fieldTPB,'uint8');
        fclose(fileID);
    end
end


