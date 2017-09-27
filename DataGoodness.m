function DataGoodness( RightStancePhase, LeftStancePhase, LeftFootEvent, RightFootEvent, vicon )
% Check if Stance Phases give any indicators that automatic detection
% should not be used.
[~, TrialName]=vicon.GetTrialName;
%% Right Stance
RStanceW=0; LStanceW=0;

[RStC,~]=size(RightStancePhase);    [LStC,~]=size(LeftStancePhase);
[REvC,~]=size(RightFootEvent);      [LEvC,~]=size(LeftFootEvent);

indicators={'Abnormal number of right stance phases.'; ... 
            'Abnormally short right stance phases.';...
            'The majority of right foot events are on the force plates.';...
            'Abnormal number of left stance phases.';...
            'The trial is likely not suited to stance/swing phases.';... 
            'Abnormally short left stance phases.';...
            'The majority of left foot events are on the force plates.';};
            
% Is there an abnormal of stance phases?
if RStC>3
    RStanceW=RStanceW+1;
end

% Are the stance phases abnormally short?
RightStancePhase=[RightStancePhase zeros(RStC,1)];
RdiffC=0;
for Rdiff=1:RStC
    RightStancePhase(Rdiff,4)=RightStancePhase(Rdiff,2)-RightStancePhase(Rdiff,1);
    if RightStancePhase(Rdiff,4)<20
        RdiffC=RdiffC+1;
    end
end
if RdiffC>0.5*RStC
    RStanceW=RStanceW+1;
    
end

% Are the majority of the foot events on the force plate?
REventinPlate=0;
for EventLoc=1:REvC
    if RightFootEvent{EventLoc,4}>=1
        REventinPlate=REventinPlate+1;
    end
end

if REventinPlate>0.5*REvC
    RStanceW=RStanceW+1;
end

% Is the trial not suited to stance/swing phase?
expression={'walk', 'run', 'stair', 'Run', 'Walk', 'Stair'};
found=0; word=1;
while ~found
    if word>length(expression)
        found=0;
        break
    end
    Presence=strfind(TrialName,expression{word});
    if ~isempty(Presence)
        found=1;
    else
        word=word+1;
    end
end

if found==0
    RStanceW=RStanceW+1;
    LStanceW=LStanceW+1;
end

%% Left Stance
if LStC>3
    LStanceW=LStanceW+1;
end
LeftStancePhase=[LeftStancePhase zeros(LStC,1)];

LdiffC=0;
for Rdiff=1:LStC
    LeftStancePhase(Rdiff,4)=LeftStancePhase(Rdiff,2)-LeftStancePhase(Rdiff,1);
    if LeftStancePhase(Rdiff,4)<20
        LdiffC=LdiffC+1;
    end
end

if LdiffC>0.5*LStC
    LStanceW=LStanceW+1;
end

LEventinPlate=0;
for EventLoc=1:LEvC
    if LeftFootEvent{EventLoc,4}>=1
        LEventinPlate=LEventinPlate+1;
    end
end

if REventinPlate>0.5*REvC
    LStanceW=LStanceW+1;
end
if RStanceW>=2 || LStanceW>=2
    warning('There is strong indication that this trial should not be used for automatic gait event detection.')
end
end

