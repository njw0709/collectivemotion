function [cfunc_t,fit1_t,fit2_t,gof1_t,gof2_t,datapts_mag,datapts_ang]=pivlabvelmagangtimecorr(xvel,yvel,timeperframe,filebase_results,name)
%
%  This function computes the time autocorrelation function for each
%  velocity point averaged over the entire FOV for the requested range of
%  timesteps.  Currently looks pretty nice, except for a sudden jump
%  between the t=0 point and the t=1 timestep point.  Scan 1 in
%  ecolicapsize gives nearly complete decorellation in about 2 seconds.

%timestep by default is one frame
%timeperframe in ms is fine (eg 20 for 50 fps)
%lasttstep = total # of images


%clf
maxt = length(xvel);
avcorr = zeros(maxt+1,7);
sumV = 0;
sumVsq = 0;
sumCos = 0;
sumCossq = 0;
N = 0;

for tstep=0:maxt
    disp('Processing Time Correlation');
    disp(tstep);
    for q = 1:length(xvel)
        if q+tstep > length(xvel)
            break
        end
            
        xvelq = cell2mat(xvel(q));
        yvelq = cell2mat(yvel(q));
        [m,n] = size(xvelq);
          
        xvelqpt = cell2mat(xvel(q+tstep));
        yvelqpt = cell2mat(yvel(q+tstep));

         %vector lists of velocity magnitudes and direction cosines for image q
         %and q+tstep
        
        magq = sqrt(xvelq.*xvelq + yvelq.*yvelq);
        dircosq = yvelq./magq;

        magqpt = sqrt(xvelqpt.*xvelqpt + yvelqpt.*yvelqpt);
        dircosqpt = yvelqpt./magqpt;
    

            avcorr(tstep+1,1) = avcorr(tstep+1,1)+1; %adds to the counter for the number of pairs at this tstep
            avcorr(tstep+1,2) = avcorr(tstep+1,2)+mean2(magq.*magqpt); %increments running tally of sum(v_i*v_j) 
            avcorr(tstep+1,3) = avcorr(tstep+1,3)+mean2(dircosq.*dircosqpt);  %increments running tally of sum(dcos_i*dcos_j)
            
       if tstep==1
            N = N+m*n;
            sumV = sumV + sum(sum(magq)); %increments running tally of sum(v)
            sumVsq = sumVsq +sum(sum(magq.*magq)); %increments running tally of sum(v^2)
            sumCos = sumCos +sum(sum(dircosq)); %increments running tally of sum(dcos)
            sumCossq = sumCossq +sum(sum(dircosq.*dircosq));  %increments running tally of sum(dcos^2)
       end

    end
    clc
end
    disp('Done Processing Time Correlation');
    magcorrfunc = (avcorr(:,2)./avcorr(:,1) - ones(size(avcorr(:,1)))*(sumV/N)^2 )./(sumVsq/N - (sumV/N)^2);
    angcorrfunc = (avcorr(:,3)./avcorr(:,1) - ones(size(avcorr(:,3)))*(sumCos/N)^2 )./(sumCossq/N - (sumCos/N)^2);
       
    magangtimecorr = [(0:maxt)'*timeperframe,magcorrfunc,angcorrfunc];
    %delete_nan replaces all the nan(undefined) values
%     magangtimecorr(:,2) = delete_nan(magangtimecorr(:,2));
%     magangtimecorr(:,3) = delete_nan(magangtimecorr(:,3));
    filteredmag = sgolayfilt(magangtimecorr(:,2),5,41);
    filteredang = sgolayfilt(magangtimecorr(:,3),5,41);

    
    %For debugging purpose - choosing constants for s-golay filter.
%     figure
%     
%     subplot(2,1,1)
%     hold on
%     plot(magangtimecorr(:,1),magangtimecorr(:,2),'bo');    
%     plot(magangtimecorr(:,1),filteredmag,'r-');
%     
%     subplot(2,1,2)
%     hold on
%     plot(magangtimecorr(:,1),magangtimecorr(:,3),'bo');
%     plot(magangtimecorr(:,1),filteredang,'r-');
    
    magdiff = diff(filteredmag);
    angdiff = diff(filteredang);
    xdiff = diff(magangtimecorr(:,1));
    magstart = find(abs(magdiff./xdiff)<5e-5);
    angstart = find(abs(angdiff./xdiff)<5e-5);
    
    %save(strcat(filebase_results,'timecorr_test'));
    
    %curvefit
    if length(magstart)~=0
        if magstart(1)>3
            [xdata1, ydata1] = prepareCurveData(magangtimecorr(1:magstart(1),1),magangtimecorr(1:magstart(1),2));
        else
            [xdata1, ydata1] = prepareCurveData(magangtimecorr(1:5,1),magangtimecorr(1:5,2));
        end
    else
        magstart(1) = length(magangtimecorr(:,1));
        [xdata1, ydata1] = prepareCurveData(magangtimecorr(:,1),magangtimecorr(:,2));
    end
    
    if length(angstart)~=0
        if angstart(1)>3
            [xdata2, ydata2] = prepareCurveData(magangtimecorr(1:angstart(1),1),magangtimecorr(1:angstart(1),3));
        else
            [xdata2, ydata2] = prepareCurveData(magangtimecorr(1:5,1),magangtimecorr(1:5,3));
        end
    else
        angstart(1) = length(magangtimecorr(:,1));
        [xdata2, ydata2] = prepareCurveData(magangtimecorr(:,1),magangtimecorr(:,3));
    end
 
     
    % Set up fittype and options.
    ft = fittype( 'exp(-b*x)', 'independent', 'x', 'dependent', 'y' );
    
    opts1 = fitoptions( 'Method', 'NonlinearLeastSquares' );
    opts1.Display = 'Off';
    opts1.Robust = 'Bisquare';
    opts1.StartPoint = [0.3];
    opts1.upper = [10];
    opts1.lower = [0];
    
    opts2 = fitoptions( 'Method', 'NonlinearLeastSquares' );
    opts2.Display = 'Off';
    opts2.Robust = 'Bisquare';
    opts2.StartPoint = [0.3];
    opts2.upper = [10];
    opts2.lower = [0];

    %createfit
    [fitresult_mag,gof_mag] = fit(xdata1,ydata1,ft,opts1);
    [fitresult_ang,gof_ang] = fit(xdata2,ydata2,ft,opts2);
    figres = figure('Visible','off');
    set(gcf,'CreateFcn','set(gcf,''Visible'',''on'')');
    subplot(2,1,1), plot(fitresult_mag,magangtimecorr(:,1),magcorrfunc);
    subplot(2,1,2), plot(fitresult_ang,magangtimecorr(:,1),angcorrfunc);
    saveas(gcf,[filebase_results,strcat(name,'timecorr')])
    
    % defining output results
    cfunc_t = magangtimecorr;
    datapts_mag = magstart(1);
    datapts_ang = angstart(1);
    fit1_t =fitresult_mag;
    fit2_t =fitresult_ang;
    gof1_t =gof_mag;
    gof2_t =gof_ang;   

end