%% Create Color map macro
dirname = '/data2/user_data/bacteria/July29/';
Files = dir(dirname);
addpath /data1/user_data/bacteria/matlabscripts/PIVlab;
filebase_image = '/data2/user_data/bacteria/imageoverlaybuffer/July29/';
filebase_aviresults='/data2/user_data/bacteria/results/July29_avi/';

mkdir(filebase_image);
mkdir(filebase_aviresults);

for k = 3:length(Files)
    disp(k);
    [pathstr,name,ext] = fileparts(Files(k).name);
%     command = ['rm ',filebase_image,'*.tif'];
%     system(command);
%     disp('Cleaned image buffer folder');
    load(strcat(dirname,name,ext),'x','y','u_filt','v_filt');   
    pivlabvelspatialcorr_img(filebase_image,name,x,y,u_filt,v_filt,5);
end