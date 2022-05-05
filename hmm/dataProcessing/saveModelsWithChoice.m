projectNames = {'matching','seeking','hiding'};
nHiddenStates = 3;
for projectId = 1:length(projectNames)
[bic,LL] = hmmEstimationChoicev(nHiddenStates,projectNames{projectId});
end