games = {'matching','hiding','seeking'};
bics = [];
LLs=[];
for Q = 2:10
for projectId =1:3
        game = games{projectId};
[bic,LL] = hmmForGazeSaliency(Q,game);
bics = [bics;bic];
LLs=[LLs;max(LL)];
end
end
%%
bics =reshape(bics,3,9);
LLs =reshape(LLs,3,9);
%%
figure
for i = 1:3
    
    plot([1:9],bics(i,:))
    hold on
end
legend('matching','hiding','seeking')

bicAll =[];
for Q = 2:10
numParam = (Q+2)*(Q-1);
[aic,BIC] = aicbic(sum(LLs(1:3,Q-1)),numParam,4645);
bicAll =[bicAll;BIC];
end
plot([1:9],bicAll)