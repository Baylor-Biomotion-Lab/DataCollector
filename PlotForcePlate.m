function PlotForcePlate(direction, plateNum, ForcePlateData, FootEventCell, TrialName)
% Plots the force plate in desired direction. Also plots foot events and
% provides a useful 
% PlotForcePlate('Z',2,ForcePlateData,FootEventCell,TrialName)
clf
directionString=direction;
switch direction
    case 'X'
        direction=3;
    case 'Y'
        direction=4;
    case 'Z'
        direction=5;
    otherwise
        warning('Direction %s not recognized \n', direction)
end
if plateNum==2
    forcedata=ForcePlateData.Plate2.Force{:,direction};
elseif plateNum==3
    forcedata=ForcePlateData.Plate3.Force{:,direction};
else
    warning('Plate Number %g not recognized \n', plateNum)
end

x=linspace(1, length(forcedata)/10, length(forcedata));
plot(x,forcedata,'g', 'DisplayName','Force');
plotT=sprintf('Force in %s Direction for %s Force Plate %g',directionString, TrialName, plateNum);
title(plotT,'interpreter','none')
hold on

for i=1:length(FootEventCell)
    FEvent=FootEventCell{i,2};
    switch FEvent
        case 'LFS'
            plot(x(FootEventCell{i,1}*10),forcedata(FootEventCell{i,1}*10),'b^','MarkerSize',10, 'DisplayName','LFS')
        case 'LFO'
            plot(x(FootEventCell{i,1}*10),forcedata(FootEventCell{i,1}*10),'b*','MarkerSize',10, 'DisplayName','LFO')
        case 'RFS'
            plot(x(FootEventCell{i,1}*10),forcedata(FootEventCell{i,1}*10),'r^','MarkerSize',10, 'DisplayName','RFS')
        case 'RFO'
            plot(x(FootEventCell{i,1}*10),forcedata(FootEventCell{i,1}*10),'r*','MarkerSize',10, 'DisplayName','RFO')
    end
end
legend('show')
end

