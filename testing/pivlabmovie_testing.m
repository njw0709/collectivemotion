load('100img1tiff_1.mat')
addpath('/data1/user_data/bacteria/matlabscripts');
filebase_image = strcat('/data1/user_data/bacteria/testing/images/');
filebase_results=strcat('/data1/user_data/bacteria/testing/results/');
pivlabmovie(x,y,u_filt,v_filt,filebase_image,filebase_results,5,1.6);