function [FootEventStruct, FootEventCell] = GetFootEventPipeline( vicon, S, Modify )
%When the MATLAB code fails, use this instead. Make sure to run the
%pipeline given in the warning. 

%Gather data from Vicon
% eventDetector=DetectFootEvents();
% eventDetector.FindEvents(vicon, S, 20.0, 'LTOE', 'LANK', 'RTOE', 'RANK');
[ LFSframes, LFSoffsets] = vicon.GetEvents( S, 'Left', 'Foot Strike' );
[ LFOframes, LFOoffsets] = vicon.GetEvents( S, 'Left', 'Foot Off' );
[ RFSframes, RFSoffsets] = vicon.GetEvents( S, 'Right', 'Foot Strike' );
[ RFOframes, RFOoffsets] = vicon.GetEvents( S, 'Right', 'Foot Off' );

LFSframes=LFSframes'; LFSoffsets=LFSoffsets';
LFOframes=LFOframes'; LFOoffsets=LFOoffsets';
RFSframes=RFSframes'; RFSoffsets=RFSoffsets';
RFOframes=RFOframes'; RFOoffsets=RFOoffsets';

if isempty(LFSframes) && isempty(LFOframes) && isempty(RFSframes) && isempty(RFOframes)
    warning('No foot events detected')
end
%% Revise this later
LFScell=cell(length(LFSframes),2);
LFOcell=cell(length(LFOframes),2);
RFScell=cell(length(RFSframes),2);
RFOcell=cell(length(RFOframes),2);

for i=1:length(LFSframes)
    LFScell{i,1}=LFSframes(i);
    LFScell{i,2}='LFS';
end
for i=1:length(LFOframes)
    LFOcell{i,1}=LFOframes(i);
    LFOcell{i,2}='LFO';
end
for i=1:length(RFSframes)
    RFScell{i,1}=RFSframes(i);
    RFScell{i,2}='RFS';
end
for i=1:length(RFOframes)
    RFOcell{i,1}=RFOframes(i);
    RFOcell{i,2}='RFO';
end

FootEventCell=[LFScell; LFOcell; RFScell; RFOcell];
if Modify==1
    NewFootEventCell=UserFootEvents;
    FootEventCell=[FootEventCell; NewFootEventCell];
end
FootEventCell=sortrows(FootEventCell);
[rows,~]=size(FootEventCell);
for row=1:rows
    switch FootEventCell{row,2}(1)
        case 'R'
            FootEventCell{row,3}='R';
        case 'L'
            FootEventCell{row,3}='L';
    end
end
for row=1:rows
    switch FootEventCell{row,2}(3)
        case 'S'
            FootEventCell{row,4}='S';
        case 'O'
            FootEventCell{row,4}='O';
    end
end
%% Put data into a structure
LFSTable=table(LFSframes,LFSoffsets,...
    'VariableNames',{'LeftFootStrikeFrames' 'LeftFootStrikeOffsets'});
LFOTable=table(LFOframes,LFOoffsets,...
    'VariableNames',{'LeftFootOffFrames' 'LeftFootOffOffsets'});
RFSTable=table(RFSframes,RFSoffsets,...
    'VariableNames',{'RightFootStrikeFrames' 'RightFootStrikeOffsets'});
RFOTable=table(RFOframes,RFOoffsets,...
    'VariableNames',{'RightFootOffFrames' 'RightFootOffOffsets'});

FootEventStruct(1).Left.FootStrike=LFSTable;
FootEventStruct(1).Left.FootOff=LFOTable;
FootEventStruct(1).Right.FootStrike=RFSTable;
FootEventStruct(1).Right.FootOff=RFOTable;
end