function [ ROMs ] = GetROM(ModelOutput)
%% Generate ROM
LHipAngles=ModelOutput{12};         RHipAngles=ModelOutput{13};
LKneeAngles=ModelOutput{14};        RKneeAngles=ModelOutput{15};
LAnkleAngles=ModelOutput{16};       RAnkleAngles=ModelOutput{17};
LThoraxAngles=ModelOutput{21};      RThoraxAngles=ModelOutput{24};

LandmarkCell={LHipAngles; RHipAngles; LKneeAngles; RKneeAngles; LAnkleAngles;...
    RAnkleAngles; LThoraxAngles; RThoraxAngles};
%% Find and Replace 0's
%Loop through LandmarkCell, then the directions, then the angles:
Landmarks=length(LandmarkCell);
Angles=length(LandmarkCell{1});
Directions=3;
for Landmark=1:Landmarks
    for Direction=1:Directions
        for Angle=1:Angles
            if LandmarkCell{Landmark}(Angle,Direction)==0
                LandmarkCell{Landmark}(Angle,Direction)=NaN;
            end
        end
    end
end
%% Calculate ROM

%I think this part could easily be non-hardcoded to incorporate any
%variable, but not multiple variables.

%Min
LHipMinX=min(LandmarkCell{1}(:,1));   RHipMinX=min(LandmarkCell{2}(:,1));
LHipMinY=min(LandmarkCell{1}(:,2));   RHipMinY=min(LandmarkCell{2}(:,2));
LHipMinZ=min(LandmarkCell{1}(:,3));   RHipMinZ=min(LandmarkCell{2}(:,3));

LKneeMinX=min(LandmarkCell{3}(:,1));  RKneeMinX=min(LandmarkCell{4}(:,1));
LKneeMinY=min(LandmarkCell{3}(:,2));  RKneeMinY=min(LandmarkCell{4}(:,2));
LKneeMinZ=min(LandmarkCell{3}(:,3));  RKneeMinZ=min(LandmarkCell{4}(:,3));

LAnkleMinX=min(LandmarkCell{5}(:,1)); RAnkleMinX=min(LandmarkCell{6}(:,1));
LAnkleMinY=min(LandmarkCell{5}(:,2)); RAnkleMinY=min(LandmarkCell{6}(:,2));
LAnkleMinZ=min(LandmarkCell{5}(:,3)); RAnkleMinZ=min(LandmarkCell{6}(:,3));

LThMinX=min(LandmarkCell{7}(:,1));    RThMinX=min(LandmarkCell{8}(:,1));
LThMinY=min(LandmarkCell{7}(:,2));    RThMinY=min(LandmarkCell{8}(:,2));
LThMinZ=min(LandmarkCell{7}(:,3));    RThMinZ=min(LandmarkCell{8}(:,3));

%Max
LHipMaxX=max(LandmarkCell{1}(:,1));   RHipMaxX=max(LandmarkCell{2}(:,1));
LHipMaxY=max(LandmarkCell{1}(:,2));   RHipMaxY=max(LandmarkCell{2}(:,2));
LHipMaxZ=max(LandmarkCell{1}(:,3));   RHipMaxZ=max(LandmarkCell{2}(:,3));

LKneeMaxX=max(LandmarkCell{3}(:,1));  RKneeMaxX=max(LandmarkCell{4}(:,1));
LKneeMaxY=max(LandmarkCell{3}(:,2));  RKneeMaxY=max(LandmarkCell{4}(:,2));
LKneeMaxZ=max(LandmarkCell{3}(:,3));  RKneeMaxZ=max(LandmarkCell{4}(:,3));

LAnkleMaxX=max(LandmarkCell{5}(:,1)); RAnkleMaxX=max(LandmarkCell{6}(:,1));
LAnkleMaxY=max(LandmarkCell{5}(:,2)); RAnkleMaxY=max(LandmarkCell{6}(:,2));
LAnkleMaxZ=max(LandmarkCell{5}(:,3)); RAnkleMaxZ=max(LandmarkCell{6}(:,3));

