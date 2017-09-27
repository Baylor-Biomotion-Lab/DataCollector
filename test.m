% run TableMaker

Data=ActivityCells{2,1}(1:20,1)';
FlexSpread=zeros(length(Data),1);
for trial=1:length(Data)
    FlexSpread(trial)=Data{trial}(1,1);
end

xax=1:length(FlexSpread);
scatter(xax,FlexSpread, 'r*')
ylabel('Degree')
xlabel('Trial #')

mean(FlexSpread)
std(FlexSpread)
