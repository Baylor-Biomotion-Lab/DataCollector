% Main program for collecting and analyzing data from Vicon
%% Model Output Information
clearvars -Except FileLocation Errors errorCount ToPull
ModifyFootEvents=0; %Set to 1 if you want to put in your own foot events
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
[ForcePlateData]=ForcePlateInfo(vicon);
disp('Force Data successfully imported...')
%% Trajectory Information
[trajectories, velocities, accelerations, MarkerHelp]=TrajectoryInfo(vicon, S);
disp('Trajectories successfully imported...')
%% Foot Events
%Run a pipeline which runs "Autocorrelate Events" and "Detect Events From Forceplate" to get all foot marker
%data
% vicon.RunPipeline('MyPipeline','Private',45);
[FootEventStruct, FootEventCell]=GetFootEvents( vicon, S, ModifyFootEvents );
%% EMG Data
try
    [ EMGData, EMGNames, EMGTable, EMGProcessed ] = GetEMGData( vicon );
    disp('EMG Data successfully imported...')
catch
    EMGTable=NaN;
    EMGProcessed=NaN;
end
%% Gait Analysis
[FootEventCell, RightStancePhase, LeftStancePhase, RightSwingPhase, LeftSwingPhase]=GaitFinder(FootEventCell, trajectories, vicon, S);
disp('Gaits successfully found...')
[ModelOutput, ModelOutputHelp, FootEventCell, GaitFail]=MaxMin(ModelOutput,ModelOutputHelp, FootEventCell, RightStancePhase, LeftStancePhase, RightSwingPhase, LeftSwingPhase);
disp('Data successfully analyzed...')
if GaitFail~=1
    [RightStride, LeftStride]=  StrideFinder(RightSwingPhase, LeftSwingPhase, RightStancePhase, LeftStancePhase, trajectories, vicon, S);
end
%% Save Data
clearvars -Except ModelOutput ModelOutputHelp S trajectories...
    TrajectoryHelp ForcePlateData vicon velocities accelerations...
    FootEventStruct FootEventCell EMGTable RightStancePhase...
    LeftStancePhase RightSwingPhase LeftSwingPhase RightStride LeftStride...
    FileLocation Errors errorCount ToPull EMGProcessed
MarkerNames=vicon.GetMarkerNames(S)';
[ startFrame, endFrame ] = vicon.GetTrialRegionOfInterest;

%Put filepath here for where you want to save data
cd 'H:\Research\MATLAB\VAC\CollectedData\Carley'

[~, TrialName]=vicon.GetTrialName;
fprintf('Finished with trial %s \n', TrialName)
save(TrialName);
%% Test Data and Name Concatenation
%  cd 'H:\Research\MATLAB\DataCollector\CollectedData'