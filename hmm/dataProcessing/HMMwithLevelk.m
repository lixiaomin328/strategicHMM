PROJECT_NAME = {'matching', 'seeking', 'hiding'};
fittedTaus = [];
for projectId = 1%1:3
game = PROJECT_NAME{projectId};
load(['hmmGazeResults/hmmGazeResult_',game,'.mat']);
load(['hmmSourceWithRT/',[game,'allData.mat']]);
mus = muMean;
sigmas = sigmaMean;
transmat = transmatMean;
prior = [0; 0; 1];
sampleId = 1;
allDataStates = cell(size(allData,1),1);
for i = 1 : size(allData, 1)
    data = allData{i,1};
    obsProbs = exp(-(data * ones(size(mus')) - ones(size(data)) * mus').^2./(ones(size(data)) .* sigmas').^2)...
        ./ (ones(size(data)) .* sigmas');
    probs = obsProbs(1,:)';
    probs = probs/sum(probs);
    allDataStates{i} = probs;
    for j = 1 : length(data) - 1
        nextProbs = obsProbs(j + 1, :)'.*(transmat' * probs);
        nextProbs = nextProbs / sum(nextProbs);
        allDataStates{i} = [allDataStates{i},nextProbs];
        probs = nextProbs;
        
    end
end

%%
allDiscreteStates = cell(size(allData,1),1);
for i = 1:length(allDataStates)
    data = allDataStates{i,1};
    for fixNum = 1:size(data,2)
        oneState = data(:,fixNum);
        [~,maxEntry] = max(data(:,fixNum));
        allDiscreteStates{i} = [allDiscreteStates{i};maxEntry];
%         oneState(:) = 0;
%         oneState(maxEntry)=1;
%         data(:,fixNum) =oneState;
    end
    allDataStates{i,1}=data;
end
%%
simplifedAllStates = cell(size(allData,1),2);
for i = 1:length(allDiscreteStates)
    stateTransOneTrial = allDiscreteStates{i,1};
    lastState = stateTransOneTrial(1);
    simplifedAllStates{i,1}= [simplifedAllStates{i,1};lastState]; 
    for fixNum = 2:length(stateTransOneTrial)
        currentState = stateTransOneTrial(fixNum);
        if projectId ==1
            if currentState ==3
                simplifedAllStates{i,1}= [simplifedAllStates{i,1};currentState];
            end
            if currentState ~= lastState
                continue;               
            else
                lastState = currentState;
                simplifedAllStates{i,1}= [simplifedAllStates{i,1};lastState];
            end
        else
            if currentState == lastState
                continue;
            else
                lastState = currentState;
                simplifedAllStates{i,1}= [simplifedAllStates{i,1};lastState];
            end
        end
    end
    simplifedAllStates{i,2} = length(simplifedAllStates{i,1})-2;
    allDiscreteStates{i,1} = stateTransOneTrial;    
end
levels = [simplifedAllStates{:,2}];
%levels = levels +1;
levels(levels<0)=0;
save(['hmmSourceWithRT/',game,'Level.mat'],'levels');
end 
%%
PROJECT_NAME = {'matching', 'seeking', 'hiding'};
meanLevel = [];
stdLevel = [];
figure
for projectId = 1:3
    game = PROJECT_NAME{projectId};
    load(['hmmSourceWithRT/',game,'Level.mat'],'levels');
    density = [];
    for level = 0:6
        density= [density; sum(levels==level)/length(levels)];    
    end
    bestFitPoisson = fitdist(levels','poisson');
    possonPDF = poisspdf([0:1:6],bestFitPoisson.lambda);
    fittedTaus = [fittedTaus;bestFitPoisson.lambda];
    %%possonPDF = exppdf([0:1:6],bestFitPoisson.mu)
    subplot(1,3,projectId)    
    bar([0:1:6],density)
    hold on
    plot([0:1:6],possonPDF,'linewidth',2)
    hold off
    title(game)
    meanLevel = [meanLevel;mean(levels)];
    stdLevel = [stdLevel;std(levels)];
    xlabel('Levels')
    ylabel('Probability')
    plotImprovement
end
%%