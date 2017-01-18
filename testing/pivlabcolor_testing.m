load('100img1tiff_1.mat')
addpath('/data1/user_data/bacteria/matlabscripts/PIVlab');
filebase_image = strcat('/data1/user_data/bacteria/testing/images/');
filebase_results=strcat('/data1/user_data/bacteria/testing/results/');
pivlabvelspatialcorr(filebase_image,filebase_results,x,y,u_filt,v_filt,3,5)