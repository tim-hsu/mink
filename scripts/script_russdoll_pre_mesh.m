%% Rememebr to Load the Data (.mat file)
% if exist('field') ~= 0
%     data = uint8(field.data);
% end
% clearvars -except data


%% Read .raw Image Data
% X       = 1233;
% Y       = 1233;
% Z       = 247;
% fid     = fopen('std035-3ph-full-data-1233x1233x247-scaled-and-resampled-40nm.raw','r');
% I       = fread(fid,X*Y*Z,'uint8=>uint8'); 
% data    = reshape(I,X,Y,Z);
% fclose(fid);


%% Input Parameters
% baseNameStr     = 'syn035';
addedNameStr    = '-largescale-';
upsampleData    = false;
upsampleFactor  = 1;
meanGrainSize   = 0.46; % (um)
subvol_size     = [30.0 30.0 7.0];  % (um)
vox_size        = [40 40 40]; % (nm)
% russDoll_sizes = [ 10   10  15;
%                    14   14  15;
%                    18   18  15;
%                    22   22  15;
%                    26   26  15;
%                    30   30  15;
%                    40   40  15;
%                    50   50  15];
russDoll_sizes = [ 20   20  7.0;
                   25   25  7.0;
                   30   30  7.0];
               
               
%% Scale Factors
targetGrainSize = 0.46; % (um)
% s015    = targetGrainSize / 0.62;
% s035    = targetGrainSize / 0.70;
% s060    = targetGrainSize / 0.95;
% s080    = targetGrainSize / 1.30;
% sMSRI   = targetGrainSize / 0.46;
scaleFactor = targetGrainSize / meanGrainSize;


%% Scale Voxel Size
vox_size = vox_size * scaleFactor;


%% Matrix Upsample
if upsampleData
    dataCopy = matrix_upsample(data,upsampleFactor);
    vox_size = vox_size / upsampleFactor;  % (nm)
else
    dataCopy = data;
end


%% Check Number of Phases
num_of_phases(dataCopy);


%% Begin Logging
diary([baseNameStr,addedNameStr,'log.txt']);


%% Divide the Data into Subvolumes
SubvolumeData = subvolume_division(dataCopy, vox_size, subvol_size);


%% Set Russian Doll Sizes (um)
num_of_inner_dolls = size(russDoll_sizes,1);


%% Automated for-loop
for i = 1:length(SubvolumeData)    
    %% Sequential Dilation
    disp('Applying sequential dilation...');
    SubvolumeData{i} = sequenceDilate(SubvolumeData{i});
        
    for j = 1:num_of_inner_dolls
        disp(['ITERATION: SET ', num2str(i),...
              ' DOLL ', num2str(russDoll_sizes(j,1)),' um']);
      
        russianDollSubvol = russ_doll_subvol(SubvolumeData{i},...
                                             vox_size,...
                                             russDoll_sizes(j,:));
        
        
        %% Initiate LabelField Class
        BOX4PHASE = LabelField(russianDollSubvol, vox_size);
        BOX3PHASE = LabelField(russianDollSubvol, vox_size);
        
        
        %% Append Electrolyte Layer
        disp('Adding electrolyte layer...');
        layerThickness = 3; % (um)
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
                          '4ph-set',...
                          num2str(i),...
                          '-doll',...
                          num2str(russDoll_sizes(j,1)),...
                          'um',...
                          '.raw'];
        fileID = fopen(fullNameString,'w');
        fwrite(fileID,BOX4PHASE.field,'uint8');
        fclose(fileID);

        fullNameString = [baseNameStr,...
                          addedNameStr,...
                          '3ph-set',...
                          num2str(i),...
                          '-doll',...
                          num2str(russDoll_sizes(j,1)),...
                          'um',...
                          '.raw'];
        fileID = fopen(fullNameString,'w');
        fwrite(fileID,BOX3PHASE.field,'uint8');
        fclose(fileID);
    end
end
diary off
