function [ RightStancePhase, LeftStancePhase , LeftFootEvent, RightFootEvent] = StancePhase( FootEventCell, events )
% Finds when the stance phase of the gait cycle is over the force plates.

%Note: Since the foot event cells will be pretty small, we can't/won't
%preallocate because we don't know how big they will be. This will not
%sacrifice much speed as well.
RCount=1; LCount=1;
RightFootEvent=cell(1);
LeftFootEvent=cell(1);
for event=1:events
    if FootEventCell{event,3}=='R' && FootEventCell{event,6}>0
        RightFootEvent{RCount,1}=FootEventCell{event,1}; %#ok<*AGROW>
        RightFootEvent{RCount,2}=FootEventCell{event,2};
        RightFootEvent{RCount,3}=FootEventCell{event,4};
        RightFootEvent{RCount,4}=FootEventCell{event,6};
        RightFootEvent{RCount,5}=event;
        RCount=RCount+1;
    elseif FootEventCell{event,3}=='L' && FootEventCell{event,6}>0
        LeftFootEvent{LCount,1}=FootEventCell{event,1};
        LeftFootEvent{LCount,2}=FootEventCell{event,2};
        LeftFootEvent{LCount,3}=FootEventCell{event,4};
        LeftFootEvent{LCount,4}=FootEventCell{event,6};
        LeftFootEvent{LCount,5}=event;
        LCount=LCount+1;
    end
end
[LEvents,~]=size(LeftFootEvent);
[REvents,~]=size(RightFootEvent);
if isempty(LeftFootEvent{1})
    LEvents=0;
    LeftStancePhase=[];
end
if isempty(RightFootEvent{1})
    REvents=0;
    RightStancePhase=[];
end
RStancePhaseStart=1;
LStancePhaseStart=1;
%Check to see if a footstrike is followed by a toe off on the same plate
for LEvent=1:LEvents
    switch LeftFootEvent{LEvent, 3}
        case 'S'
            if LEvents<2 || (LEvent+1>LEvents)
                LeftStancePhase(LStancePhaseStart,1:4)=0;
                break
            elseif strcmp(LeftFootEvent(LEvent+1,3),'O') && (LeftFootEvent{LEvent,4}==LeftFootEvent{LEvent+1,4})
                LeftStancePhase(LStancePhaseStart,1)=LeftFootEvent{LEvent,1};
                LeftStancePhase(LStancePhaseStart,2)=LeftFootEvent{LEvent+1,1};
                LeftStancePhase(LStancePhaseStart,3)=LeftFootEvent{LEvent,4};
                LeftStancePhase(LStancePhaseStart,4)=LeftFootEvent{LEvent+1,5};
                LStancePhaseStart=LStancePhaseStart+1;
            else
                LeftStancePhase(LStancePhaseStart,1:4)=0;
                LStancePhaseStart=LStancePhaseStart+1;
            end
        case 'O'
            if LEvents<2
                LeftStancePhase=0;
                break
            end
    end
end

for REvent=1:REvents
    switch RightFootEvent{REvent, 3}
        case 'S'
            if REvents<2 || (REvent+1>REvents)
                RightStancePhase(RStancePhaseStart,(1:4))=0;
                break
            elseif strcmp(RightFootEvent(REvent+1,3),'O') && (RightFootEvent{REvent,4}==RightFootEvent{REvent+1,4})
                RightStancePhase(RStancePhaseStart,1)=RightFootEvent{REvent,1};
                RightStancePhase(RStancePhaseStart,2)=RightFootEvent{REvent+1,1};
                RightStancePhase(RStancePhaseStart,3)=RightFootEvent{REvent,4};
                RightStancePhase(RStancePhaseStart,4)=RightFootEvent{REvent+1,5};
                RStancePhaseStart=RStancePhaseStart+1;
            else
                RightStancePhase(RStancePhaseStart,(1:4))=0;
                RStancePhaseStart=RStancePhaseStart+1;
                
            end
            
        case 'O'
            if REvents<2
                RightStancePhase=0;
                break
            end
    end
end

% Get rid of all 0
[RStC,~]=size(RightStancePhase);
[LStC,~]=size(LeftStancePhase);

for RSt=RStC:-1:1
    if sum(RightStancePhase(RSt,:)) == 0
        RightStancePhase(RSt,:)=[];
    end
end
for LSt=LStC:-1:1
    if sum(LeftStancePhase(LSt,:))== 0
        LeftStancePhase(LSt,:)=[];
    end
end
end
