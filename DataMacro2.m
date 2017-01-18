function DataMacro2(filepath)
%%Filepath specifies file directory each screen is going through, which will
%%be under cxdfolder

addpath /data1/user_data/bacteria/matlabscripts/PIVlab
addpath /data1/user_data/bacteria/matlabscripts/bfmatlab

%TODO: add list of file names that each screen will run through
Files = dir(strcat('/data2/user_data/bacteria/cxdfolder/',filepath));

%or make a list of files
filebase_image = strcat('/data2/user_data/bacteria/imageoverlaybuffer/',filepath,'/');
filebase_results=strcat('/data2/user_data/bacteria/results/',filepath,'/');
filebase_aviresults=strcat(filebase_results,'movies/');
filebase_figresults=strcat(filebase_results,'figures/');
mkdir(filebase_image);
mkdir(filebase_results);
mkdir(filebase_aviresults);
mkdir(filebase_figresults);

csvresults = {'filename','cfunc_velmag','cf_result_velmag','gof_velmag','range_velmag','cf_result_velang','gof_velang','range_velang','cfunc_time','cfresult_time_mag','gof_time_mag','range_time_mag','cfresult_time_ang','gof_time_ang','range_time_ang','runtime'};
time = zeros(1,length(Files)-2);
tic;
for k = 3:length(Files)
    [pathstr,name,ext] = fileparts(Files(k).name);
    command = ['rm ',filebase_image,'*.tif'];
    system(command);
    disp('Cleaned image buffer folder');
    data = bfopen(strcat('/data2/user_data/bacteria/cxdfolder/',filepath,'/',Files(k).name)); % working
    disp(strcat('BF OPEN DONE',name)) 
    
    %write data to tif images
        for i=1:1000
          disp('SAVING IMAGES')
          disp(i)
          plotname=[filebase_image,strcat(sprintf('%04d',i),'.tif')];
          imwrite(data{1,1}{i,1},plotname);
          clc
        end
    disp('SAVING IMAGE DONE')
    clearvars data;
    directory = filebase_image;
    PIVlab_commandline; %working!!
    [u_new,v_new] = filter_velocity_angle(u_filt,v_filt,3,15,3,21);
    save(strcat(filebase_results,name,'.mat'));
    create_histogram(0.1595,u_filt,v_filt,u_new,v_new,filebase_figresults,name);
    pivlabmovie(x,y,u_new,v_new,filebase_image,strcat(filebase_aviresults,name),10,1.6)
    pivlabvelspatialcorr(filebase_image,strcat(filebase_aviresults,name),x,y,u_filt,v_filt,2,10)
%     save(strcat('/data1/user_data/bacteria/testing/','1000imgset.mat'));%strcat(filebase_results,name,'wsp.mat'));
    [cfunc_vel,fit1_vel,fit2_vel,gof1_vel,gof2_vel,range_vmag,range_vang] = pivlabvelcorrfuncnonorm(x,y,u_filt,v_filt,20,0.1595,filebase_figresults,name);%number of datapoints
    [cfunc_t,fit1_t,fit2_t,gof1_t,gof2_t,range_tmag,range_tang] = pivlabvelmagangtimecorr(u_filt,v_filt,1/50,filebase_figresults,name);
    time(k) = toc;
    csvappend = {Files(k).name,cfunc_vel,fit1_vel,gof1_vel,range_vmag,fit2_vel,gof2_vel,range_vang,cfunc_t,fit1_t,gof1_t,range_tmag,fit2_t,gof2_t,range_tang,time(k)};
    csvresults = vertcat(csvresults,csvappend);
    save(strcat(filebase_results,name,'.mat'));
    disp(strcat('Done with',Files(k).name));
end
save(strcat(filebase_results,'final','.mat'),'csvresults');
disp(strcat('Saving all results, ',filepath,'Done'));
end