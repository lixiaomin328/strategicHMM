% function hmmForGazeSaliency
% addpath('/Volumes/My Passport/HMMall/KPMstats');
% addpath('/Volumes/My Passport/HMMall/HMM');
% addpath('/Volumes/My Passport/HMMall/netlab3.3');
% addpath('/Volumes/My Passport/HMMall/KPMtools');
addpath('~/Downloads/HMMall/KPMstats');
addpath('~/Downloads/HMMall/HMM');
addpath('~/Downloads/HMMall/netlab3.3');
addpath('~/Downloads/HMMall/KPMtools');

load('hmmGazeResults/hmmGazeResult_hiding.mat')
nTrial = 1000;
normDenseall = [];
shortDenseall = [];
cuttime = 3;
for i = 1:nTrial
prior1 = [1;0;0];
transmat1 = transmatMean;
mu1 = muMean';
Sigma1 = reshape(sigmaMean, [1 1 3 1]);
mixmat1 = mk_stochastic(rand(3,1));
[obs, hidden] = mhmm_sample(10000, 1, prior1, transmat1, mu1, Sigma1, mixmat1);
decisionSal = obs(find(hidden==3)-1);
decisionSal = decisionSal(decisionSal<1);
decisionSal = decisionSal(decisionSal>0);
i
lengthDec = [find(hidden==cuttime);0]-[0;find(hidden==cuttime)];
intervalDec = lengthDec(2:size(lengthDec,1)-1)-1;
intervalDec(intervalDec>cuttime)=cuttime;
shortEntry = find(hidden==cuttime);
shortDecisionSal = obs(shortEntry(1:size(shortEntry,1)-1)+intervalDec);
shortDecisionSal = shortDecisionSal(shortDecisionSal<1);
shortDecisionSal = shortDecisionSal(shortDecisionSal>0);

normDense = hist(decisionSal)./sum(hist(decisionSal));
shortDense = hist(shortDecisionSal)./sum(hist(shortDecisionSal));
normDenseall = [normDenseall;normDense];
shortDenseall =[shortDenseall;shortDense];
end
normDenseall = mean(normDenseall,1);
shortDenseall=mean(shortDenseall,1);
plot([0:1/9:1],normDenseall)
hold on
plot([0:1/9:1],shortDenseall)
hold off
legend('normal prediction','force quit prediction')