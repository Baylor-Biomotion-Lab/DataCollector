function [RightStride, LeftStride]=  StrideFinder(RightSwingPhase, LeftSwingPhase, RightStancePhase, LeftStancePhase, trajectories, vicon, S)
%Finds the left and right stride frames on the forceplate
%% Find Stride Times
FrameRate=vicon.GetFrameRate;
[RSwC,~]=size(RightSwingPhase); [RStC,~]=size(RightStancePhase);
[LSwC,~]=size(LeftSwingPhase);  [LStC,~]=size(LeftStancePhase);

RStrSize=max([RStC RSwC]);
LStrSize=max([LStC LSwC]);

RightStride=zeros(RStrSize,4);
LeftStride=zeros(LStrSize,4);

if isempty(RightSwingPhase) || isempty(RightStancePhase)
    RStrSize=0;
    RightStride=[];
end

if isempty(LeftSwingPhase) || isempty(LeftStancePhase)
    LStrSize=0;
    LeftStride=[];
end


MarkerNames=vicon.GetMarkerNames(S)';
LHEE=find(strcmp('LHEE',MarkerNames));
RHEE=find(strcmp('RHEE',MarkerNames));


for RStr=1:RStrSize
    RightStride(RStr,1)=RightStancePhase(RStr,1);
    RightStride(RStr,2)=RightSwingPhase(RStr,2);
    RightStride(RStr,3)=(RightStride(RStr,2)-RightStride(RStr,1))/FrameRate;
    x2=trajectories{RHEE}{RightStride(RStr,2),1};
    x1=trajectories{RHEE}{RightStride(RStr,1),1};
    y2=trajectories{RHEE}{RightStride(RStr,2),2};
    y1=trajectories{RHEE}{RightStride(RStr,1),2};
    RightStride(RStr,4)=sqrt((x2-x1)^2+(y2-y1)^2); %Distance in mm
end

for LStr=1:LStrSize
    LeftStride(LStr,1)=LeftStancePhase(LStr,1);
    LeftStride(LStr,2)=LeftSwingPhase(LStr,2);
    LeftStride(LStr,3)=(LeftStride(LStr,2)-LeftStride(LStr,1))/FrameRate;
    x2=trajectories{LHEE}{LeftStride(LStr,2),1};
    x1=trajectories{LHEE}{LeftStride(LStr,1),1};
    y2=trajectories{LHEE}{LeftStride(LStr,2),2};
    y1=trajectories{LHEE}{LeftStride(LStr,1),2};
    LeftStride(LStr,4)=sqrt((x2-x1)^2+(y2-y1)^2); %Distance in mm
end
end