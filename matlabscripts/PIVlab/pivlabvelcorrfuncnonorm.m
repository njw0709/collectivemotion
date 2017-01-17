function [h,fitresult1,fitresult2,gof1,gof2,datapts_mag,datapts_ang] = pivlabvelcorrfuncnonorm(xpos,ypos,xvel,yvel,rstep,pix2micron,filebase_results,name)
%
%This function calculates the spatial correlation function of the velocity
%magnitude and the velocity direction cosine.  It is NOT normalized:
%calculates only <A(0)A(r)> which should fit to <A>^2 +
%(<A^2>-<A>^2)exp(-d/d_R)
%rstep is in pixels, assumes 2048x2048 images
%
clf
maxr = floor(sqrt(2)*2048/rstep)  + 1;


avcorr=zeros(maxr,3);

for q=1:length(xpos)
    disp('Processing Velocity Correlation');
    disp(q);
    xq = cell2mat(xpos(q));
    [m,n] = size(xq);
    yq = cell2mat(ypos(q));
    xvelq = cell2mat(xvel(q));
    yvelq = cell2mat(yvel(q));

    %vector lists of velocity magnitudes and direction cosines for image q
    mag = sqrt(xvelq.*xvelq + yvelq.*yvelq);
    dircos = yvelq./mag;
    
    %for each pair
    for i=1:m
        for j=i:n
            for k=1:m
                for l=1:n
            %distance in pixels between pair
            rpix = sqrt((xq(i,j)-xq(k,l))^2 + (yq(i,j)-yq(k,l))^2);  
            
            %index is number of rsteps in pixels apart they are
            ind = floor(rpix/rstep)+1;
       
            avcorr(ind,1) = avcorr(ind,1)+1; %adds one to the counter for the number of pairs at this separation
            avcorr(ind,2) = avcorr(ind,2)+mag(i,j)*mag(k,l); %increments running tally of sum(v_i*v_j) 
            avcorr(ind,3) = avcorr(ind,3)+dircos(i,j)*dircos(k,l);  %increments running tally of sum(dcos_i*dcos_j)
                end
            end
        end 
    end
    clc;
end
    disp('Velocity Correlation Processing Done');
    NatRstep = avcorr(:,1);
    magcorrfunc = avcorr(:,2)./avcorr(:,1);
    angcorrfunc = avcorr(:,3)./avcorr(:,1); 
    magangcorrfunc = [(1:maxr)'*rstep*pix2micron,NatRstep,magcorrfunc,angcorrfunc];
    %delete_nan replaces all the nan(undefined) values
    magangcorrfunc(:,3) = delete_nan(magangcorrfunc(:,3));
    magangcorrfunc(:,4) = delete_nan(magangcorrfunc(:,4));
    
    
    %Savitzky-Golay Filter approximates each set of data points(size 41) to a
    %5th degree polynomial and thus smoothes the data points.
    filteredmag = sgolayfilt(magangcorrfunc(:,3),5,41);
    filteredang = sgolayfilt(magangcorrfunc(:,4),5,41);
    
    %For debugging purpose: choose an ideal input values for the filter
    %above by looking at the figures produced with code below
%     fig = figure('Visible','off');
%     set(gcf,'CreateFcn','set(gcf,''Visible'',''on'')');
%     subplot(2,1,1)
%     hold on
%     plot(magangcorrfunc(:,1),magangcorrfunc(:,3));
%     plot(magangcorrfunc(:,1),filteredmag,'r-');
%     legend('Actual Data','Low Pass Filtered');
%     
%     subplot(2,1,2) 
%     hold on
%     plot(magangcorrfunc(:,1),magangcorrfunc(:,4));
%     plot(magangcorrfunc(:,1),filteredang,'r-');
%     legend('Actual Data','Low Pass Filtered');
    
%     saveas(gcf,[filebase_results,strcat('magangcorrfunc')]);
%     save(strcat(filebase_results,'corrfunctest_rst60'));
    
    magdiff = diff(filteredmag);
    angdiff = diff(filteredang);
    xdiff = diff(magangcorrfunc(:,1));
    magstart = find(abs(magdiff./xdiff)<5e-4);
    angstart = find(abs(angdiff./xdiff)<1e-4);
    
      %Prepare Data for Curve fit - Only selects data with consecutively
      %negetive slope.
      if length(magstart)~=0
          if magstart(1)>3
            [xdata1, ydata1] = prepareCurveData(magangcorrfunc(1:magstart(1),1),magangcorrfunc(1:magstart(1),3));
          else
            [xdata1, ydata1] = prepareCurveData(magangcorrfunc(1:5,1),magangcorrfunc(1:5,3));
          end
      else
          magstart(1) = length(magangcorrfunc(:,1));
          [xdata1, ydata1] = prepareCurveData(magangcorrfunc(:,1),magangcorrfunc(:,3));
      end
      
      if length(angstart)~=0
          if angstart(1)>3
                [xdata2, ydata2] = prepareCurveData(magangcorrfunc(1:angstart(1),1),magangcorrfunc(1:angstart(1),4));
          else
                [xdata2, ydata2] = prepareCurveData(magangcorrfunc(1:5,1),magangcorrfunc(1:5,4));
          end
      else
          angstart(1) = length(magangcorrfunc(:,1));
          [xdata2, ydata2] = prepareCurveData(magangcorrfunc(:,1),magangcorrfunc(:,4));
      end
        

    
    % Set up fittype and options.
    ft = fittype( 'a*exp(-b*x)+c', 'independent', 'x', 'dependent', 'y' );
    opts1 = fitoptions( 'Method', 'NonlinearLeastSquares' );
    opts1.Display = 'Off';
    opts1.Robust = 'Bisquare';
    % Guessing what the fit parameters are to produce better results
    datalen = length(filteredmag);
    ave1 = mean(abs(filteredmag(uint8(datalen/3):uint8(datalen*2/3))));
    yint1 = magangcorrfunc(1,3)-ave1;
    opts1.StartPoint = [yint1 1 ave1];
    opts1.upper = [yint1*5 100 10];
    opts1.lower = [0 0 -1];
    
    opts2 = fitoptions( 'Method', 'NonlinearLeastSquares' );
    opts2.Display = 'Off';
    opts2.Robust = 'Bisquare';
    % Guessing what the fit parameters are to produce better results
    ave2 = mean(abs(filteredang(uint8(datalen/3):uint8(datalen*2/3))));
    yint2 = magangcorrfunc(1,4)-ave2;
    opts2.StartPoint = [yint2 1 ave2];
    opts2.upper = [yint2*5 100 5];
    opts2.lower = [0 0 -1];
    
    %createfit
    [fitresult1,gof1] = fit(xdata1,ydata1,ft,opts1);
    [fitresult2,gof2] = fit(xdata2,ydata2,ft,opts2);
    
    figres = figure('Visible','off');
    set(gcf,'CreateFcn','set(gcf,''Visible'',''on'')');
    subplot(3,1,1), plot(magangcorrfunc(:,1),magangcorrfunc(:,2));
    subplot(3,1,2), plot(fitresult1,magangcorrfunc(:,1),magangcorrfunc(:,3));
    subplot(3,1,3), plot(fitresult2,magangcorrfunc(:,1),magangcorrfunc(:,4));       
    saveas(gcf,[filebase_results,strcat('velcorr',name)])

%defining output value    
h = magangcorrfunc;
datapts_mag = magstart(1);
datapts_ang = angstart(1);
    
end
