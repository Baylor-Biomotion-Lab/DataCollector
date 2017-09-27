function NewFootEventCell=UserFootEvents
% If the foot events are incomplete, use this to add in extra foot events. 
%% Prompt User for Foot Strikes or Foot Offs
%Type break to quit
EventNo=1;
NewFootEventCell=cell(EventNo,2);
EventCount=1;
while true
    Event=input('Event type (RFO, LFO, RFS, LFS): Type break to quit \n','s');
    acceptableInputs={'RFO' 'LFO' 'RFS' 'LFS'};
    if strcmp(Event,'break')
        break
    elseif ~strcmp(Event,acceptableInputs)
        warning('Invalid input. Appropriate events are: RFO, LFO, RFS, LFS.')
        continue
    end
    Frame=input('Frame # when event occurred: \n');
    
    NewFootEventCell{EventCount,2}=Event;
    NewFootEventCell{EventCount,1}=Frame;
    %Needs to be the same type as FootEventCell in order to continue:
    NewFootEventCell{EventCount,1}=uint32(NewFootEventCell{EventCount,1}); 
    EventCount=EventCount+1;
%     if EventCount>EventNo
%         break
%     end
end