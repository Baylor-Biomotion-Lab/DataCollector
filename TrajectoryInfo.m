function [ trajectories, velocities, accelerations, MarkerHelp] = TrajectoryInfo( vicon, S )
% Pulls trajectory info from vicon
MarkerNames=vicon.GetMarkerNames(S);
names=length(MarkerNames); 
trajectories=cell(names,1); velocities=cell(names,1); accelerations=cell(names,1);
frameRate=vicon.GetFrameRate;
[ startFrame, endFrame ] = vicon.GetTrialRange();
frames = startFrame:endFrame;
for name=1:names
    try
        [trajX, trajY, trajZ, ~]=vicon.GetTrajectory(S,MarkerNames{name});
    catch
        %          Marker_Missing=sprintf('Marker %s does not exist for this trial', MarkerNames{name});
        %          warning(Marker_Missing)
        trajX=NaN; trajY=NaN; trajZ=NaN;
    end
    trajX=trajX'; trajY=trajY'; trajZ=trajZ';
    trajectories{name}=[trajX,trajY,trajZ];
    trajectories{name}=array2table(trajectories{name});
    if isnan(trajX)
        velX=NaN; velY=NaN; velZ=NaN;
        accX=NaN; accY=NaN; accZ=NaN;
        velocities{name}=[velX, velY, velZ];
        accelerations{name}=[accX, accY, accZ];
        continue
    else
        vicon.SubmitSplineTrajectory(frames, trajX, trajY, trajZ, frameRate);
        [velX, velY, velZ]=vicon.GetSplineResults(1);
        [accX, accY, accZ] = vicon.GetSplineResults(2);
        
        velX=velX'; velY=velY'; velZ=velZ';
        accX=accX'; accY=accY'; accZ=accZ';
        
        velocities{name}=[velX, velY, velZ];
        accelerations{name}=[accX, accY, accZ];
        
    end
    MarkerHelp=table((1:names)', MarkerNames', trajectories, velocities, accelerations);
end
