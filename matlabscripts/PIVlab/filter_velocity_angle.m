function [unew,vnew]=filter_velocity_angle(u_filt,v_filt,mag_p,mag_w,ang_p,ang_w)
    cell_time_u = cell(63,63);
    cell_time_v = cell(63,63);
    mag = cell(63,63);
    ang = cell(63,63);
    ang2 = cell(63,63);
    ang_filt=cell(63,63);
    mag_filt=cell(63,63);
    
    datalen = length(u_filt);
    [mlx,mly] = size(u_filt{1,1});
    for i = 1:datalen
        disp('switching cell arrangement');
        disp(i);
        for j = 1:mlx
           for k = 1:mly
               mag{j,k}(i) = sqrt(u_filt{i,1}(j,k)^2 + v_filt{i,1}(j,k)^2);
               ang{j,k}(i)= u_filt{i,1}(j,k)/mag{j,k}(i);
           end
        end
        clc
    end
    
    unew = cell(datalen,1);
    vnew = cell(datalen,1);
        
    
    for j = 1:mlx
        clc
        disp('filtering magnitude and angle');
        disp(j);
        for k = 1:mly
            mag_filt{j,k} = sgolayfilt(mag{j,k},mag_p,mag_w);
            ang_filt{j,k} = sgolayfilt(ang{j,k},ang_p,ang_w);
            cell_time_u{j,k} = mag_filt{j,k}.*ang_filt{j,k};
            cell_time_v{j,k} = mag_filt{j,k}.*sin(acos(ang_filt{j,k}));
            
            for i = 1:datalen
                unew{i,1}(j,k)=cell_time_u{j,k}(i);
                vnew{i,1}(j,k)=cell_time_v{j,k}(i);
            end
        end
    end
    
    
    disp('Finished Filtering u and v');
end