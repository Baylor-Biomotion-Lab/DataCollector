%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Vicon provide the software below “as is," and you use the software at your
% own risk. Vicon makes no warranties as to performance, merchantability,
% fitness for a particular purpose, or any other warranties whether expressed
% or implied. No oral or written communication from or information provided
% by Vicon shall create a warranty. Under no circumstances shall Vicon be
% liable for direct, indirect, special, incidental, or consequential damages
% resulting from the use, misuse, or inability to use this software, even if
% Vicon has been advised of the possibility of such damages.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
classdef DetectFootEvents
    % simple class used to detect foot contacts on one or more force plates
    
    properties
        MarkerNames;        % markers to look at for determining left/right
        % there is an assumption that the first 2
        % markers are on the left foot and the second 2
        % are on the right foot
        MarkerData;         % 4 x ( 3 x FrameCount ) matrix storing marker data
        MarkerDataExists;   % 4 x FrameCount matrix storing exists information for each traj
        
        ForcePlateData;     % 3 X (FrameCount * SamplesPerFrame) matrix storing force plate data
        CoPData;            % 3 X (FrameCount * SamplesPerFrame) matrix storing CoP data
        
        LastFrameAboveThreshold;
    end
    
    methods
        function obj = DetectFootEvents()
            % class constructor
        end
        
        function FindEvents(obj,vicon,subject,forceThresh,leftAntMarker,leftPostMarker,rightAntMarker,rightPostMarker)
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            % FindEvents will look for foot strike and foot off events for
            % a loaded subject.
            % This function will look for events in the valid updatable frame
            % range for the loaded trial
            % This function will look for events for all defined force plates.
            %
            % Input
            %     vicon           = instance of a Vicon sdk object
            %     subject         = name of the subject
            %     forceThresh     = force threshold
            %     leftAntMarker   = name of the Left Anterior Marker
            %     leftPostMarker  = name of the Left Posterior Marker
            %     rightAntMarker  = name of the Right Anterior Marker
            %     rightPostMarker = name of the Right Posterior Marker
            %
            % Usage Example:
            %
            %    vicon = ViconNexus();
            %    vicon.ClearAllEvents();
            %    eventDetector = DetectFootEvents();
            %    eventDetector.FindEvents(vicon, 'Colin', 20.0, 'LTOE', 'LANK', 'RTOE', 'RANK');
            %
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            
            obj.MarkerNames = { leftAntMarker, leftPostMarker, rightAntMarker, rightPostMarker };
            
            % validate the input data
            rate = vicon.GetFrameRate();
            if rate < 1.0
                error('Invalid frame rate for the loaded trial');
            end
            
            subjects = vicon.GetSubjectNames();
            S = find(strcmp(subject, subjects), true);
            if(numel(S) == 1)
                DefinedMarkers = vicon.GetMarkerNames(subject);
                for i=1:4
                    M = find(strcmp(obj.MarkerNames(i), DefinedMarkers), true);
                    if numel(M) ~= 1
                        error(['Invalid marker name ', obj.MarkerNames(i)]);
                    end
                end
                
                % retrieve the marker data that we are going to need
                FrameCount = vicon.GetFrameCount();
                obj.MarkerDataExists = false(4, FrameCount);
                obj.MarkerData = zeros(4, 3, FrameCount);
                for i=1:4
                    [obj.MarkerData(i,1,:), obj.MarkerData(i,2,:), obj.MarkerData(i,3,:), obj.MarkerDataExists(i,:)] = vicon.GetTrajectory(subject,char(obj.MarkerNames(i)));
                end
                
                % loop through the force plates looking for events
                deviceIDs = vicon.GetDeviceIDs();
                for i=1:numel(deviceIDs)
                    [~, type, ~, ~, ~, ~] = vicon.GetDeviceDetails(deviceIDs(i));
                    if(strcmp(type,'ForcePlate') == true)
                        obj.ProcessForcePlate(vicon,subject,deviceIDs(i),forceThresh);
                    end
                end
            else
                error(['Invalid subject name ', subject]);
            end
        end
        
        function ProcessForcePlate(obj,vicon,subject,deviceID,forceThresh)
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            % FindEvents helper function.
            % Look for events for a specific force plate.
            %
            % Input
            %     vicon           = instance of a Vicon sdk object
            %     subject         = name of the subject
            %     deviceID        = unique deviceID identifying the force plate
            %     forceThresh     = force threshold
            %
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            
            % retrieve the force plate data
            [~, ~, deviceRate, ~, ~, ~] = vicon.GetDeviceDetails(deviceID);
            rate = vicon.GetFrameRate();
            SamplesPerFrame = 1;
            if deviceRate > rate
                SamplesPerFrame = deviceRate / rate;
            end
            
            FrameCount = vicon.GetFrameCount();
            obj.ForcePlateData = zeros(3,FrameCount * SamplesPerFrame);
            
            % DeviceOutput = 'Force', channels 'Fx', 'Fy' and 'Fz'
            deviceOutputID = vicon.GetDeviceOutputIDFromName(deviceID,'Force');
            channelID = vicon.GetDeviceChannelIDFromName(deviceID, deviceOutputID, 'Fx');
            [obj.ForcePlateData(1,:), ready, ~] = vicon.GetDeviceChannelGlobal( deviceID, deviceOutputID, channelID );
            channelID = vicon.GetDeviceChannelIDFromName(deviceID, deviceOutputID, 'Fy');
            [obj.ForcePlateData(2,:), ~, ~] = vicon.GetDeviceChannelGlobal( deviceID, deviceOutputID, channelID );
            channelID = vicon.GetDeviceChannelIDFromName(deviceID, deviceOutputID, 'Fz');
            [obj.ForcePlateData(3,:), ~, ~] = vicon.GetDeviceChannelGlobal( deviceID, deviceOutputID, channelID );
            
            % DeviceOutput = 'CoP', channels 'Cx', 'Cy' and 'Cz'
            obj.CoPData = zeros(3,FrameCount * SamplesPerFrame);
            deviceOutputID = vicon.GetDeviceOutputIDFromName(deviceID,'CoP');
            channelID = vicon.GetDeviceChannelIDFromName(deviceID, deviceOutputID, 'Cx');
            [obj.CoPData(1,:), ~, ~] = vicon.GetDeviceChannel( deviceID, deviceOutputID, channelID );
            channelID = vicon.GetDeviceChannelIDFromName(deviceID, deviceOutputID, 'Cy');
            [obj.CoPData(2,:), ~, ~] = vicon.GetDeviceChannel( deviceID, deviceOutputID, channelID );
            channelID = vicon.GetDeviceChannelIDFromName(deviceID, deviceOutputID, 'Cz');
            [obj.CoPData(3,:), ~, ~] = vicon.GetDeviceChannel( deviceID, deviceOutputID, channelID );
            
            % now look for the events based on the threshold
            if( ready == true )
                bForceOn = false;
                obj.LastFrameAboveThreshold = -1;
                
                [ startFrame, endFrame ] = vicon.GetTrialRange();
                for i=startFrame:endFrame
                    for j=1:SamplesPerFrame
                        
                        SampleIndex = ((i-1) * SamplesPerFrame) + (j-1) + 1;
                        force = norm(obj.ForcePlateData(:,SampleIndex));
                        
                        if (force >= forceThresh) && (obj.ForcePlateData(3,SampleIndex) < 0)
                            obj.LastFrameAboveThreshold = i;
                            if bForceOn == false
                                % Foot Strike
                                obj.HandleEvent( vicon, subject, i, (j-1) * (1.0/deviceRate), 'Foot Strike', deviceID, SamplesPerFrame );
                                bForceOn = true;
                            end
                        else
                            if bForceOn && (force < forceThresh)
                                % Foot Off
                                obj.HandleEvent( vicon, subject, i, (j-1) * (1.0/deviceRate), 'Foot Off', deviceID, SamplesPerFrame);
                                bForceOn = false;
                            end
                        end
                        
                    end
                end
            end
        end
        
        function HandleEvent(obj,vicon,subject,frame,offset,event,deviceID,SamplesPerFrame)
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            % FindEvents helper function.
            % Determine the proper context (left or right) and creates an event in the application
            %
            % Input
            %     vicon           = instance of a Vicon sdk object
            %     subject         = name of the subject
            %     frame           = frame number where the event occurs
            %     offset          = offset to add to the frame if the event occurred between frame boundaries
            %     event           = type of event, 'Foot Strike' or 'Foot Off'
            %     deviceID        = unique deviceID identifying the force plate
            %     SamplesPerFrame = number of force plate samples that correspond to each data frame
            %
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            
            context = obj.DetermineRightLeft(vicon,deviceID,frame,SamplesPerFrame);
            %             disp( [context, ' ', event, ' event at frame ', num2str(frame), ' offset ', num2str(offset)] );
            
            % do not add a duplicate event if this one already exists
            [eventFrames, eventOffsets] = vicon.GetEvents( subject, context, event );
            exists = false;
            for i=1:numel(eventFrames)
                if eventFrames(i) == frame
                    if abs(eventOffsets(i) - offset) < 0.001
                        exists = true;
                    end
                end
            end
            
            if exists
                %                 disp( '       Events already exists' );
            else
                vicon.CreateAnEvent( subject, context, event, frame, offset );
            end
        end
        
        function context = DetermineRightLeft(obj,vicon,deviceID,frame,SamplesPerFrame)
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            % FindEvents helper function.
            % Determine whether or not the left or right markers are
            % closest to "the plate" (point = either centre, or the CoP)
            %
            % Input
            %     vicon           = instance of a Vicon sdk object
            %     deviceID        = unique deviceID identifying the force plate
            %     frame           = frame number where the event occurs
            %     SamplesPerFrame = number of force plate samples that correspond to each data frame
            %
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            
            context = 'General';
            
            % Calculate a reference point, start with the centre of the force plate.
            [~, ~, ~, ~, ForcePlate, ~] = vicon.GetDeviceDetails(deviceID);
            
            utils = ViconUtils();
            
            % reference point is the center of the plate
            RefPoint = (ForcePlate.UpperBounds() + ForcePlate.LowerBounds()) / 2;
            
            if (frame - obj.LastFrameAboveThreshold) <= 1
                % However, if the last sample that had an above-threshold reading
                % is either the current sample or the one before, use the position
                % of the FP's centre of pressure as the reference point.
                CoP = zeros(3,1);
                SampleIndex = ((obj.LastFrameAboveThreshold-1) * SamplesPerFrame) + 1;
                for i=1:SamplesPerFrame
                    CoP = CoP + obj.CoPData(:,SampleIndex);
                    SampleIndex = SampleIndex + 1;
                end
                RefPoint = CoP / SamplesPerFrame;
                % unit conversion
                RefPoint = RefPoint / 1000.0;
            end
            
            % Globalise the reference point
            RefPoint = utils.Globalise(RefPoint, ForcePlate.WorldR, ForcePlate.WorldT);
            
            % Find the marker that is closest to the plate
            MinDist = -1.0;
            ClosestMarkerIndex = 0;
            
            for i=1:4
                if obj.MarkerDataExists(i,frame)
                    % Test if the marker is within the bounds of the plate and,
                    % if so, see if it is the closest.
                    MarkerPos = obj.MarkerData(i,:,frame);
                    MarkerPosLocal = utils.Localise(reshape(MarkerPos,[1 3]), ForcePlate.WorldR, ForcePlate.WorldT );
                    
                    if (ForcePlate.LowerBounds(1) < MarkerPosLocal(1)) && (MarkerPosLocal(1) < ForcePlate.UpperBounds(1))
                        if (ForcePlate.LowerBounds(2) < MarkerPosLocal(2)) && (MarkerPosLocal(2) < ForcePlate.UpperBounds(2))
                            if MarkerPosLocal(3) > 0
                                % candidate for closest marker
                                dist = norm(reshape(MarkerPos, [ 3 1 ]) - reshape(RefPoint,[3 1]),2);
                                if (MinDist < 0.0) || (dist < MinDist)
                                    MinDist = dist;
                                    ClosestMarkerIndex =  i;
                                end
                            end
                        end
                    end
                    
                end
            end
            
            % the closest marker determines the context, if we didn't determine
            % a closes marker then we return 'General' as the context
            if ( ClosestMarkerIndex == 1 ) || ( ClosestMarkerIndex == 2 )
                context = 'Left';
            else
                if ( ClosestMarkerIndex == 3 ) || ( ClosestMarkerIndex == 4 )
                    context = 'Right';
                end
            end
            
        end
        
    end
end

