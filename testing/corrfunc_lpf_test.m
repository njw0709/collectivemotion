close all
load('corrfunctest_rst20.mat');
addpath('/data1/user_data/bacteria/matlabscripts/PIVlab');
%magangcorr(:,1): x axis, %magangcorr(:,3): magnitude correlation
%%magangcorr(:,4): angle correlation
%% Low Pass Filter Implementation testing
datalen = length(magangcorrfunc(:,1));
%delete_nan replaces all the nan(undefined) values
magangcorrfunc(:,3) = delete_nan(magangcorrfunc(:,3));
magangcorrfunc(:,4) = delete_nan(magangcorrfunc(:,4));
%Savitzky-Golay Filter approximates each set of data points(size 41) to a
%5th degree polynomial and thus smoothes the data points.
figure
subplot(2,1,1)
hold on
plot(magangcorrfunc(:,1),magangcorrfunc(:,3),'bo');
filteredmag = sgolayfilt(magangcorrfunc(:,3),5,41);
plot(magangcorrfunc(:,1),filteredmag,'r-');
subplot(2,1,2)
hold on
plot(magangcorrfunc(:,1),magangcorrfunc(:,4),'bo');
filteredang = sgolayfilt(magangcorrfunc(:,4),5,41);
plot(magangcorrfunc(:,1),filteredang,'r-');


magdiff = diff(filteredmag);
angdiff = diff(filteredang);
xdiff = diff(magangcorrfunc(:,1));
magstart = find(abs(magdiff./xdiff)<5e-4);
angstart = find(abs(angdiff./xdiff)<1e-4);

figure
subplot(2,1,1)
hold on
plot(magangcorrfunc(2:end,1),magdiff./xdiff,'b-');
for i=1:length(magstart)
    plot(magangcorrfunc(magstart(i),1),0,'rx');
end
subplot(2,1,2)
hold on
plot(magangcorrfunc(2:end,1),angdiff./xdiff,'b-');
for i=1:length(angstart)
    plot(magangcorrfunc(angstart(i),1),0,'rx');
end
%% Curve Fit Functionality Testing
      %curvefit
      if length(magstart)~=0
        [xdata1, ydata1] = prepareCurveData(magangcorrfunc(1:magstart(1),1),magangcorrfunc(1:magstart(1),3));
      else
          [xdata1, ydata1] = prepareCurveData(magangcorrfunc(:,1),magangcorrfunc(:,3));
      end
      
      if length(angstart)~=0
          [xdata2, ydata2] = prepareCurveData(magangcorrfunc(1:angstart(1),1),magangcorrfunc(1:angstart(1),4));
      else
          [xdata2, ydata2] = prepareCurveData(magangcorrfunc(:,1),magangcorrfunc(:,4));
      end
    

    
    % Set up fittype and options.
    ft = fittype( 'a*exp(-b*x)+c', 'independent', 'x', 'dependent', 'y' );
    opts1 = fitoptions( 'Method', 'NonlinearLeastSquares' );
    opts1.Display = 'Off';
    opts1.Robust = 'Bisquare';
    ave1 = mean(abs(filteredmag(uint8(datalen/3):uint8(datalen*2/3))));
    yint1 = magangcorrfunc(1,3)-ave1;
    opts1.StartPoint = [yint1 1 ave1];
    opts1.upper = [yint1*2 100 10];
    opts1.lower = [0 0 -1];
    
    opts2 = fitoptions( 'Method', 'NonlinearLeastSquares' );
    opts2.Display = 'Off';
    opts2.Robust = 'Bisquare';
    ave2 = mean(abs(filteredang(uint8(datalen/3):uint8(datalen*2/3))));
    yint2 = magangcorrfunc(1,4)-ave2;
    opts2.StartPoint = [yint2 1 ave2];
    opts2.upper = [yint2*2 100 5];
    opts2.lower = [0 0 -1];
    
    %createfit
    [fitresult1,gof1] = fit(xdata1,ydata1,ft,opts1);
    [fitresult2,gof2] = fit(xdata2,ydata2,ft,opts2);
    
    figure
    subplot(3,1,1), plot(magangcorrfunc(:,1),magangcorrfunc(:,2));
    subplot(3,1,2), plot(fitresult1,magangcorrfunc(:,1),magangcorrfunc(:,3));
    subplot(3,1,3), plot(fitresult2,magangcorrfunc(:,1),magangcorrfunc(:,4));

