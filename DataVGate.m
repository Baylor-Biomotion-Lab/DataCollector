%% Plot Data Against % of Gait
[RSwC,~]=size(RightSwingPhase); [RStC,~]=size(RightStancePhase);
[LSwC,~]=size(LeftSwingPhase);  [LStC,~]=size(LeftStancePhase);

RSwL=length(RightSwingPhase(1,1):RightSwingPhase(1,2));
RStL=length(RightStancePhase(1,1):RightStancePhase(1,2));
LSwL=length(LeftSwingPhase(1,1):LeftSwingPhase(1,2));
LStL=length(LeftStancePhase(1,1):LeftStancePhase(1,2));
LStrL=length(LeftStride(1,1):LeftStride(1,2));
RStrL=length(RightStride(1,1):RightStride(1,2));

x=1;    y=2;    z=3;

%Input desired direction
Direction=x;

switch Direction
    case 1
        DirectionName='X';
    case 2
        DirectionName='Y';
    case 3
        DirectionName='Z';
end

if (RSwC | RStC | LSwC | LStC) > 1
    warning('Revise script')
end
%Input the name and number of corresponding object found in ModelOutputHelp
%See VarNamesHelp for more details
RHipAngles=13;
targetVariable=RHipAngles;
targetVariableName=ModelOutputHelp{targetVariable,2};

%Get data in the desired direction over stances and strides
RSwX=(1:RSwL)/RSwL*100;     RSwY=ModelOutput{targetVariable}(RightSwingPhase(1,1):RightSwingPhase(1,2),Direction); 
RStX=(1:RStL)/RStL*100;     RStY=ModelOutput{targetVariable}(RightStancePhase(1,1):RightStancePhase(1,2),Direction);
RStrX=(1:RStrL)/RStrL*100;  RStrY=ModelOutput{targetVariable}(RightStride(1,1):RightStride(1,2),Direction);
LSwX=(1:LSwL)/LSwL*100;     LSwY=ModelOutput{targetVariable}(LeftSwingPhase(1,1):LeftSwingPhase(1,2),Direction);
LStX=(1:LStL)/LStL*100;     LStY=ModelOutput{targetVariable}(LeftStancePhase(1,1):LeftStancePhase(1,2),Direction);
LStrX=(1:LStrL)/LStrL*100;  LStrY=ModelOutput{targetVariable}(LeftStride(1,1):LeftStride(1,2),Direction);


figure(1)
plotTitle=sprintf('%s vs. Percentage of Right Swing Phase in %s Direction', targetVariableName{1}, DirectionName);
plot(RSwX,RSwY)
title(plotTitle)
xlabel('Percentage of Right Swing Phase')
ylabel(targetVariableName{1})

figure(2)
plotTitle=sprintf('%s vs. Percentage of Right Stance Phase in %s Direction', targetVariableName{1}, DirectionName);
plot(RStX,RStY)
title(plotTitle)
xlabel('Percentage of Right Stance Phase')
ylabel(targetVariableName{1})

figure(3)
plotTitle=sprintf('%s vs. Percentage of Left Swing Phase in %s Direction', targetVariableName{1}, DirectionName);
plot(LSwX,LSwY)
title(plotTitle)
xlabel('Percentage of Left Swing Phase')
ylabel(targetVariableName{1})

figure(4)
plotTitle=sprintf('%s vs. Percentage of Left Stance Phase in %s Direction', targetVariableName{1}, DirectionName);
plot(LStX,LStY)
title(plotTitle)
xlabel('Percentage of Left Stance Phase')
ylabel(targetVariableName{1})

figure(5)
plotTitle=sprintf('%s vs. Percentage of Right Stride in %s Direction', targetVariableName{1}, DirectionName);
plot(RStrX,RStrY)
title(plotTitle)
xlabel('Percentage of Right Stride')
ylabel(targetVariableName{1})

figure(6)
plotTitle=sprintf('%s vs. Percentage of Left Stride in %s Direction', targetVariableName{1}, DirectionName);
plot(LStrX,LStrY)
title(plotTitle)
xlabel('Percentage of Left Stride')
ylabel(targetVariableName{1})

