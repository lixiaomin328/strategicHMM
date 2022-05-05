%deleteComputerSessions
fileName = '../../polonio2.csv';
data = readtable(fileName);
decisionRule = {'cas','mass','coop'};
for i = 1:length(decisionRule)
    word= decisionRule{i};
    data(contains(data.Phase,word),:) =[];
end
writetable(data,fileName)



