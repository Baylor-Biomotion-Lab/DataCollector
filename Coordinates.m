function Coordinates( trajectories )
%Find coordinates of markers, provided they are marked as shown in
%FootFinder.m
letters={'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J'};
Dir={'X', 'Y', 'Z'};
for i=1:length(letters)
    for j=1:length(Dir)
        Name=sprintf('%s%s',letters{i},Dir{j});
        var=mean(trajectories{i,1}{:,j});
        fprintf('%s=%g; \n',Name,var)
    end
end



end

