function [ deviceNumbers, FP1, FP2, FP3 ] = ForcePlateNum(vicon)
% Uses the forceplate information to automatically assign force plate
% numbers.
FP1=NaN; FP2=NaN; FP3=NaN;

deviceIDs=vicon.GetDeviceIDs;
IDs=length(deviceIDs);
deviceNumbers=zeros(1,IDs);
for ID=1:IDs
    try
        [name, type, ~, ~, forceplate, ~] = vicon.GetDeviceDetails(deviceIDs(ID));
    catch
        continue
    end
    % If the forceplates are not named, the only way to really match them to
    % their deviceID consistently is to look at the world translation.
    if strcmp(type, 'ForcePlate')
        switch forceplate.WorldT(2)
            case -790 %Force Plate 1
                deviceNumbers(ID)=1;
                FP1=deviceIDs(ID);
            case 300 %Force Plate 2
                deviceNumbers(ID)=2;
                FP2=deviceIDs(ID);
            case 905 %Force Plate 3
                deviceNumbers(ID)=3;
                FP3=deviceIDs(ID);
            otherwise
                warning('Other forceplate orientation detected, ignoring forceplate data.')
                return
        end
    elseif strcmp(name, 'Noraxon Desk Receiver')
        deviceNumbers(ID)=42;
    else
        continue
    end
    
end
disp('Force Data successfully imported...')
end

