function [ TrialInfo, SubjectParams ] = GetVitals( vicon, FD, S )
% Gets a bunch of little things that could be important and organizes them
% into a structure.
% If you are adding to this structure, ensure that is full of things that
% each subject will have.

% Set all values to NaN or 0 in case something goes wrong.
TrialName=NaN;
s=NaN;
e=NaN;
FPCount=0;
CameraFrameRate=NaN;
FPRate=NaN;

% Use ViconNexus class to find pertinent values
[s,e]=vicon.GetTrialRegionOfInterest;
CameraFrameRate=vicon.GetFrameRate;
[~,TrialName]=vicon.GetTrialName;
IDs=vicon.GetDeviceIDs();
Version=2.2;
FPCount=0;

% Find how many force plates are active
for ID=1:length(IDs)
    try
        [~, type, rate, ~, ~, ~] = vicon.GetDeviceDetails( IDs(ID) );
        if strcmp(type,'ForcePlate')
            FPCount=FPCount+1;
            FPRate=rate;
        end
    catch
        warning('Cannot get device details \n')
    end
    
end



TrialInfo.DataCollectorVersion=Version;
TrialInfo.TrialName=TrialName;
TrialInfo.StartTrial=s;
TrialInfo.EndTrial=e;
TrialInfo.ForcePlates=FPCount;
TrialInfo.CameraFrameRate=CameraFrameRate;
TrialInfo.ForcePlateFrameRate=FPRate;
TrialInfo.FootDominance=FD;

%% Subject Params
paramNames=vicon.GetSubjectParamNames(S);
params=length(paramNames);
values=cell(params,1);
units=cell(params,1);

for param=1:params
    [value,unit,~,~,~]=vicon.GetSubjectParamDetails(S,paramNames{param});
    values{param}=value; units{param}=unit;
end

SubjectParams=[paramNames', values, units];

