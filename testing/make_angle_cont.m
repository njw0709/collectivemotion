function res = make_angle_cont(angledata)
    datalen = length(angledata)-1;
    diff_data = diff(angledata);
    ind = find(abs(diff_data)>1.5);
    for i = ind
       if sign(diff_data(i))==1
           angledata(i+1:end) = angledata(i+1:end)-pi;
       else
           angledata(i+1:end) = angledata(i+1:end)+pi;
       end
    end
        res = angledata;    
end