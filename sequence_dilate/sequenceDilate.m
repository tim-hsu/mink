function dilated_field = sequenceDilate(label_field)
%% Modified from original code by William Epting (National Energy Technology Laboratory)


%% Parameters
r = 2; % radius of dilating kernel


%% Set Up
[X,Y,Z] = size(label_field);

ph1 = zeros(X,Y,Z);
ph2 = zeros(X,Y,Z);
ph3 = zeros(X,Y,Z);

ph1 = uint8(ph1);
ph2 = uint8(ph2);
ph3 = uint8(ph3);

ph1(label_field==1) = 1;
ph2(label_field==2) = 1;
ph3(label_field==3) = 1;

se = strel('sphere', r);


%% Dilate phase 3, erode 1 and 2
ph3 = imdilate(ph3, se);

% erode overlaps
ph1 = ph1 - ph3;
ph2 = ph2 - ph3;

% set all negative values back to 0
ph1(ph1<0) = 0;
ph2(ph2<0) = 0;


%% Dilate phase 1, erode 2 and 3
ph1 = imdilate(ph1, se);

% erode overlaps
ph2 = ph2 - ph1;
ph3 = ph3 - ph1;

% set all negative values back to 0
ph2(ph2<0) = 0;
ph3(ph3<0) = 0;


%% Dilate phase 2, erode 1 and 3
ph2 = imdilate(ph2, se);

% erode overlaps
ph1 = ph1 - ph2;
ph3 = ph3 - ph2;

% set all negative values back to 0
ph1(ph1<0) = 0;
ph3(ph3<0) = 0;


%% Restoring data back to fields
dilated_field = 0;
dilated_field = ph1 + ph2*2 + ph3*3;


end