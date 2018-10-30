%% Function - Compute Volume Fraction by Slice
function vol_frac_vs_axis = plot_volume_fraction_vs_axis(data, voxel_size, direction)
% This function computes phase volume fractions per slice vs. an orthogonal
% direction in a defined, segmented microstructure volume. The first input
% 'data' should be a 3D matrix with phases labelled as 1, 2, 3, ...etc. The
% second input 'voxel_size' should be an array of 3 numbers, indicating
% voxel dimension in X, Y, and Z direction in NANOMETER (nm). The third
% input 'direction' should be a number that is either 1, 2, or 3,
% indicating X, Y, or Z-direction, respectively.


%% Check if 'Data' is in Right Format
if min(min(min(data))) == 0
    data = data + 1;
end


%% Compute Volume Fraction by Slice
[X, Y, Z] = size(data);
num_phases = num_of_phases(data);

switch direction
    case 1
        disp('Along X-axis')
        vol_frac_vs_axis(X,num_phases) = 0;
        slice_vol = Y * Z;
        for i = 1:X
            for n = 1:num_phases
                vol_frac_vs_axis(i,n) = sum(sum(data(i,:,:) == n)) / slice_vol;
            end
        end
        x = 1:X;
        x = x .* voxel_size(1) / 1000; % (um)
        char = 'X';
        
        
    case 2
        disp('Along Y-axis')
        vol_frac_vs_axis(Y,num_phases) = 0;
        slice_vol = X * Z;
        for j = 1:Y
            for n = 1:num_phases
                vol_frac_vs_axis(j,n) = sum(sum(data(:,j,:) == n)) / slice_vol;
            end
        end
        x = 1:Y;
        x = x .* voxel_size(2) / 1000; % (um)
        char = 'Y';
        
        
    case 3
        disp('Along Z-axis')
        vol_frac_vs_axis(Z,num_phases) = 0;
        slice_vol = X * Y;
        for k = 1:Z
            for n = 1:num_phases
                vol_frac_vs_axis(k,n) = sum(sum(data(:,:,k) == n)) / slice_vol;
            end
        end
        x = 1:Z;
        x = x .* voxel_size(3) / 1000; % (um)
        char = 'Z';
        
        
    otherwise
        disp('Orthgonal direction is not specified.')
end


%% Plot Volume Fractions vs. X, Y, or Z
for i = 1:num_phases
    plot(x,vol_frac_vs_axis(:,i));
    hold on;
end
xlabel([ char, ' [\mum]']);
ylabel('Volume Fractions');
title(['Volume Fractions vs. ', char]);
axis tight



end