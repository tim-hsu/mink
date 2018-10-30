%% MSRI
X       = 3143;
Y       = 1823;
Z       = 313;
fid     = fopen('msri-3ph-full-data-3143x1823x313-40nm.raw','r');
I       = fread(fid,X*Y*Z,'uint8=>uint8'); 
data    = reshape(I,X,Y,Z);
fclose(fid);
baseNameStr     = 'msri';

script_russdoll_pre_mesh


%% s015
X       = 1392;
Y       = 1392;
Z       = 278;
fid     = fopen('std015-3ph-full-data-1392x1392x278-scaled-and-resampled-40nm.raw','r');
I       = fread(fid,X*Y*Z,'uint8=>uint8'); 
data    = reshape(I,X,Y,Z);
fclose(fid);
baseNameStr     = 's015';

script_russdoll_pre_mesh


%% s060
X       = 909;
Y       = 909;
Z       = 182;
fid     = fopen('std060-3ph-full-data-909x909x182-scaled-and-resampled-40nm.raw','r');
I       = fread(fid,X*Y*Z,'uint8=>uint8'); 
data    = reshape(I,X,Y,Z);
fclose(fid);
baseNameStr     = 's060';

script_russdoll_pre_mesh
