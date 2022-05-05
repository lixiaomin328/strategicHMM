function averageLevel = individualLevel(userName,projectId)
%userName = 'ash';
%projectId = 1;
addpath('/Users/xiaominli/Dropbox/salience_2016+/method/code/DataProcessing')

PROJECT_NAME = {'matching','hiding','seeking'};
game =PROJECT_NAME{projectId};
fixation_sal_folder = '../../fixationSal';
user_folder = '../../fixation';
resolution = [1080, 1920];
IMG_FOLDER = '../../res/';
subId = 2;
images = dir([IMG_FOLDER, game,'/',num2str(subId),'/*.jpg']);
DATA_FOLDER = '../../data';
fixationData = load([fixation_sal_folder,'/',userName,'fixationSal', '/', userName,'_',game,'_',num2str(subId),'.mat']);
allSals = fixationData.perGameFixSal(:,1);


game = PROJECT_NAME{projectId};
load(['hmmGazeResults/hmmGazeResult_',game,'.mat']);
mus = muMean;
sigmas = sigmaMean;
transmat = transmatMean;
prior = [0; 0; 1];
sampleId = 1;
allSalsStates = cell(size(allSals,1),1);
for i = 1 : size(allSals, 1)
    data = [allSals{i,1};100];
    obsProbs = exp(-(data * ones(size(mus')) - ones(size(data)) * mus').^2./(ones(size(data)) .* sigmas').^2)...
        ./ (ones(size(data)) .* sigmas');
    probs = obsProbs(1,:)';
    probs = probs/sum(probs);
    allSalsStates{i} = probs;
    for j = 1 : length(data) - 1
        nextProbs = obsProbs(j + 1, :)'.*(transmat' * probs);
        nextProbs = nextProbs / sum(nextProbs);
        allSalsStates{i} = [allSalsStates{i},nextProbs];
        probs = nextProbs;        
    end
end
%%3 is salient state
allDiscreteStates = cell(size(allSals,1),1);
for i = 1:length(allSalsStates)
    data = allSalsStates{i,1};
    for fixNum = 1:size(data,2)
        oneState = data(:,fixNum);
        [~,maxEntry] = max(data(:,fixNum));
        allDiscreteStates{i} = [allDiscreteStates{i};maxEntry];
%         oneState(:) = 0;
%         oneState(maxEntry)=1;
%         data(:,fixNum) =oneState;
    end
    allSalsStates{i,1}=data;
end
%%
simplifedAllStates = cell(size(allSals,1),2);
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
levels(levels<0)=0;
averageLevel = mean(levels);
%save(['hmmIndividualLevel/','userName',game,'Level.mat'],'levels');
