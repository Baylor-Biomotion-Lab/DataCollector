for i=1:length(ParamNames)
    disp(i)
[value,unit,~,~,~]=vicon.GetSubjectParamDetails(sub,ParamNames{i})
values(i)=value; units{i}=unit;

end