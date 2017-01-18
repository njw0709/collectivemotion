load('100img1tiff_1.mat')
addpath('/data1/user_data/bacteria/matlabscripts/PIVlab');
filebase_image = strcat('/data1/user_data/bacteria/testing/images/');
filebase_results=strcat('/data1/user_data/bacteria/testing/results/');
%pivlabvelcorrfuncnonorm(xpos,ypos,xvel,yvel, rstep, firsttstep,lasttstep,pix2micron,filebase_results,name)
[cfunc_vel,fit1_vel,fit2_vel,gof1_vel,gof2_vel] = pivlabvelcorrfuncnonorm(x,y,u_filt,v_filt,60,0.1595,filebase_results,name);%number of datapoints
%% gof parameters
% sse
% Sum of squares due to error

% rsquare
% R-squared (coefficient of determination)

% dfe
% Degrees of freedom in the error

% adjrsquare
% Degree-of-freedom adjusted coefficient of determination

% rmse
% Root mean squared error (standard error)