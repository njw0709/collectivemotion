function [vffft] = velfieldfft(xvel,yvel,firsttstep,lasttstep)


%clf
maxt = lasttstep-firsttstep;
avcorr = zeros(maxt+1,7);
sumV = 0;
sumVsq = 0;
sumCos = 0;
sumCossq = 0;
N = 0;

    for q = firsttstep:lasttstep

        xvelq = cell2mat(xvel(q));
        yvelq = cell2mat(yvel(q));
        [m,n] = size(xvelq);
        comvel = xvelq + 1i*yvelq;
        comvelfft = fft2(comvel);

    end
     

    
    subplot(2,1,1), plot(magcorrfunc);
    subplot(2,1,2), plot(angcorrfunc);
    saveas(gcf,'timecorrfuncfig')
    
    
tcorrfinal = magangtimecorr;
    

end
