function FootEventCell=FootFPInfo(plotFP, FootEventCell, trajectories, events, xv1, yv1, xv2,yv2, xv3, yv3, S, vicon)
% Get extra info for the Foot Event Cell

%Points in Trajectory
MarkerNames=vicon.GetMarkerNames(S)';
LHEE=find(strcmp('LHEE',MarkerNames));
LTOE=find(strcmp('LTOE',MarkerNames));
RHEE=find(strcmp('RHEE',MarkerNames));
RTOE=find(strcmp('RTOE',MarkerNames));



for event=1:events
    %Find Toe Off and Foot Strike Trajectories
    %Toe Offs
    FO_LHX=trajectories{LHEE}{FootEventCell{event,1},1};
    FO_LHY=trajectories{LHEE}{FootEventCell{event,1},2};
    
    FO_LTX=trajectories{LTOE}{FootEventCell{event,1},1};
    FO_LTY=trajectories{LTOE}{FootEventCell{event,1},2};
    
    FO_RHX=trajectories{RHEE}{FootEventCell{event,1},1};
    FO_RHY=trajectories{RHEE}{FootEventCell{event,1},2};
    
    FO_RTX=trajectories{RTOE}{FootEventCell{event,1},1};
    FO_RTY=trajectories{RTOE}{FootEventCell{event,1},2};
    
    %Foot Strikes
    FS_LHX=trajectories{LHEE}{FootEventCell{event,1},1};
    FS_LHY=trajectories{LHEE}{FootEventCell{event,1},2};
    
    FS_LTX=trajectories{LTOE}{FootEventCell{event,1},1};
    FS_LTY=trajectories{LTOE}{FootEventCell{event,1},2};
    
    FS_RHX=trajectories{RHEE}{FootEventCell{event,1},1};
    FS_RHY=trajectories{RHEE}{FootEventCell{event,1},2};
    
    FS_RTX=trajectories{RTOE}{FootEventCell{event,1},1};
    FS_RTY=trajectories{RTOE}{FootEventCell{event,1},2};
    
    TrajectoryCell={FO_LHX, FO_LHY, FO_LTX, FO_LTY, FO_RHX, FO_RHY, FO_RTX, FO_RTY...
        FS_LHX, FS_LHY, FS_LTX, FS_LTY, FS_RHX, FS_RHY, FS_RTX, FS_RTY};
    
%Check if both heel and toe
    
    if strcmp(FootEventCell{event,2},'RFS')
        %Check if in any forceplates
        RinFP=inFP('Right', 'FS', TrajectoryCell, xv1, yv1, xv2,...
            yv2, xv3, yv3);
        if RinFP>0
            FootEventCell{event,5}=FootEventCell{event,5}+1;
            FootEventCell{event,6}=RinFP;
        end
        if plotFP==1
            fprintf(' %g : RFS at frame %g is in plate %g (zero if in none). \n', event, FootEventCell{event, 1}, RinFP)
            
            figure(event)
            hold on
            plot(xv3,yv3)
            plot(xv2,yv2)
            plot(xv1,yv1)
            h=gca;
            h.XDir='reverse';
            axis equal
            plot(FS_RTY,FS_RTX, 'r+');
            plot(FS_RHY,FS_RHX, 'r+');
            hold off
        end
    elseif strcmp(FootEventCell{event,2},'LFS')
        %Check if in any forceplates
        LinFP=inFP('Left', 'FS', TrajectoryCell, xv1, yv1, xv2,...
            yv2, xv3, yv3);
        if LinFP>0
            FootEventCell{event,5}=FootEventCell{event,5}+1;
            FootEventCell{event,6}=LinFP;
        end
        if plotFP==1
            fprintf(' %g : LFS at frame %g is in plate %g (zero if in none). \n', event, FootEventCell{event, 1}, LinFP)
            
            figure(event)
            hold on
            plot(xv3,yv3)
            plot(xv2,yv2)
            plot(xv1,yv1)
            h=gca;
            h.XDir='reverse';
            axis equal
            plot(FS_LTY,FS_LTX, 'b+');
            plot(FS_LHY,FS_LHX, 'b+');
            hold off
        end
    elseif strcmp(FootEventCell{event,2},'RFO')
        %Check if in any forceplates
        RinFP=inFP('Right', 'FO', TrajectoryCell, xv1, yv1, xv2,...
            yv2, xv3, yv3);
        if RinFP>0
            FootEventCell{event,5}=FootEventCell{event,5}+1;
            FootEventCell{event,6}=RinFP;
        end
        if plotFP==1
            fprintf(' %g : RFO at frame %g is in plate %g (zero if in none). \n', event, FootEventCell{event, 1}, RinFP)
            
            figure(event)
            hold on
            plot(xv3,yv3)
            plot(xv2,yv2)
            plot(xv1,yv1)
            h=gca;
            h.XDir='reverse';
            axis equal
            plot(FO_RTY,FO_RTX, 'r+');
            plot(FO_RHY,FO_RHX, 'r+');
            hold off
        end
    elseif strcmp(FootEventCell{event,2},'LFO')
        %Check if in any forceplates
        LinFP=inFP('Left', 'FO', TrajectoryCell, xv1, yv1, xv2,...
            yv2, xv3, yv3);
        if LinFP>0
            FootEventCell{event,5}=FootEventCell{event,5}+1;
            FootEventCell{event,6}=LinFP;
        end
        if plotFP==1
            fprintf(' %g : LFO at frame %g is in plate %g (zero if in none). \n', event, FootEventCell{event, 1}, LinFP)
            
            figure(event)
            hold on
            plot(xv3,yv3)
            plot(xv2,yv2)
            plot(xv1,yv1)
            h=gca;
            h.XDir='reverse';
            axis equal
            plot(FO_LTY,FO_LTX, 'b+');
            plot(FO_LHY,FO_LHX, 'b+');
            hold off
        end
    end
end


end

