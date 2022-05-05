%take RT duration
function sampleVecs = discreteHMMsimulation(projectId)
addpath('/Volumes/My Passport/HMMall/KPMstats');
addpath('/Volumes/My Passport/HMMall/HMM');
addpath('/Volumes/My Passport/HMMall/netlab3.3');
%%simulate discrete HMM
addpath('/Volumes/My Passport/HMMall/KPMtools');
PROJECT_NAME = {'matching', 'seeking', 'hiding'};
allSamples = {};

    sampleVecs = {};
game = PROJECT_NAME{projectId};
load(['hmmGazeResultsWithChoice/hmmGazeResultWithChohice_',game,'Q=3.mat']);
mus = muMean;
sigmas = sigmaMean;
transmat = transmatMean;
prior = [0; 0; 1];
RTduration = [];
weights = zeros(3, 3, 0);
sampleId = 1;

[sortedDuration, id] = sort(RTduration);
weights = weights(:,:,id);
cumWeights = cumsum(weights, 3);

salienProbs = [];
sampleN = 10;
decisionSaliencyStates=[];
sampleLen = 1000;
for sampleId = 1 : sampleN
    if mod(sampleId, 100) == 0
      % fprintf('testId = %d, sampleId = %d\n', testId, sampleId); 
    end
    mixmat1 = mk_stochastic(rand(3,1));
    %% generate sample
    Sigma1 = reshape(sigmas, [1 1 3 1]);
    [~, samples] = mhmm_sample(sampleLen, 1, prior, transmat, mus', Sigma1, mixmat1);
    samples = samples(2:end);   
    DecisionSaliencyStateId = find(samples==3)-1;
    decisionSaliencyState = samples(DecisionSaliencyStateId);
    decisionSaliencyStates = [decisionSaliencyStates;decisionSaliencyState];
    
    %%all samples in this batch

    start = 1;
    for startId = 1:length(DecisionSaliencyStateId)-1
        sampleVecs = [sampleVecs;samples(start:DecisionSaliencyStateId(startId))];%all samples
        start = DecisionSaliencyStateId(startId)+2;
    end
end
allSamples = [allSamples,sampleVecs];
salienProbs = sum(decisionSaliencyStates==2)/length(decisionSaliencyStates);
obsSaliency = min(mus)*(1-salienProbs)+ max(mus(mus<50))*salienProbs;

