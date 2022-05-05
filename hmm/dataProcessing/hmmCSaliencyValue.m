function saliency = hmmCSaliencyValue(mu,sigma,prob)
[mus,muId]=sort(mu);
sigmas = sigma(muId);
selectedMu = double(rand()<prob)+1;
saliency = mus(selectedMu)+sigmas(selectedMu)*randn();
saliency = min(max(saliency,0),1);