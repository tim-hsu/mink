%% Function - Convert Volume Fraction by Slice
function new_data = convert_phase(data, subject_phase, target_phase)
% This function converts a specified phase to a specified target phase
% (e.g., convert all phase 0 to phase 3). NOTE: This function exists due to
% that Avizo's 2D-Histogram Watershed segmentation often yields a fourth
% phase when the user specifies only 3 phases. Before using this function,
% user has to check the volume fraction of each phase. 

% The first input 'data' should be a 3D matrix with phases labelled as 1,
% 2, 3, ...etc. The second input 'subject_phase' should be a number/label
% for the phase to be converted. The third input 'target_phase' should be a
% number for the phase that subject_phase is converted to.


data(data(:) == subject_phase) = target_phase;
new_data = data;




end