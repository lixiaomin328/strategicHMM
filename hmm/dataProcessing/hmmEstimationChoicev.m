function [bic,LL] = hmmEstimationChoicev(Q,game)
%Q number of hidden states
addpath('/Volumes/My Passport/HMMall/KPMstats');
addpath('/Volumes/My Passport/HMMall/HMM');
addpath('/Volumes/My Passport/HMMall/netlab3.3');
addpath('/Volumes/My Passport/HMMall/KPMtools');
%%
superVector = [];
superVectorTime = [];
%game = 'matching';
%subId = 1;
userFolder = '../../fixationSal';
GAZE_FOLDER = '../../gaze_data/';
userFiles = dir(GAZE_FOLDER);
allData = cell(2,0);
cnt = 1;
for i = 1 : length(userFiles)
    userName = userFiles(i).name;
    if userName(1) =='.'
        continue;
    end
    for subId = 1:2
        load([[userFolder,'/',userName,'fixationSal'], '/', userName,'_',game,'_',num2str(subId),'.mat'])
        for imgId = 1:19
            [i,imgId]
            if perGameFixSal{imgId,4}==-1%%no response trial take out
                continue
            end
            superVector = [superVector;100;perGameFixSal{imgId,1}];
            superVectorTime = [superVectorTime;100;perGameFixSal{imgId,2}];
            allData{cnt,1} = [100;perGameFixSal{imgId,1};perGameFixSal{imgId,4}];
            allData{cnt,2} = [100;perGameFixSal{imgId,2}];%time
            cnt = cnt +1;
        end
    end
end

%%
O = 1;
M = 1; %gaussian #
%Q = 4; %# hiddenstate
nIter = 10;
mus = zeros(Q,nIter);
sigmas = zeros(Q,nIter);
transmats = zeros(Q*Q, nIter);
isInvalid = zeros(1, nIter);

for iter = 1 : nIter
    iter
    data = [];
    for i = 1 : length(allData)
        data = [data,allData{randi(length(allData)),1}'];
    end
    %data = superVector';
    
    left_right = 0;
    
    prior0 = normalise(rand(Q,1));
    transmat0 = mk_stochastic(rand(Q,Q));
    
    try
        [mu0, Sigma0] = mixgauss_init(Q*M, data, 'full');
    catch ME
        isInvalid(iter) = 1;
        continue;
    end
    mu0 = reshape(mu0, [O Q M]);
    Sigma0 = reshape(Sigma0, [O O Q M]);
    mixmat0 = mk_stochastic(rand(Q,M));
    [LL, prior1, transmat1, mu1, Sigma1, mixmat1] = ...
        mhmm_em(data, prior0, transmat0, mu0, Sigma0, mixmat0, 'max_iter', 6, 'verbose',1);
    [mu, id] = sort(mu1);
    sigma = Sigma1(id);
    transform = zeros(Q, Q);
    for i = 1 : Q
        transform(i, id(i)) = 1;
    end
    transmat = transform * transmat1 / transform;
    mus(:, iter) = mu(:);
    sigmas(:, iter) = sigma(:);
    transmats(:,iter) = transmat(:);
end
numParam = (Q+2)*(Q-1);
[aic,bic] = aicbic(LL(end),numParam,length(data));
%% Parameter Processing
musValid = mus(:, isInvalid == 0);
sigmasValid = sigmas(:, isInvalid == 0);
transmatsValid = transmats(:, isInvalid == 0);
sigmaQuantiles = quantile(sigmasValid', [0.05, 0.50, 0.95]);
muQuantiles = quantile(musValid', [0.05, 0.50, 0.95]);
transmatQuantiles = quantile(transmatsValid', [0.05, 0.50, 0.95]);
transmatQuantilesMat = cell(1,Q);
for i = 1 : 3
    transmatQuantilesMat{i} = reshape(transmatQuantiles(i, :), Q, Q);
end
sigmaMean = mean(sigmasValid, 2);
muMean = mean(musValid, 2);
transmatMean = reshape(mean(transmatsValid, 2), Q, Q);
mkdir hmmGazeResultsWithChoice
save(sprintf('hmmGazeResultsWithChoice/hmmGazeResultsWithChoice_%s.mat', game,Q), 'muQuantiles', 'sigmaQuantiles', ...
    'transmatQuantilesMat', 'sigmaMean', 'muMean', 'transmatMean','aic','bic');
