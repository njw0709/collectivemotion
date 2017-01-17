function [h] = pivlabvelspatialcorr_img(filebase_read,name,xpos,ypos,xvel,yvel, radius)
%from Cisneros PRE 83,061907 (2011) equation 2
%radius in integer number of velocity field data points
%currently with square correlated region.  Non-optimal, but probably not
%too much of a problem

a = randi([1 1000],1,3);
for q = a
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
    
    fig = figure('Visible','off');
    set(gcf,'CreateFcn','set(gcf,''Visible'',''on'')');
    pcolor(xq,yq,result);
    shading interp;
    axis equal;
    axis tight;
    set(gca,'visible','off');
    caxis([0,1]);
    
    colormap('jet');
    colorbar
    plotname = [filebase_read,name,'color-',suffix];
    print(fig,plotname,'-dtiff');
    saveas(gcf,[filebase_read,strcat(name,'colormap')]);
    clc;
end
disp('Colormap Done');
end
