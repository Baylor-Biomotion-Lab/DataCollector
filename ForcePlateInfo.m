function [ ForcePlateData, FPD, deviceNumbers] = ForcePlateInfo( vicon )
% Get force plate information from Vicon.

% deviceNames=vicon.GetDeviceNames;
% deviceID=zeros(1,length(deviceNames));
% for ID=1:length(deviceID)
%     deviceID(ID) = vicon.GetDeviceIDFromName(deviceNames{ID});
% end
% if isempty(deviceID)
%     warning('No devices named')
% end

[ deviceNumbers, FP1, FP2, FP3 ] = ForcePlateNum(vicon);
if isnan(FP1) && isnan(FP2) && isnan(FP3)
    ForcePlateData=NaN;
    FPD = NaN;
    return
end


%Appropriate deviceOutputIDs
Force=1;
Moment=2;
Center=3;

%ChannelIDs
x=1;
y=2;
z=3;

%Get data from the force plates using the key above
%Error checking for force plate data should be revised in case another
%forceplate orientation is used.

% FPD will be a cell, ForcePlateData will be a structure that is
% likely never used.
FPD=cell(3,1);

%Force Plate 1
if ~isnan(FP1)
    FPD{1}=cell(3,1);
    
    %[Blahh, ~, ~] = vicon.GetDeviceChannel(FP, deviceOutputID, ChannelID)
    [FxFP1, ~, ~] = vicon.GetDeviceChannel( FP1, Force, x );
    [FyFP1, ~, ~] = vicon.GetDeviceChannel( FP1, Force, y );
    [FzFP1, ~, ~] = vicon.GetDeviceChannel( FP1, Force, z );
    FPD{1}{1}=[FxFP1', FyFP1', FzFP1'];
    
    [MxFP1, ~, ~] = vicon.GetDeviceChannel( FP1, Moment, x );
    [MyFP1, ~, ~] = vicon.GetDeviceChannel( FP1, Moment, y );
    [MzFP1, ~, ~] = vicon.GetDeviceChannel( FP1, Moment, z );
    FPD{1}{2}=[MxFP1', MyFP1', MzFP1'];
    
    [CxFP1, ~, ~] = vicon.GetDeviceChannel( FP1, Center, x );
    [CyFP1, ~, ~] = vicon.GetDeviceChannel( FP1, Center, y );
    [CzFP1, ~, ~] = vicon.GetDeviceChannel( FP1, Center, z );
    % Correct for forceplate location
    CxFP1 = CxFP1 + 200;
    CyFP1 = CyFP1 - 790;
    FPD{1}{3}=[CxFP1', CyFP1', CzFP1'];
else
    FPD{1}=NaN;
end
%Force Plate 2
if ~isnan(FP2)
    FPD{2}=cell(3,1);
    
    [FxFP2, ~, ~] = vicon.GetDeviceChannel( FP2, Force, x );
    [FyFP2, ~, ~] = vicon.GetDeviceChannel( FP2, Force, y );
    [FzFP2, ~, ~] = vicon.GetDeviceChannel( FP2, Force, z );
    FPD{2}{1}=[FxFP2', FyFP2', FzFP2'];
    
    [MxFP2, ~, ~] = vicon.GetDeviceChannel( FP2, Moment, x );
    [MyFP2, ~, ~] = vicon.GetDeviceChannel( FP2, Moment, y );
    [MzFP2, ~, ~] = vicon.GetDeviceChannel( FP2, Moment, z );
    FPD{2}{2}=[MxFP2', MyFP2', MzFP2'];
    
    [CxFP2, ~, ~] = vicon.GetDeviceChannel( FP2, Center, x );
    [CyFP2, ~, ~] = vicon.GetDeviceChannel( FP2, Center, y );
    [CzFP2, ~, ~] = vicon.GetDeviceChannel( FP2, Center, z );
    % Correct for forceplate location
    CxFP2 = CxFP2 + 200;
    CyFP2 = CyFP2 + 300;
    FPD{2}{3}=[CxFP2', CyFP2', CzFP2'];
else
    FPD{2}=NaN;
end
%Force Plate 3
if ~isnan(FP3)
    FPD{3}=cell(3,1);
    
    [FxFP3, ~, ~] = vicon.GetDeviceChannel( FP3, Force, x );
    [FyFP3, ~, ~] = vicon.GetDeviceChannel( FP3, Force, y );
    [FzFP3, ~, ~] = vicon.GetDeviceChannel( FP3, Force, z );
    FPD{3}{1}=[FxFP3', FyFP3', FzFP3'];
    
    [MxFP3, ~, ~] = vicon.GetDeviceChannel( FP3, Moment, x );
    [MyFP3, ~, ~] = vicon.GetDeviceChannel( FP3, Moment, y );
    [MzFP3, ~, ~] = vicon.GetDeviceChannel( FP3, Moment, z );
    FPD{3}{2}=[MxFP3', MyFP3', MzFP3'];
    
    [CxFP3, ~, ~] = vicon.GetDeviceChannel( FP3, Center, x );
    [CyFP3, ~, ~] = vicon.GetDeviceChannel( FP3, Center, y );
    [CzFP3, ~, ~] = vicon.GetDeviceChannel( FP3, Center, z );
    % Correct for forceplate location
    CxFP3 = CxFP3 + 200;
    CyFP3 = CyFP3 + 905;
    FPD{3}{3}=[CxFP3', CyFP3', CzFP3'];
else
    FPD{3}=NaN;
end
forceNames={'Frame'; 'Subframe';'Fx_N';'Fy_N';'Fz_N'};
momentNames={'Frame'; 'Subframe';'Mx_N_mm';'My_N_mm';'Mz_N_mm'};
centerNames={'Frame'; 'Subframe';'Cx_mm';'Cy_mm';'Cz_mm'};

% Overly complicated way of getting the frames and subframes correct
if ~isnan(FP2)
    subFrameLen=length(FxFP2);
elseif ~isnan(FP1)
    subFrameLen=length(FxFP1);
else
    subFrameLen=length(FxFP3);
end

subFrame=zeros(1,subFrameLen); frame=zeros(1,subFrameLen);
currentSubFrame=-1; currentFrame=0;

for subframe=1:subFrameLen
    if currentSubFrame>=0 && currentSubFrame<9
        currentSubFrame=currentSubFrame+1;
    else
        currentSubFrame=0;
        currentFrame=currentFrame+1;
    end
    subFrame(subframe)=currentSubFrame;
    frame(subframe)=currentFrame;
end

% Put data into a table
if ~isnan(FP1)
    ForceTableFP1 =table(frame',subFrame',FxFP1',FyFP1',FzFP1','VariableNames',forceNames);
    MomentTableFP1=table(frame',subFrame',MxFP1',MyFP1',MzFP1','VariableNames',momentNames);
    CenterTableFP1=table(frame',subFrame',CxFP1',CyFP1',CzFP1','VariableNames',centerNames);
end

if ~isnan(FP2)
    ForceTableFP2 =table(frame',subFrame',FxFP2',FyFP2',FzFP2','VariableNames',forceNames);
    MomentTableFP2=table(frame',subFrame',MxFP2',MyFP2',MzFP2','VariableNames',momentNames);
    CenterTableFP2=table(frame',subFrame',CxFP2',CyFP2',CzFP2','VariableNames',centerNames);
end

if ~isnan(FP3)
    ForceTableFP3 =table(frame',subFrame',FxFP3',FyFP3',FzFP3','VariableNames',forceNames);
    MomentTableFP3=table(frame',subFrame',MxFP3',MyFP3',MzFP3','VariableNames',momentNames);
    CenterTableFP3=table(frame',subFrame',CxFP3',CyFP3',CzFP3','VariableNames',centerNames);
end

% Put data into a structure
% Man, this is just horrible. Why did I do it like this?

if ~isnan(FP1)
    ForcePlate1(1).Force=ForceTableFP1;
    ForcePlate1(1).Moment=MomentTableFP1;
    ForcePlate1(1).Center=CenterTableFP1;
end

if ~isnan(FP2)
    ForcePlate2(1).Force=ForceTableFP2;
    ForcePlate2(1).Moment=MomentTableFP2;
    ForcePlate2(1).Center=CenterTableFP2;
end

if ~isnan(FP3)
    ForcePlate3(1).Force=ForceTableFP3;
    ForcePlate3(1).Moment=MomentTableFP3;
    ForcePlate3(1).Center=CenterTableFP3;
end

if ~isnan(FP1)
    ForcePlateData(1).Plate1=ForcePlate1;
else
    ForcePlateData(1).Plate1=NaN;
end

if ~isnan(FP2)
    ForcePlateData(1).Plate2=ForcePlate2;
else
    ForcePlateData(1).Plate2=NaN;
end

if ~isnan(FP3)
    ForcePlateData(1).Plate3=ForcePlate3;
else
    ForcePlateData(1).Plate3=NaN;
end

end