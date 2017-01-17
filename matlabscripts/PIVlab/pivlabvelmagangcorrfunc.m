function [h] = pivlabvelmagangcorrfunc(filebase, xpos,ypos,xvel,yvel, rstep, firsttstep,lasttstep)
%
%rstep is in pixels, assumes 2048x2048 images, t is in timesteps

%in process recoding according to my own calcs from little brown book
clf
maxr = floor(sqrt(2)*2048/rstep)  + 1;
rcorratt = zeros(length(xpos),maxr);

avcorr=zeros(maxr,8);

for q=firsttstep:lasttstep
    %load image q
    indexstr = int2str(q);
    suffix = '-0000';
    suffix(6-length(indexstr):5) = indexstr;
%    fname = [filebase,suffix,'_noflt.txt'];
%    xyuvs = load(fname);
%    [m,n]=size(xyuvs);
    xq = cell2mat(xpos(q));
    [m,n] = size(xq);
    yq = cell2mat(ypos(q));
    xvelq = cell2mat(xvel(q));
    yvelq = cell2mat(yvel(q));

    %test random matrix
    %xyuvs(:,3:n) = rand(m,n-2);
    %test ok, gives no correlation.  beyond 100 steps for 20 pix step it is
    %pretty bad statistics
    
    %testing correlation with matrix of all ones is a bad idea 0/0
    %changed it to add uncorrelated component to test DC offset
    %xyuvs(:,3:n) = ones(m,n-2) + 0.01*randn(m,n-2) ;

    %vector lists of velocity magnitudes and direction cosines for image q
    mag = sqrt(xvelq.*xvelq + yvelq.*yvelq);
    dircos = yvelq./mag;
    
%    flagmatrix = ones(maxr,m);
%    repeats = 0;
    
    %for each unique pair
    for i=1:m
        for j=i:n
            for k=1:m
                for l=1:n
            %distance in pixels between pair
            rpix = sqrt((xq(i,j)-xq(k,l))^2 + (yq(i,j)-yq(k,l))^2);   
            %index is number of rsteps in pixels apart they are
            ind = floor(rpix/rstep)+1;
    
       
            avcorr(ind,1) = avcorr(ind,1)+1; %adds one to the counter for the number of pairs at this separation
            avcorr(ind,2) = avcorr(ind,2)+mag(i,j)*mag(k,l); %increments running tally of sum(v_i*v_j) 
            avcorr(ind,3) = avcorr(ind,3)+dircos(i,j)*dircos(k,l);  %increments running tally of sum(dcos_i*dcos_j)
            avcorr(ind,4) = avcorr(ind,4)+ mag(i,j) + mag(k,l); %increments running tally of sum(v)
            avcorr(ind,5) = avcorr(ind,5)+mag(i,j)^2 + mag(k,l)^2; %increments running tally of sum(v^2)
            avcorr(ind,6) = avcorr(ind,6)+dircos(i,j) + dircos(k,l); %increments running tally of sum(dcos)
            avcorr(ind,7) = avcorr(ind,7)+dircos(i,j)^2 + dircos(k,l)^2;  %increments running tally of sum(dcos^2)
  
            %two versions from here:  above for averages and stddevs
            %calculated using all i's and j's as they come.  below a
            %flagged version which only uses each i or j once for each r
            %the above version seems to work, below version fails
            %self-correlation check.
            
            
%             if flagmatrix(ind,i)
%                 avcorr(ind,4) = avcorr(ind,4)+ mag(i); %increments running tally of sum(v)
%                 avcorr(ind,5) = avcorr(ind,5)+mag(i)^2 ; %increments running tally of sum(v^2)
%                 avcorr(ind,6) = avcorr(ind,6)+dircos(i); %increments running tally of sum(dcos)
%                 avcorr(ind,7) = avcorr(ind,7)+dircos(i)^2;  %increments running tally of sum(dcos^2)
%                 avcorr(ind,8) = avcorr(ind,8)+1;
%             else
%                 repeats = repeats+1;
%             end
%             
%             if flagmatrix(ind,j)
%                 avcorr(ind,4) = avcorr(ind,4)+ mag(j); %increments running tally of sum(v)
%                 avcorr(ind,5) = avcorr(ind,5)+ mag(j)^2; %increments running tally of sum(v^2)
%                 avcorr(ind,6) = avcorr(ind,6)+ dircos(j); %increments running tally of sum(dcos)
%                 avcorr(ind,7) = avcorr(ind,7)+ dircos(j)^2;  %increments running tally of sum(dcos^2)
%                 avcorr(ind,8) = avcorr(ind,8)+1;
%             else
%                 repeats = repeats+1;
%             end
%             
%             flagmatrix(ind,i)=0;
%             flagmatrix(ind,j)=0;
                end
            end
        end 
    end
%repeats    
end

%    magcorrfunc = (avcorr(:,2)./avcorr(:,1) - (avcorr(:,4)./avcorr(:,8)).^2)./(avcorr(:,5)./avcorr(:,8) - ((avcorr(:,4)./avcorr(:,8)).^2));
%    angcorrfunc = (avcorr(:,3)./avcorr(:,1) - (avcorr(:,6)./avcorr(:,8)).^2)./(avcorr(:,7)./avcorr(:,8) - ((avcorr(:,6)./avcorr(:,8)).^2));
    
    magcorrfunc = (avcorr(:,2)./avcorr(:,1) - (avcorr(:,4)./(2*avcorr(:,1))).^2)./(avcorr(:,5)./(2*avcorr(:,1)) - ((avcorr(:,4)./(2*avcorr(:,1))).^2));
    angcorrfunc = (avcorr(:,3)./avcorr(:,1) - (avcorr(:,6)./(2*avcorr(:,1))).^2)./(avcorr(:,7)./(2*avcorr(:,1)) - ((avcorr(:,6)./(2*avcorr(:,1))).^2));

    subplot(2,1,1), plot(magcorrfunc);
    subplot(2,1,2), plot(angcorrfunc);
    savefig
    rs = int2str(rstep);
    
    
    magangcorrfunc = [magcorrfunc,angcorrfunc]
    magcorrfunc
    angcorrfunc
    
    subplot(2,1,1), plot(magcorrfunc);
    subplot(2,1,2), plot(angcorrfunc);
    saveas(gcf,'corrfuncfig')
    
    
h = magangcorrfunc;
    
    
%svname = [filebase,rs,'numvcor',suffix,'.mat'];
%fid = fopen(svname,'w');
%fwrite(fid,magcorrfunc);
%fclose(fid);

%svname = [filebase,rs,'numdccor',suffix,'.mat'];
%fid = fopen(svname,'w');
%fwrite(fid,angcorrfunc);
%fclose(fid);

end
