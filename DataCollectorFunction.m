function DataCollectorFunction
% Main script for collecting and analyzing data from Vicon
clearvars -Except FileLocation Errors errorCount ToPull
%% User Input
ModifyFootEvents=0; %Set to 1 if you want to put in your own foot events
saveFile='H:\Research\MATLAB\VAC\CollectedData\RunningStudy2';
%% Model Output Information
vicon=ViconNexus(); %for more info put doc ViconNexus into command line
vicon.Connect()
S = vicon.GetSubjectNames();
S=S{1};
Output=vicon.GetModelOutputNames(S);
names=length(Output); data=cell(1,names); group=cell(1,names);
components=cell(1,names); types=cell(1,names);
for name=1:names
    data{name}=vicon.GetModelOutput(S,Output{name});
    [group{name}, components{name}, types{name}]=...
        vicon.GetModelOutputDetails(S,Output{name});
    data{name}=data{name}';
end
group=group'; components=components'; types=types';
ModelOutputHelp=table((1:length(Output))',Output', data', group, components, types);
ModelOutput=data';
disp('Model data successfuly imported...')
%% Force Plate Information
[ ForcePlateData, FPD, ~]=ForcePlateInfo(vicon);
disp('Force Data successfully imported...')
%% EMG Data
try
    [ EMGData, EMGNames, EMGTable, EMGProcessed ] = GetEMGData( vicon );
    disp('EMG Data successfully imported...')
catch
    warning('EMG data not succesfully imported...')
    EMGTable=NaN;
    EMGProcessed=NaN;
end
%% Trajectory Information
[trajectories, velocities, accelerations, MarkerHelp]=TrajectoryInfo(vicon, S);
disp('Trajectories successfully imported...')
%% Foot Events
% Run a pipeline which runs "Autocorrelate Events" and "Detect Events From Forceplate" to get all foot marker
% data
[FootEventStruct, FootEventCell]=GetFootEvents( vicon, S, ModifyFootEvents );

%% Gait Analysis
[FootEventCell, RightStancePhase, LeftStancePhase, RightSwingPhase, LeftSwingPhase]=GaitFinder(FootEventCell, trajectories, vicon, S);
disp('Gaits successfully found...')
[ModelOutput, ModelOutputHelp, FootEventCell, GaitFail]=MaxMin(ModelOutput,ModelOutputHelp, FootEventCell, RightStancePhase, LeftStancePhase, RightSwingPhase, LeftSwingPhase);
disp('Data successfully analyzed...')
if GaitFail~=1
    [RightStride, LeftStride]=  StrideFinder(RightSwingPhase, LeftSwingPhase, RightStancePhase, LeftStancePhase, trajectories, vicon, S);
end
%% Vital Info (Version 2.x)
[ TrialInfo ] = GetVitals( vicon, 'R' );
%% Save Data
clearvars -Except ModelOutput ModelOutputHelp S trajectories...
    TrajectoryHelp ForcePlateData vicon velocities accelerations...
    FootEventStruct FootEventCell EMGTable RightStancePhase...
    LeftStancePhase RightSwingPhase LeftSwingPhase RightStride LeftStride...
    FileLocation Errors errorCount ToPull EMGProcessed FPD saveFile TrialInfo
MarkerNames=vicon.GetMarkerNames(S)';

%Put filepath here for where you want to save data
cd(saveFile)

[~, TrialName]=vicon.GetTrialName;
fprintf('Finished with trial %s \n', TrialName)
save(TrialName);


end

