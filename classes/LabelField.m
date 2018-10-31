classdef LabelField < handle
    properties
        field
        voxelSize_nm
        dimensionVoxels
        fieldTPB
    end

    methods
        function obj = LabelField(fieldData,voxelSize)
            obj.field           = fieldData;
            obj.voxelSize_nm    = voxelSize;
            obj.dimensionVoxels = size(fieldData);
            obj.fieldTPB        = [];
        end

        
        function obj = getTPBs(obj)
            X = obj.dimensionVoxels(1);
            Y = obj.dimensionVoxels(2);
            Z = obj.dimensionVoxels(3);
            obj.fieldTPB = zeros(X,Y,Z);
            
            thisField    = obj.field;
            thisFieldTPB = obj.fieldTPB;
            
            parfor z = 1:Z
                fieldTPB_XY = thisFieldTPB(:,:,z);
                for x = 1:X-1
                    for y = 1:Y-1
                        val1 = thisField(x  ,y  ,z  );
                        val2 = thisField(x+1,y  ,z  );
                        val3 = thisField(x  ,y+1,z  );
                        val4 = thisField(x+1,y+1,z  );
                        if all(ismember([1 2 3],[val1 val2 val3 val4]))
                            fieldTPB_XY(x  ,y  ) = 4;
                            fieldTPB_XY(x+1,y  ) = 4;
                            fieldTPB_XY(x  ,y+1) = 4;
                            fieldTPB_XY(x+1,y+1) = 4;
                        end
                    end
                end
                thisFieldTPB(:,:,z) = fieldTPB_XY;
            end
            obj.fieldTPB = thisFieldTPB;
            
            parfor y = 1:Y
                fieldTPB_XZ = thisFieldTPB(:,y,:);
                for x = 1:X-1
                    for z = 1:Z-1
                        val1 = thisField(x  ,y  ,z  );
                        val2 = thisField(x+1,y  ,z  );
                        val3 = thisField(x  ,y  ,z+1);
                        val4 = thisField(x+1,y  ,z+1);
                        if all(ismember([1 2 3],[val1 val2 val3 val4]))
                            fieldTPB_XZ(x  ,z  ) = 4;
                            fieldTPB_XZ(x+1,z  ) = 4;
                            fieldTPB_XZ(x  ,z+1) = 4;
                            fieldTPB_XZ(x+1,z+1) = 4;
                        end
                    end
                end
                thisFieldTPB(:,y,:) = fieldTPB_XZ;
            end
            obj.fieldTPB = thisFieldTPB;
            
            parfor x = 1:X
                fieldTPB_YZ = thisFieldTPB(x,:,:);
                for y = 1:Y-1
                    for z = 1:Z-1
                        val1 = thisField(x  ,y  ,z  );
                        val2 = thisField(x  ,y+1,z  );
                        val3 = thisField(x  ,y  ,z+1);
                        val4 = thisField(x  ,y+1,z+1);
                        if all(ismember([1 2 3],[val1 val2 val3 val4]))
                            fieldTPB_YZ(1, y  ,z  ) = 4;
                            fieldTPB_YZ(1, y+1,z  ) = 4;
                            fieldTPB_YZ(1, y  ,z+1) = 4;
                            fieldTPB_YZ(1, y+1,z+1) = 4;
                        end
                    end
                end
                thisFieldTPB(x,:,:) = fieldTPB_YZ;
            end
            obj.fieldTPB = thisFieldTPB;
            
            obj.fieldTPB = obj.field;
            obj.fieldTPB(thisFieldTPB==4) = 4;
            obj.fieldTPB = uint8(obj.fieldTPB);
%             disp('TPB voxels labeling Done!');
        end

        function obj = addElectrolyteLayer(obj,layerThickness_um)
            X = obj.dimensionVoxels(1);
            Y = obj.dimensionVoxels(2);
            EL = zeros(X,Y,round(layerThickness_um*1000 / obj.voxelSize_nm(3)));
            EL(:) = 3;
            obj.field = cat(3,obj.field,EL);
            obj.dimensionVoxels = size(obj.field);
%             disp('Electrolyte layer added');
        end

        function obj = findIsoPhases(obj)
            BW_PORE = obj.field==1;
            BW_LSM  = obj.field==2;
            BW_YSZ  = obj.field==3;

            CC_PORE = bwconncomp(BW_PORE,6);
            CC_LSM  = bwconncomp(BW_LSM ,6);
            CC_YSZ  = bwconncomp(BW_YSZ ,6);

            L_PORE  = single(labelmatrix(CC_PORE));
            L_LSM   = single(labelmatrix(CC_LSM));
            L_YSZ   = single(labelmatrix(CC_YSZ));

            L_PORE_top      = L_PORE(:,:,1);
            L_LSM_top       = L_LSM(:,:,1);
            L_YSZ_bottom    = L_YSZ(:,:,CC_YSZ.ImageSize(3));

            for i = 1:CC_PORE.NumObjects
                if ~(any(L_PORE_top(:) == i))
                    obj.field(L_PORE == i) = 5;
                end
            end
            for i = 1:CC_LSM.NumObjects
                if ~(any(L_LSM_top(:) == i))
                    obj.field(L_LSM == i) = 6;
                end
            end
            for i = 1:CC_YSZ.NumObjects
                if ~(any(L_YSZ_bottom(:) == i))
                    obj.field(L_YSZ == i) = 7;
                end
            end
%             disp('Isolated phases labelled');
        end
    end
end
