%% Rememebr to Load the Data (.mat file)
% if exist('field') ~= 0
%     data = uint8(field.data);
% end
% clearvars -except data


%% Input Parameters
% baseNameStr     = 'msri';
% addedNameStr    = '-scaled-';
% upsampleData    = true;
% upsampleFactor  = 2;
% meanGrainSize   = 0.46;
% subvol_size     = [10.0 10.0 7.0];  % (um)
% vox_size        = [55.0 55.0 50.0]; % (nm)
% countMax        = 15;


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


%% Divide the Data into Subvolumes
SubvolumeData = subvolume_division(dataCopy, vox_size, subvol_size);


%% Automated for-loop
count = 1;
% for i = 1:length(SubvolumeData)
subvolumeIndex
for i = subvolumeIndex
    if count > countMax
        break;
    end
    disp(['=============== INDEX = ',num2str(i),' ===============']);
    
    %% Sequential Dilation
    disp('Applying sequential dilation...');
    SubvolumeData{i} = sequenceDilate(SubvolumeData{i});
    
    
    %% Initiate LabelField Class
%     BOX3PHASE = LabelField(SubvolumeData{i}, vox_size);
    
    
    %% Find and Label Isolated Phases
%     disp('Finding isolated phases...');
%     BOX3PHASE.findIsoPhases();
    
    
    %% Show relevant stats
%     disp('THREE PHASE STATS');
%     BOX3PHASE
%     volume_fraction(BOX3PHASE.field);
    
    
    %% Save to .mat files
    fullNameString = [baseNameStr,...
                      addedNameStr,...
                      '3ph-',...
                      num2str(i),...
                      '.mat'];
    data_matrix = uint8(SubvolumeData{i});
    save(fullNameString,'data_matrix','vox_size','subvol_size');
    
    count = count + 1;
end


