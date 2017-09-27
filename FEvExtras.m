function [ FootEventCell ] = FEvExtras( FootEventCell, events )
% More Foot Event Cell additions.
FootEventCell{1,3}=[];
FootEventCell{1,4}=[];
FootCount=zeros(events,1);
RCount=0; LCount=0;
for event=1:events
    switch FootEventCell{event,2}
        case 'RFS'
            FootEventCell{event,3}='R';
            FootEventCell{event,4}='S';
            FootEventCell{event,5}=0;
            FootEventCell{event,6}=0;
            RCount=RCount+1;
        case 'LFS'
            FootEventCell{event,3}='L';
            FootEventCell{event,4}='S';
            FootEventCell{event,5}=0;
            FootEventCell{event,6}=0;
            LCount=LCount+1;
        case 'RFO'
            FootEventCell{event,3}='R';
            FootEventCell{event,4}='O';
            FootEventCell{event,5}=0;
            FootEventCell{event,6}=0;
            RCount=RCount+1;
            
        case 'LFO'
            FootEventCell{event,3}='L';
            FootEventCell{event,4}='O';
            FootEventCell{event,5}=0;
            FootEventCell{event,6}=0;
            LCount=LCount+1;
            
    end
end


end

