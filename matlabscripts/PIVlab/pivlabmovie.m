function [h,gr] = pivlabmovie(xpos,ypos,xvel,yvel, filebase_read,filebase_write, framespersecond, arrowscale)
%TODO Give it results filebase to save movie there
movobj=VideoWriter([filebase_write,'vec.avi']);
movobj.FrameRate = framespersecond;
open(movobj);
endnumber =length(xpos);


for i=1:endnumber
    disp('Vector Overlay Video Creation in Progress');
    disp(i)
    suffix = sprintf('%04d',i+1);
    close all;
    imname = strcat(filebase_read,suffix,'.tif');
    gr = imread(imname);
    fig = figure('Visible','off');
    set(0,'defaultaxesposition',[0 0 1 1]);
    imagesc(gr);
    colormap(gray);    
    hold on  
    quiver(cell2mat(xpos(i)),cell2mat(ypos(i)),cell2mat(xvel(i)),cell2mat(yvel(i)),arrowscale);
    axis equal;
    axis tight;
    axis([-200, 2300, -200, 2300]); 
    set(gca,'visible','off');    
    plotname = [filebase_read,'over-',suffix];
    print(fig,plotname,'-dtiff'); %UPDATE(S): Not working. 
    frame = imread(strcat(plotname,'.tif'));
    writeVideo(movobj,frame);
    hold off
    clc;
end
%TODO delete everything in Image_data
close(movobj);
disp('VECTOR OVERLAY MOVIE DONE')
end