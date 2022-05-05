%take RT duration into consideration
addpath('/Volumes/My Passport/HMMall/KPMstats');
addpath('/Volumes/My Passport/HMMall/HMM');
addpath('/Volumes/My Passport/HMMall/netlab3.3');
addpath('/Volumes/My Passport/HMMall/KPMtools');
PROJECT_NAME = {'matching', 'seeking', 'hiding'};
figure()
for projectId = 2%1:3
game = PROJECT_NAME{projectId};
load(['hmmGazeResults/hmmGazeResult_',game,'.mat']);
load(['hmmSourceWithRT/',[game,'allData.mat']]);
mus = muMean;
sigmas = sigmaMean;
transmat = transmatMean;
prior = [0; 0; 1];
RTduration = [];
weights = zeros(3, 3, 0);
sampleId = 1;
for i = 1 : size(allData, 1)
    RTduration =[RTduration; allData{i,2}(2:end) - allData{i,2}(1:end-1)];
    data = allData{i,1};
    obsProbs = exp(-(data * ones(size(mus')) - ones(size(data)) * mus').^2./(ones(size(data)) .* sigmas').^2)...
        ./ (ones(size(data)) .* sigmas');
    probs = obsProbs(1,:)';
    probs = probs/sum(probs);
    for j = 1 : length(data) - 1
        nextProbs = obsProbs(j + 1, :)'.*(transmat' * probs);
        nextProbs = nextProbs / sum(nextProbs);
        weights(:, :, sampleId) = (probs * obsProbs(j+1,:)).*transmat;
        weights(:, :, sampleId) = weights(:, :, sampleId) / sum(sum(weights(:, :, sampleId)));
        %weights(:, :, sampleId) = probs * nextProbs';
        sampleId = sampleId + 1;
        probs = nextProbs;
    end
end
[sortedDuration, id] = sort(RTduration);
weights = weights(:,:,id);
cumWeights = cumsum(weights, 3);

timeCutOff = [0.1,0.5:1:10] * 1e6;
salienProbs = zeros(size(timeCutOff));
finishProbs = zeros(size(timeCutOff));
responseTime = zeros(size(timeCutOff));
sampleN = 1000;
endingStates = zeros(1, length(mus));
sampleLen = 1000;
for testId = 1 : length(timeCutOff)
    finishedCnt = 0;
    rtSum =0;
for sampleId = 1 : sampleN
    if mod(sampleId, 100) == 0
      % fprintf('testId = %d, sampleId = %d\n', testId, sampleId); 
    end
    mixmat1 = mk_stochastic(rand(3,1));
    %% generate sample
    Sigma1 = reshape(sigmas, [1 1 3 1]);
    [~, samples] = mhmm_sample(sampleLen, 1, prior, transmat, mus', Sigma1, mixmat1);
    samples = samples(2:end);
    cumTime = 0;
    curState = samples(1);
    for i= 2 : length(samples)
        nextState = samples(i);
        weightCutoff = cumWeights(curState, nextState, end) * rand;
        timeId = binarySearch(cumWeights(curState, nextState,:), weightCutoff);
        cumTime = cumTime + sortedDuration(timeId);
        if nextState == 3 || cumTime > timeCutOff(testId)
            endingStates(curState) = endingStates(curState) + 1;
            if nextState == 3
                finishedCnt = finishedCnt + 1;                
            end
            rtSum = rtSum+1.5*min(cumTime,timeCutOff(testId));
            break;
        end
        curState = nextState;
    end
end
salienProbs(testId) = endingStates(2) / max(sum(endingStates(1:2)), 1);
finishProbs(testId) = finishedCnt / sampleN;
responseTime(testId) = rtSum/sampleN;
fprintf('cutOffTime = %.2f sec, saliencyProb = %.2f, finishedProb = %.2f, responseTime = %.2f\n', ...
    timeCutOff(testId) / 1e6, salienProbs(testId), finishProbs(testId),responseTime(testId));
end
obsSaliency = min(mus)*(1-salienProbs)+ max(mus(mus<50))*salienProbs;
plot(timeCutOff/1e6, salienProbs);
title(['probablity being at salient state'])
% plot(timeCutOff/1e6, obsSaliency);
% title(['predicted gaze saliency at different time'])
xlabel('time in s')
ylabel('saliency value')
hold on
end
ylim([0:1])
%hold on;
%plot(timeCutOff/1e6, finishProbs);
%hold off;
