function [ data ] = VariableAverager(type, Names, var,dir)
% Old script to find average values
switch dir
    case 'X'
        dir=1;
    case 'Y'
        dir=2;
    case 'Z'
        dir=3;
    otherwise
        error('Not an accepted direction. Choose X, Y, or Z.')
end
NamesL=length(Names);
MaxVar=ones(1,NamesL);

for name=1:NamesL
    load(Names{name})
    varloc=find(strcmp(ModelOutputHelp{:,2},var));
    switch type
        case 'max'
            MaxVar(name)=max(ModelOutput{varloc}(:,dir));
        case 'min'
            MaxVar(name)=min(ModelOutput{varloc}(:,dir));
        case 'avg'
            MaxVar(name)=mean(ModelOutput{varloc}(:,dir));
        otherwise
            error('Function not accepted. Accepted functions are: "max" "min" "avg"')
    end
    data=mean(MaxVar);
    
end

