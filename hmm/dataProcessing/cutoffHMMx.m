function x = cutoffHMMx(mu1,mu2,sigma1,sigma2)
a = sigma2^2-sigma1^2;
b  = 2*(sigma1^2*mu2-sigma2^2*mu1);
c = (sigma2*mu1)^2-(sigma1*mu2)^2-2*sigma2^2*sigma1^2*log(sigma2/sigma1);
lala = sqrt(b^2-4*a*c);
x1 = (-1*b-lala)/(2*a);
x2 = (-1*b+lala)/(2*a);
x = [x1,x2];