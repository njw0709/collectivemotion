%% Create Color map macro
dirname = '/data1/user_data/bacteria/Aug1colormap/';
Files = dir(dirname);
addpath /data1/user_data/bacteria/matlabscripts/PIVlab;
filebase_image = '/data1/user_data/bacteria/imageoverlaybuffer/Aug1colormap/';
filebase_aviresults='/data1/user_data/bacteria/results/Aug1colormap/';

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