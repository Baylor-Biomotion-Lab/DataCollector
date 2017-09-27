function [ModelOutput, ModelOutputHelp, FootEventCell, GaitFail]=MaxMin(ModelOutput,ModelOutputHelp, FootEventCell, RightStancePhase, LeftStancePhase, RightSwingPhase, LeftSwingPhase)
%Finds max, min, and ROM over the stance and swing phases. 
%% Max swing/stance phase and ROM
%I will assume only one good swing/stance phase is recorded and that there
%is both a stance and swing phase. Will need to change this.
% [events,~]=size(FootEventCell);
% [FootEventCell, RightStancePhase, LeftStancePhase, RightSwingPhase, LeftSwingPhase]=GaitFinder(FootEventCell, trajectories);
% if isempty(LeftStancePhase) || isempty(RightStancePhase) || isempty(LeftSwingPhase) || isempty(RightSwingPhase)
%     warning('One or more gaits are not correct, please use a trial that has both correct swing and stance phases.')
%     GateFail=1;
%     return
% end
Models=length(ModelOutput);
MaxRightStance=cell(Models,1);              MinRightStance=cell(Models,1);
MaxRightSwing=cell(Models,1);               MinRightSwing=cell(Models,1);
MaxLeftStance=cell(Models,1);               MinLeftStance=cell(Models,1);
MaxLeftSwing=cell(Models,1);                MinLeftSwing=cell(Models,1);

ROMRightStance=cell(Models,1);              ROMLeftStance=cell(Models,1);
ROMRightSwing=cell(Models,1);               ROMLeftSwing=cell(Models,1);


[RSwC,~]=size(RightSwingPhase); [RStC,~]=size(RightStancePhase);
[LSwC,~]=size(LeftSwingPhase);  [LStC,~]=size(LeftStancePhase);

%Brace for some inefficient code, but you could have multiple foot
%strikes/toe offs over the plates, so....

%{
Loop through each stance/swing phase
Loop through each model from ModelOutput
Loop through each component (typically x, y, z) in each model
Find the max min and ROM for each component of each model for each phase

RStC = Right Stance Phase Count
%}
for RSt=1:RStC
    for Model=1:Models
        
        [~,components]=size(ModelOutput{Model});
        MaxRightStance{Model}=zeros(RStC,components);  MinRightStance{Model}=zeros(RStC,components);
        ROMRightStance{Model}=zeros(RStC,components);
        
        for component=1:components
            MaxRightStance{Model}(RSt,component)=max(ModelOutput{Model}(RightStancePhase(1):RightStancePhase(2),component));
            MinRightStance{Model}(RSt,component)=min(ModelOutput{Model}(RightStancePhase(1):RightStancePhase(2),component));
            ROMRightStance{Model}(RSt,component)=abs(MaxRightStance{Model}(RSt,component)-MinRightStance{Model}(RSt,component));
        end
    end
end
for LSt=1:LStC
    for Model=1:Models
        
        [~,components]=size(ModelOutput{Model});
        MaxLeftStance{Model}=zeros(LStC,components);   MinLeftStance{Model}=zeros(LStC,components);
        ROMLeftStance{Model}=zeros(LStC,components);
        
        for component=1:components
            MaxLeftStance{Model}(LSt,component)=max(ModelOutput{Model}(LeftStancePhase(1):LeftStancePhase(2),component));
            MinLeftStance{Model}(LSt,component)=min(ModelOutput{Model}(LeftStancePhase(1):LeftStancePhase(2),component));
            ROMLeftStance{Model}(LSt,component)=abs(MaxLeftStance{Model}(LSt,component)-MinLeftStance{Model}(LSt,component));
        end
    end
end
for RSw=1:RSwC
    for Model=1:Models
        
        [~,components]=size(ModelOutput{Model});
        MaxRightSwing{Model}=zeros(RSwC,components);   MinRightSwing{Model}=zeros(RSwC,components);
        ROMRightSwing{Model}=zeros(RSwC,components);
        
        for component=1:components
            MaxRightSwing{Model}(RSw,component)=max(ModelOutput{Model}(RightSwingPhase(1):RightSwingPhase(2),component));
            MinRightSwing{Model}(RSw,component)=min(ModelOutput{Model}(RightSwingPhase(1):RightSwingPhase(2),component));
            ROMRightSwing{Model}(RSw,component)=abs(MaxRightSwing{Model}(RSw,component)-MinRightSwing{Model}(RSw,component));  
        end
    end
end
for LSw=1:LSwC
    for Model=1:Models
        
        [~,components]=size(ModelOutput{Model});
        MaxLeftSwing{Model}=zeros(LSwC,components);    MinLeftSwing{Model}=zeros(LSwC,components);
        ROMLeftSwing{Model}=zeros(LSwC,components);
        
        for component=1:components
            MaxLeftSwing{Model}(LSw,component)=max(ModelOutput{Model}(LeftSwingPhase(1):LeftSwingPhase(2),component));
            MinLeftSwing{Model}(LSw,component)=min(ModelOutput{Model}(LeftSwingPhase(1):LeftSwingPhase(2),component));
            ROMLeftSwing{Model}(LSw,component)=abs(MaxLeftSwing{Model}(LSw,component)-MinLeftSwing{Model}(LSw,component));
        end
    end
end
MaxMins=...
    [MaxRightStance MinRightStance MaxLeftStance MinLeftStance...
    MaxRightSwing MinRightSwing MaxLeftSwing MinLeftSwing...
    ROMRightStance ROMLeftStance ROMRightSwing ROMLeftSwing];
ModelOutput=[ModelOutput MaxMins];
MaxMinTable=cell2table(MaxMins);
MaxMinTable.Properties.VariableNames={'MaxRightStance' 'MinRightStance'...
    'MaxLeftStance' 'MinLeftStance' 'MaxRightSwing' 'MinRightSwing'...
    'MaxLeftSwing' 'MinLeftSwing' 'ROMRightStance' 'ROMLeftStance'...
    'ROMRightSwing' 'ROMLeftSwing'};
ModelOutputHelp=[ModelOutputHelp, MaxMinTable];
GaitFail=0;
end