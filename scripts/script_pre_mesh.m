%% Rememebr to load the data (.mat file)
clearvars -except data


%% Input parameters
baseNameStr     = 'std080';
addedNameStr    = '-res1-';
upsampleData    = false;
upsampleFactor  = 1;
meanGrainSize   = 1.30;
subvol_size     = [10.0 10.0 7.0];  % (um)
vox_size        = [125 125 125]; % (nm)
countMax        = 15;


%% Scale factors
targetGrainSize = 0.46; % (um)
% s015    = targetGrainSize / 0.62;
% s035    = targetGrainSize / 0.70;
% s060    = targetGrainSize / 0.95;
% s080    = targetGrainSize / 1.30;
% sMSRI   = targetGrainSize / 0.46;
scaleFactor = targetGrainSize / meanGrainSize;


%% Scale voxel size
vox_size = vox_size * scaleFactor;


%% Check number of phases
num_of_phases(data);


%% Divide the data into subvolumes
SubvolumeData = subvolume_division(data, vox_size, subvol_size);


%% Update vox_size if there is upsampling (upsampling run in loop)
if upsampleData
    vox_size = vox_size / upsampleFactor;  % (nm)
end


%% Begin logging
diary([baseNameStr,addedNameStr,'log.txt']);


%% Automated for-loop
count = 1;
% for i = 1:length(SubvolumeData)
subvolumeIndex = shuffle(1:length(SubvolumeData));
disp(['Randomly ordered indices: ', num2str(subvolumeIndex)]);

for i = subvolumeIndex
    if count > countMax
        break;
    end
    
    disp(['==================== INDEX: ',num2str(i),' =====================']);
    subvolData = SubvolumeData{i};
    
    %% Matrix Upsample
    if upsampleData
        subvolData = matrix_upsample(subvolData,upsampleFactor);
    end
    
    %% Sequential Dilation
    disp('Applying sequential dilation...');
    subvolData = sequenceDilate(subvolData);
    
    
    %% Initiate LabelField Class
    BOX4PHASE = LabelField(subvolData, vox_size);
    BOX3PHASE = LabelField(subvolData, vox_size);
    
    
    %% Append Electrolyte Layer
    layerThickness = 3.0; % (um)
    disp('Adding electrolyte layer...');
    BOX4PHASE.addElectrolyteLayer(layerThickness);
    
    
    %% Find and Label Isolated Phases
    disp('Finding isolated phases...');
    BOX4PHASE.findIsoPhases();
    BOX3PHASE.findIsoPhases();
    
    
    %% Label TPB Voxels
    disp('Generating TPB voxels...');
    BOX4PHASE.getTPBs();
    BOX4PHASE.field = BOX4PHASE.fieldTPB;
    
    
    %% Find & Label Isolated Phases Again
    disp('Finding isolated phases...');
    BOX4PHASE.findIsoPhases();
    
    
    %% Show relevant stats
    disp('FOUR PHASE STATS');
    BOX4PHASE
    volume_fraction(BOX4PHASE.field);
    
    disp('THREE PHASE STATS');
    BOX3PHASE
    volume_fraction(BOX3PHASE.field);
    
    
    %% Write to .raw files
    fullNameString = [baseNameStr,...
                      addedNameStr,...
                      '4ph-',...
                      num2str(i),...
                      '.raw'];
    fileID = fopen(fullNameString,'w');
    fwrite(fileID,BOX4PHASE.field,'uint8');
    fclose(fileID);
    
    fullNameString = [baseNameStr,...
                      addedNameStr,...
                      '3ph-',...
                      num2str(i),...
                      '.raw'];
    fileID = fopen(fullNameString,'w');
    fwrite(fileID,BOX3PHASE.field,'uint8');
    fclose(fileID);
    count = count + 1;
end
diary off


