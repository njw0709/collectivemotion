function rawmovie(filebase_read,filebase_write, framespersecond)
%TODO Give it results filebase to save movie there
movobj=VideoWriter([filebase_write,'July18201411_raw.avi']);
movobj.FrameRate = framespersecond;
open(movobj);
endnumber =1000;


for i=1:endnumber
    disp('Video Creation in Progress');
    disp(i)
    suffix = sprintf('%04d',i);
    close all;
    imname = strcat(filebase_read,suffix,'.tif');
    gr = imread(imname);
    fig = figure('Visible','off');
    set(0,'defaultaxesposition',[0 0 1 1]);
    imagesc(gr);
    colormap(gray);    
    axis equal;
    axis tight;
    axis([-200, 2300, -200, 2300]); 
    set(gca,'visible','off');    
    plotname = [filebase_read,'over-',suffix];
    print(fig,plotname,'-dtiff'); %UPDATE(S): Not working. 
    frame = imread(strcat(plotname,'.tif'));
    writeVideo(movobj,frame);
    clc;
end
%TODO delete everything in Image_data
close(movobj);
disp('RAW MOVIE DONE')
end