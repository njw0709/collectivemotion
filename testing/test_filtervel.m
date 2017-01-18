clear;
close all
load('July18201411.mat','u_filt','v_filt');
addpath('/data1/user_data/bacteria/matlabscripts/PIVlab');
[ang,ang_filt,mag,mag_filt,unew,vnew] = filter_velocity_angle(u_filt,v_filt,3,15,3,21);
figure
hold on
plot(ang{1,1},'r-');
plot(ang_filt{1,1},'b-');
hold off

figure
hold on
plot(mag{1,1},'r-');
plot(mag_filt{1,1},'b-');
hold off

