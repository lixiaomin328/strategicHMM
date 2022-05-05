%simulation
load('polonioHMMEQWithChoiceQ=4.mat')
transmat = transmats{6};
prior = priors(:,6);
obsmat = obsmats{6};
roundN = 1000;
salientRate = [];
for stepN = [10:10:1000]
    
    choices = [];
    
    start = gendist(prior',1,1);
    %stepN = 500;
    probs = [];
    for round = 1:roundN
        decision = 3;
        
        
        for step = 0:stepN
            if decision <3
                stoppingT = step;
                choices = [choices;decision,stoppingT];
                break
            end
            prob = prior'*transmat^step;
            decprob = [prob*obsmat(:,9:10) 1-sum(prob*obsmat(:,9:10))];
            decision = gendist(decprob,1,1);
            probs = [probs;prob];
            choices = [choices;decision,stoppingT];
        end
        
    end
    salientRate = [salientRate;sum(choices==1)/(sum(choices==1)+sum(choices==2))];
end

