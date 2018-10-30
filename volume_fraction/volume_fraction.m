%% Function - Compute Volume Fraction
function vol_frac = volume_fraction(data)
% This function computes volume fraction of each phase in a defined,
% segmented microstructure volume. Input data should be a 3D matrix with
% phases labelled as 1, 2, 3, ...etc


%% Compute Number of Phases
num_phases = num_of_phases(data);

if min(min(min(data))) == 0
    data = data + 1;
end


%% Compute Volume Fraction of Each Phase
[X,Y,Z]     = size(data);
total_vol   = X * Y * Z;
volume(num_phases)      = 0;
vol_frac(num_phases)    = 0;

for i = 1:num_phases
    volume(i)   = sum(data(:) == i);
    vol_frac(i) = volume(i) / total_vol;
    disp(['Phase ', num2str(i), ' volume fraction: ', num2str(vol_frac(i))]);
end









end