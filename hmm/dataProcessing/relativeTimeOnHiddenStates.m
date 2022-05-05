%on sampleVecs for a particular game
figure()
numberOfFix = 10;
for projectId = 1:3
PROJECT_NAME = {'matching', 'seeking', 'hiding'};
sampleVecs = discreteHMMsimulation(projectId);
%%CALCULATE FIXATION LENGTH
fixationLengths=[];
finalDecisions = [];
for i = 1:length(sampleVecs)
    numFixations = length(sampleVecs{i});
    fixationLengths = [fixationLengths;numFixations];%include choice
end


salientStates= zeros(max(fixationLengths),1);%cumulation on salient states
unsalientStates = zeros(max(fixationLengths),1);%cumulation on unsalient states
decisionState = zeros(max(fixationLengths),1);
for j = 1:length(sampleVecs)
    numFixations = length(sampleVecs{j});
    finalDecisions = [finalDecisions;sampleVecs{j}(numFixations)];
    for k = 1:numFixations-1
        if sampleVecs{j}(k)==2
            salientStates(k)=salientStates(k)+1;
        else
            unsalientStates(k)=unsalientStates(k)+1;
        end
    end
    decisionState(numFixations:end) = decisionState(numFixations:end)+1;
end

stackVariable = [salientStates,unsalientStates];
stackVariable = stackVariable./sum(stackVariable,2);
stackVariable = [(1:numberOfFix)',stackVariable(1:numberOfFix,:)];
subplot(1,3,projectId)
bar(stackVariable(:,1),stackVariable(:,2:end),'stacked','barwidth',1)
hold on 
xline(mean(fixationLengths),'-.k','Average Decision Time','linewidth',3);
hold off
xlabel('Fixation Number')
ylabel('Probability of being at each state')
legend('At salient state','At unsalient state','Decided')
title(PROJECT_NAME{projectId})
plotImprovement
end