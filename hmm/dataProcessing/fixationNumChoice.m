cumulation = [];
for i = 1:max(fixationChoice(:,1))
if isempty(find(fixationChoice(:,1)==i, 1))
    continue
end
allEntries = fixationChoice(fixationChoice(:,1)==i,:);
if size(allEntries,1)<4
    continue
end
cumulation =[cumulation;allEntries(1,1),mean(allEntries(:,2))];
end