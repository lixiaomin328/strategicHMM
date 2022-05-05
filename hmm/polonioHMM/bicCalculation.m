addpath('/Volumes/My Passport/HMMall/KPMstats');
addpath('/Volumes/My Passport/HMMall/HMM');
addpath('/Volumes/My Passport/HMMall/netlab3.3');
addpath('/Volumes/My Passport/HMMall/KPMtools');
%load('polonioGaze_MULTI.mat')
%load('polonioHMMMULTIestimatesMEQ=4.mat')
bics=[];
aics = [];
for Q = 2:8
    
    load(['polonioHMMMULTIestimatesMEQ=',num2str(Q),'.mat'])
    O = 10;
    numParam = (Q+1)*(Q-1)+Q*(O-1);
    nOfObs = 3125;%91379
    [aic,bic] = aicbic(max(LLs),numParam,nOfObs);
    bics = [bics;bic];
    aics = [aics;aic];
end
%%
plot([2:8],bics)
hold on
plot([2:8],aics)
legend('BIC','AIC')
xlabel('Number of hidden states')
plotImprovement