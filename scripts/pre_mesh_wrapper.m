%% MSRI
data = dataMSRI;

baseNameStr     = 'msri';
addedNameStr    = '-res2-';
upsampleData    = true;
upsampleFactor  = 2;
meanGrainSize   = 0.46;
subvol_size     = [10.0 10.0 7.0];  % (um)
vox_size        = [55 55 50]; % (nm)
countMax        = 15;

script_pre_mesh


%% SYN 035
data = dataSYN035;

baseNameStr     = 'syn035';
addedNameStr    = '-res3-';
upsampleData    = true;
upsampleFactor  = 3;
meanGrainSize   = 0.70;
subvol_size     = [10.0 10.0 7.0];  % (um)
vox_size        = [125 125 125]; % (nm)
countMax        = 15;

script_pre_mesh


%% SYN 060
data = dataSYN060;

baseNameStr     = 'syn060';
addedNameStr    = '-res2-';
upsampleData    = true;
upsampleFactor  = 2;
meanGrainSize   = 0.95;
subvol_size     = [10.0 10.0 7.0];  % (um)
vox_size        = [125 125 125]; % (nm)
countMax        = 15;

script_pre_mesh


%% SYN 080
data = dataSYN080;

baseNameStr     = 'syn080';
addedNameStr    = '-res2-';
upsampleData    = true;
upsampleFactor  = 2;
meanGrainSize   = 1.30;
subvol_size     = [10.0 10.0 5.0];  % (um)
vox_size        = [125 125 125]; % (nm)
countMax        = 15;

script_pre_mesh



%% SYN 015
data = dataSYN015;

baseNameStr     = 'syn015';
addedNameStr    = '-res3-';
upsampleData    = true;
upsampleFactor  = 3;
meanGrainSize   = 0.62;
subvol_size     = [10.0 10.0 7.0];  % (um)
vox_size        = [125 125 125]; % (nm)
countMax        = 15;

script_pre_mesh
