
function gray_intensity = grayscale_intensity(data, vox_size)%%, subvolume_size)

data_size = size(data)
x=data_size(1)
y=data_size(2)
z=data_size(3)

% Compute Required Number of Voxels in X, Y, Z Direction for a Subvolume
%x=round(subvolume_size(1) * 1000 / vox_size(1));
%y=round(subvolume_size(2) * 1000 / vox_size(2));
%z=round(subvolume_size(3) * 1000 / vox_size(3));

 gray_intensity =zeros(x,y,1);


for i = 1:x
    for j=1:y
        for k=1:z
    gray_intensity(i,j,1)= sum (data(i,j,:))/z; %sum(data(:) == i)
        end
    end
end
%%gray_intensity= mean2(intensity)
end
