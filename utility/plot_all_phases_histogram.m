%% Function - Plot Combined Histogram for All Phases
function output_array = plot_all_phases_histogram(DataStruct, bin_array)
% This function organizes the input data Struct and plots histogram for all
% phases in one figure. The first input 'DataStruct' should be a Struct
% that contains mutiple arrays, with each array containing the parameter of
% interest for all phases. % For example, 'DataStruct' may contain 100
% arrays from 100 subvolumes. Each array may contain 3 numbers from 3
% phases. Each number may represent a volume fraction for a corresponding
% phase. The second input 'bin_array' is necessary for the histogram of all
% phases to have the same bin increment and range. Please refer to Matlab
% documentation on 'histogram'. For example 'bin_array = 0:2:100' means the
% histogram will range from 0 to 1, with each bin size equal to 2;


%% Organize dataStruct to Array

num_subvolumes  =  length(DataStruct);
num_phases      =  length(DataStruct{1});%%length(DataStruct{1});%% length(DataStruct(87));%%   %%for TPB: length(DataStruct(87))

for i = 1:num_subvolumes %%87:160%
    for j = 1:num_phases
        output_array(i,j) = DataStruct{i}(j);% {i}(j); %%DataStruct{i}(j);%%DataStruct(i);%%DataStruct(i);%%  for TPB: DataStruct(i)%% for Tortuosity DataStruct{i}
    end
end


%% Plot Combined Histogram with Lines
linestyle = {'-s','-o','-*','-.x','-.^'};
clr= {'k','r','b','g','m'};
for k = 1:num_phases
    hist_counts = histc(output_array(:,k), bin_array);
    plot(bin_array, hist_counts,linestyle{k},'LineWidth',2,'Color',clr{k}); hold on;
end


% % Plot Combined Histogram with Bars
% for k = 1:num_phases
%     histogram(output_array(:,k), bin_array, 'facealpha',.5,'edgecolor','none'); hold on;
% end










end