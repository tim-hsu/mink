function fieldOutput = add_infiltrates(fieldInput, seedProbability, kernelRadius)
%% Initiate seeds at solid surfaces
[X,Y,Z] = size(fieldInput);
fieldSeeds = uint8(zeros(X,Y,Z));
for x = 2:X-1
    for y = 2:Y-1
        for z = 2:Z-1          
            phase              = fieldInput(x,  y,z  );
            neighborPhaseUp    = fieldInput(x,  y,z+1);
            neighborPhaseDown  = fieldInput(x,  y,z-1);
            neighborPhaseLeft  = fieldInput(x+1,y,z  );
            neighborPhaseRight = fieldInput(x-1,y,z  );
            neighborPhaseFront = fieldInput(x,  y+1,z);
            neighborPhaseBack  = fieldInput(x,  y-1,z);
            neighborPhases     = [neighborPhaseUp 
                                  neighborPhaseDown
                                  neighborPhaseLeft
                                  neighborPhaseRight
                                  neighborPhaseFront
                                  neighborPhaseBack];
            
            if (phase==2 || phase==3) && ismember(1, neighborPhases)
                if rand() < seedProbability
                    fieldSeeds(x,y,z) = 1;
                end
            end
        end
    end
end


%% Dilate seeds so they become nano-infiltrates
se = strel('sphere', kernelRadius);
fieldInfiltrates = imdilate(fieldSeeds, se);

fieldSeeded = fieldInput;
fieldSeeded(fieldSeeds==1) = 10;

fieldInfiltrated = fieldInput;
fieldInfiltrated(fieldInfiltrates==1) = 10;


%% Add infiltrates on top of original microstructure
fieldOutput = fieldInput;
fieldOutput(fieldInfiltrates==1) = 2;
fieldOutput(fieldInput==3) = 3;