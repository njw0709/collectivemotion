function [unew,vnew]=filter_velocity(u_filt,v_filt,pol,win_size)
    cell_time_u = cell(63,63);
    cell_time_v = cell(63,63);
    cell_time_u_unf = cell(63,63);
    cell_time_v_unf = cell(63,63);
    
    datalen = length(u_filt);
    [mlx,mly] = size(u_filt{1,1});
    for i = 1:datalen
        for j = 1:mlx
           for k = 1:mly
               cell_time_u_unf{j,k}(i)=u_filt{i,1}(j,k);
               cell_time_v_unf{j,k}(i)=v_filt{i,1}(j,k);
           end
        end 
    end
    
    unew = cell(datalen,1);
    vnew = cell(datalen,1);
    
    for j = 1:mlx
        for k = 1:mly
            clc
            disp('filtering');
            disp(j);
            cell_time_u{j,k} = sgolayfilt(cell_time_u_unf{j,k},pol,win_size);
            cell_time_v{j,k} = sgolayfilt(cell_time_v_unf{j,k},pol,win_size);
            for i = 1:datalen
                unew{i,1}(j,k)=cell_time_u{j,k}(i);
                vnew{i,1}(j,k)=cell_time_v{j,k}(i);
            end
        end
    end
    disp('Finished Filtering u and v');
end