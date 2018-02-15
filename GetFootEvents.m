function [ FootEventStruct, FootEventCell ] = GetFootEvents( vicon,S, Modify )
%Pulls foot events from Vicon.

%Gather data from Vicon
[ LFSframes, LFSoffsets] = vicon.GetEvents( S, 'Left', 'Foot Strike' );
[ LFOframes, LFOoffsets] = vicon.GetEvents( S, 'Left', 'Foot Off' );
[ RFSframes, RFSoffsets] = vicon.GetEvents( S, 'Right', 'Foot Strike' );
[ RFOframes, RFOoffsets] = vicon.GetEvents( S, 'Right', 'Foot Off' );

LFSframes=double(LFSframes'); LFSoffsets=double(LFSoffsets');
LFOframes=double(LFOframes'); LFOoffsets=double(LFOoffsets');
RFSframes=double(RFSframes'); RFSoffsets=double(RFSoffsets');
RFOframes=double(RFOframes'); RFOoffsets=double(RFOoffsets');

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
    if ~isempty(NewFootEventCell{1})
        FootEventCell=[FootEventCell; NewFootEventCell];
    end
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

