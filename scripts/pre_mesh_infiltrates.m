%% Rememebr to load the data (.mat file)
clearvars -except data
close all


%% Input parameters
baseName        = 'std060-1-';
addedName       = 'infiltrated-';
upsampleData    = false;
upsampleFactor  = 1;
meanGrainSize   = 0.46;
subvol_size     = [10.0 10.0 7.0];  % (um)
vox_size        = [30.2632 30.2632 30.2632]; % (nm)
countMax        = 10;
seedProbability = [0.02 0.05 0.08 0.1 0.12 0.15];
% seedProbability = 0.05;
kernelRadius    = 2;


%% Scale factors
% s015    = targetGrainSize / 0.62;
% s035    = targetGrainSize / 0.70;
% s060    = targetGrainSize / 0.95;
% s080    = targetGrainSize / 1.30;
% sMSRI   = targetGrainSize / 0.46;
targetGrainSize = 0.46; % (um)
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
diary([baseName,addedName,'log.txt']);


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
    

    %% Add nano-infiltrates
    disp('Adding nano-infiltrates...');
    
    for p = seedProbability
        subvolData = add_infiltrates(subvolData, p, kernelRadius);
        
        
        %% Initiate LabelField Class
        field4ph = LabelField(subvolData, vox_size);
        field3ph = LabelField(subvolData, vox_size);


        %% Append Electrolyte Layer
        layerThickness = 3.0; % (um)
        disp('Adding electrolyte layer...');
        field4ph.addElectrolyteLayer(layerThickness);


        %% Find and Label Isolated Phases
        disp('Finding isolated phases...');
        field4ph.findIsoPhases();
        field3ph.findIsoPhases();


        %% Label TPB Voxels
        disp('Generating TPB voxels...');
        field4ph.getTPBs();
        field4ph.field = field4ph.fieldTPB;


        %% Find & Label Isolated Phases Again
        disp('Finding isolated phases...');
        field4ph.findIsoPhases();


        %% Show relevant stats
        disp('FOUR PHASE STATS');
        field4ph
        volume_fraction(field4ph.field);

        disp('THREE PHASE STATS');
        field3ph
        volume_fraction(field3ph.field);


        %% Write to .raw files
        fullNameString = [baseName,...
                          addedName,...
                          '4ph-',...
                          '-p=',...
                          num2str(p),...
                          '.raw'];
        fileID = fopen(fullNameString,'w');
        fwrite(fileID,field4ph.field,'uint8');
        fclose(fileID);

        fullNameString = [baseName,...
                          addedName,...
                          '3ph-',...
                          '-p=',...
                          num2str(p),...
                          '.raw'];
        fileID = fopen(fullNameString,'w');
        fwrite(fileID,field3ph.field,'uint8');
        fclose(fileID);
        count = count + 1;
    end
end
diary off


