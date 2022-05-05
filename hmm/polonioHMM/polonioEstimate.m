addpath('/Volumes/My Passport/HMMall/KPMstats');
addpath('/Volumes/My Passport/HMMall/HMM');
addpath('/Volumes/My Passport/HMMall/netlab3.3');
addpath('/Volumes/My Passport/HMMall/KPMtools');
load('polonioGaze_MULTI.mat')
%load('polonioHMMMULTIestimatesMEQ=4.mat')
bics=[];
aics = [];
for Q = 2:8
    O = 10;
    
    roundNum = 10;
    
    
    LLs = [];
    transmats = {};
    obsmats={};
    priors = [];
    
    for i = 1:roundNum
        prior0 = normalise(rand(Q,1));
        transmat0 = mk_stochastic(rand(Q,Q));
        %obsmat0 = [trainedObs{1},zeros(Q,1)];
        obsmat0 = mk_stochastic(rand(Q,O));
        [LL, prior, transmat, obsmat, nrIterations]=...
            dhmm_em(fixationAll, prior0, transmat0, obsmat0,'max_iter', 200)
        
        LLs = [LLs;max(LL)];
        transmats = [transmats;transmat];
        obsmats=[obsmats;obsmat];
        priors = [priors,prior];
    end
    save(['polonioHMMMULTIestimatesMEQ=',num2str(Q),'.mat'],'LLs','obsmats','priors','transmats')
end