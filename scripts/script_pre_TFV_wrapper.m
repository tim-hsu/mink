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
subvolumeIndex  = [79    12    20     2    14    72    71    15    35    76    48    49    81    34    10];

script_pre_TFV


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
subvolumeIndex  = [15     8    11     1     9     3    16     7    13     2     4     5     6    12    10    14];

script_pre_TFV


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
subvolumeIndex  = [3     7     1     9     8     4     5     6     2];

script_pre_TFV


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
subvolumeIndex  = [4     2     1     3];

script_pre_TFV



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
subvolumeIndex  = [19    13    15     3     7     2    16    14    17     1    24    10    12    18    23];

script_pre_TFV
