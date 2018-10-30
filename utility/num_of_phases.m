%% Function - Compute Number of Phases
function num_phases = num_of_phases(data)


phase_first = min(min(min(data)));
phase_last  = max(max(max(data)));
num_phases  = phase_last - phase_first + 1;

disp(['Number of phases: ', num2str(num_phases)]);

if phase_first ~= 1
    disp('Warning. First phase does not start from 1');
end

if num_phases ~= 3
    disp('Warning. Number of Phases is not 3.');
end





end