LThMaxX=max(LandmarkCell{7}(:,1));    RThMaxX=max(LandmarkCell{8}(:,1));
LThMaxY=max(LandmarkCell{7}(:,2));    RThMaxY=max(LandmarkCell{8}(:,2));
LThMaxZ=max(LandmarkCell{7}(:,3));    RThMaxZ=max(LandmarkCell{8}(:,3));

%ROM
LHipROMX=abs(LHipMaxX-LHipMinX); RHipROMX=abs(RHipMaxX-RHipMinX);
LHipROMY=abs(LHipMaxY-LHipMinY); RHipROMY=abs(RHipMaxY-RHipMinY);
LHipROMZ=abs(LHipMaxZ-LHipMinZ); RHipROMZ=abs(RHipMaxZ-RHipMinZ);

LKneeROMX=abs(LKneeMaxX-LKneeMinX); RKneeROMX=abs(RKneeMaxX-RKneeMinX);
LKneeROMY=abs(LKneeMaxY-LKneeMinY); RKneeROMY=abs(RKneeMaxY-RKneeMinY);
LKneeROMZ=abs(LKneeMaxZ-LKneeMinZ); RKneeROMZ=abs(RKneeMaxZ-RKneeMinZ);

LAnkleROMX=abs(LAnkleMaxX-LAnkleMinX); RAnkleROMX=abs(RAnkleMaxX-RAnkleMinX);
LAnkleROMY=abs(LAnkleMaxY-LAnkleMinY); RAnkleROMY=abs(RAnkleMaxY-RAnkleMinY);
LAnkleROMZ=abs(LAnkleMaxZ-LAnkleMinZ); RAnkleROMZ=abs(RAnkleMaxZ-RAnkleMinZ);

LThROMX=abs(LThMaxX-LThMinX); RThROMX=abs(RThMaxX-RThMinX);
LThROMY=abs(LThMaxY-LThMinY); RThROMY=abs(RThMaxY-RThMinY);
LThROMZ=abs(LThMaxZ-LThMinZ); RThROMZ=abs(RThMaxZ-RThMinZ);
%% Generate Table
ROMs=[    LHipROMX, LHipROMY, LHipROMZ, LHipMaxX, LHipMaxY, LHipMaxZ, LHipMinX, LHipMinY, LHipMinZ;...
          LKneeROMX, LKneeROMY, LKneeROMZ, LKneeMaxX, LKneeMaxY, LKneeMaxZ, LKneeMinX, LKneeMinY, LKneeMinZ;...
          LAnkleROMX, LAnkleROMY, LAnkleROMZ, LAnkleMaxX, LAnkleMaxY, LAnkleMaxZ, LAnkleMinX, LAnkleMinY, LAnkleMinZ;...
          LThROMX, LThROMY, LThROMZ, LThMaxX, LThMaxY, LThMaxZ, LThMinX, LThMinY, LThMinZ;...
          RHipROMX, RHipROMY, RHipROMZ, RHipMaxX, RHipMaxY, RHipMaxZ, RHipMinX, RHipMinY, RHipMinZ;...
          RKneeROMX, RKneeROMY, RKneeROMZ, RKneeMaxX, RKneeMaxY, RKneeMaxZ, RKneeMinX, RKneeMinY, RKneeMinZ;...
          RAnkleROMX, RAnkleROMY, RAnkleROMZ, RAnkleMaxX, RAnkleMaxY, RAnkleMaxZ, RAnkleMinX, RAnkleMinY, RAnkleMinZ;...
          RThROMX, RThROMY, RThROMZ,  RThMaxX, RThMaxY, RThMaxZ, RThMinX, RThMinY, RThMinZ; 
          ];
ROMs=array2table(ROMs);
ROMs.Properties.VariableNames = {'X' 'Y' 'Z' 'MinX' 'MinY' 'MinZ' 'MaxX' 'MaxY' 'MaxZ'};
ROMs.Properties.RowNames={'LHip' 'LKnee' 'LAnkle' 'LThorax' ...
                          'RHip' 'RKnee' 'RAnkle' 'RThorax'};
end

