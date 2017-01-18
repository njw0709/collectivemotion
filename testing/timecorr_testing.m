load('/data1/user_data/bacteria/testing/cftime_testing/July18201414.mat');
close all
addpath('/data1/user_data/bacteria/matlabscripts/PIVlab');
filebase_image = strcat('/data1/user_data/bacteria/testing/images/');
filebase_results=strcat('/data1/user_data/bacteria/testing/cftime_testing/filter/');
name = 'July18_14filter'
%[cfunc_t,fit1_t,fit2_t,gof1_t,gof2_t] = pivlabvelmagangtimecorr(xvel,yvel,firsttstep,lasttstep,timeperframe,filebase_results,name) 

[u_filt,v_filt] = filter_velocity_angle(u_filt,v_filt,3,15,3,21);
[cfunc_t,fit1_t,fit2_t,gof1_t,gof2_t,range1,range2]=pivlabvelmagangtimecorr(u_filt,v_filt,1/50,filebase_results,name);
save(strcat(filebase_results,'July18_14filter'));