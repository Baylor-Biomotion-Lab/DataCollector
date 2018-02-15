function [ EMGData, EMGNames, EMGTable, EMGProcessed ] = GetEMGData( vicon )
%Get EMG data from Vicon
deviceID=vicon.GetDeviceIDs;
[ deviceNumbers, ~, ~, ~ ] = ForcePlateNum(vicon);
EMGdeviceID=deviceID(deviceNumbers==42);
if isempty(EMGdeviceID)
    warning('No EMG data found. Ensure that EMG data was taken, the device ID for the EMG machine is 1, or manually change the device ID.')
    EMGData=NaN;
    EMGNames=NaN;
    EMGTable=NaN;
    return
end

% Get the device output IDs, then loop through and get the given EMG device
% names
[~, ~, ~, deviceOutputIDs, ~, ~] = vicon.GetDeviceDetails(EMGdeviceID);
IDs=length(deviceOutputIDs);
EMGNames=cell(1,IDs);
channelIDs=zeros(1,IDs);
for ID=1:IDs
    [EMGNames{ID}, ~, ~, ~, ~, ~] = vicon.GetDeviceOutputDetails(EMGdeviceID, deviceOutputIDs(ID) );
end

%Get the EMG data
EMGs=length(deviceOutputIDs);
EMGData=cell(1,EMGs);
% EMGProcessed=cell(size(EMGData));
for EMG=1:EMGs
    [EMGData{EMG}, ~, ~]=vicon.GetDeviceChannel(EMGdeviceID,EMG,1);
%     EMGProcessed{EMG}=EMGFilter(EMGData{EMG});
    EMGData{EMG}=EMGData{EMG}';
end

%Format into a nice table
EMGData=EMGData';
EMGNames=EMGNames';
EMGTable=table(EMGNames,EMGData);

 EMGProcessed=NaN;
end

