function [h] = pivlabvelspatialcorr(filebase_read,filebase_write,xpos,ypos,xvel,yvel, radius, framespersecond)
%from Cisneros PRE 83,061907 (2011) equation 2
%radius in integer number of velocity field data points
%currently with square correlated region.  Non-optimal, but probably not
%too much of a problem

movobj=VideoWriter([filebase_write,'color.avi']);
movobj.FrameRate = framespersecond;
open(movobj)

for q = 1:length(xpos)
    disp('Processing Colormap');
    disp(q);
    suffix = sprintf('%04d',q+1);
    xq = cell2mat(xpos(q));
    yq = cell2mat(ypos(q));
    xvq = cell2mat(xvel(q));
    yvq = cell2mat(yvel(q));
    
    [side,n]=size(xq);
    
    result = zeros(side,side);
    for i=1+radius:side-radius
        for j=1+radius:side-radius
           summand = 0;
           count = 0;
           for l=i-radius:i+radius
               for k=j-radius:j+radius
                   summand = summand+ (xvq(l,k)*xvq(i,j) + yvq(l,k)*yvq(i,j))/(norm([xvq(l,k),yvq(l,k)])*norm([xvq(i,j),yvq(i,j)]));
                   count = count + 1;
               end
           end
           result(i,j) = summand/count;
        end       
    end
%    svname = [filebase,'vcor',suffix,'.mat'];
%    fid = fopen(svname,'w');
%    fwrite(fid,result);
%    fclose(fid);
    
%TODO Change the gcf to saving and reading again Done.
    fig = figure('Visible','off');
    pcolor(xq,yq,result);
    shading interp;
    axis equal;
    axis tight;
    set(gca,'visible','off');
    caxis([-1,1]);
    colormap('default');
    plotname = [filebase_read,'color-',suffix];
    print(fig,plotname,'-dtiff');
    frame = imread(strcat(plotname,'.tif'));    
    writeVideo(movobj,frame);
    clc;
end
close(movobj)
disp('Colormap Movie Done');
end
