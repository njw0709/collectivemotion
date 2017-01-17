function create_histogram(pix2micron,u_filt,v_filt,u_new,v_new,filebase_results,name,framespersec)
   
    u_filt = cell2mat(u_filt);
    v_filt = cell2mat(v_filt);
    u_new = cell2mat(u_new);
    v_new = cell2mat(v_new);
    filt_velmag = framespersec*pix2micron.*sqrt(abs(u_filt.^2 + v_filt.^2));
    new_velmag = framespersec*pix2micron.*sqrt(abs(u_new.^2 + v_new.^2));
    
    
    fig1 = figure('Visible','off');
    set(gcf,'CreateFcn','set(gcf,''Visible'',''on'')');
    
        % Create subplot
    subplot1 = subplot(2,1,1,'Parent',fig1);
    box(subplot1,'on');
    hold on
    % Create histogram
    histogram(filt_velmag,'Parent',subplot1,'EdgeColor',[0 0 0],'FaceColor','auto',...
        'Normalization','count',...
        'BinMethod','auto');
    
    sp = pix2micron*framespersec;
    line([sp sp],get(gca,'ylim'),'Color',[1 0 0]);
    % Create xlabel
    xlabel('Velocity [um/s]');
    axis 'auto x';
    axis 'auto y';

    % Create title
    title({strcat(name,' Before and After Filtering')});
    
    
    % Create subplot
    subplot2 = subplot(2,1,2,'Parent',fig1);
    box(subplot2,'on');

    % Create histogram
    histogram(new_velmag,'Parent',subplot2,'EdgeColor',[0 0 0],'FaceColor','auto',...
        'Normalization','count',...
        'BinMethod','auto');

    line([sp sp],get(gca,'ylim'),'Color',[1 0 0]);
    % Create xlabel
    xlabel('Velocity [um/s]');
    axis 'auto x';
    axis 'auto y';

    
    saveas(gcf,[filebase_results,strcat(name,'hist')])
end