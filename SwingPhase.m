function [RightSwingPhase, LeftSwingPhase]=SwingPhase(FootEventCell, RightStancePhase,LeftStancePhase)
%Finds the next foot strike to determine the swing phase
[RStPhases, ~]=size(RightStancePhase);
[LStPhases, ~]=size(LeftStancePhase);
[events,    ~]=size(FootEventCell);

%Stance phases which were a dud should have all 0's
if isempty(RightStancePhase) || sum(RightStancePhase(1,:))==0
    RStPhases=0;
end
if isempty(LeftStancePhase) || sum(LeftStancePhase(1,:))==0
    LStPhases=0;
end

RightSwingPhase=zeros(RStPhases,2);
LeftSwingPhase=zeros(LStPhases,2);

%Go through each stance phase and find the next foot strike
for RStPhase=1:RStPhases
    RightSwingPhase(RStPhase,1)=RightStancePhase(RStPhase,2);
    SwPhaseCheck=RightStancePhase(RStPhase,4);
    while SwPhaseCheck<=events
        if strcmp(FootEventCell{SwPhaseCheck,2},'RFS')
            RightSwingPhase(RStPhase,2)=FootEventCell{SwPhaseCheck, 1};
            break
        else
            SwPhaseCheck=SwPhaseCheck+1;
        end
    end
end
if isempty(RightSwingPhase) || RightSwingPhase(RStPhase,2)<1
    RightSwingPhase=[];
    warning('No right swing phase detected')
end

for LStPhase=1:LStPhases
    LeftSwingPhase(LStPhase,1)=LeftStancePhase(LStPhase,2);
    SwPhaseCheck=LeftStancePhase(LStPhase,4);
    while SwPhaseCheck<=events
        if strcmp(FootEventCell{SwPhaseCheck,2},'LFS')
            LeftSwingPhase(LStPhase,2)=FootEventCell{SwPhaseCheck, 1};
            break
        else
            SwPhaseCheck=SwPhaseCheck+1;
        end
    end
    
end
if isempty(LeftSwingPhase) || LeftSwingPhase(LStPhase,2)<1
    LeftSwingPhase=[];
    warning('No left swing phase detected')
end
end