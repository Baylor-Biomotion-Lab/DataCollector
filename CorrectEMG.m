% Corrects the EMG Issue of not actually pulling.
%% The only thing you have to change is line 8, which is where you will save your variable
vicon=ViconNexus();
[~, TrialName]=vicon.GetTrialName;
cd('H:\Research\MATLAB\VAC\CollectedData\Running Study')
try
    load(TrialName);
    vicon.Connect()
    [ ~, ~, EMGTable, EMGProcessed ] = GetEMGData( vicon );
    disp('EMG Data successfully imported...')
    save(TrialName);
catch
    warning('EMG data not succesfully imported...')
    EMGTable=NaN;
    EMGProcessed=NaN;
end