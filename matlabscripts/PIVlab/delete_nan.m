function fixeddata = delete_nan(data)
%takes in data with occasional Nan values and replaces them with average of
%values around it.
    datalen = length(data);
    for i = 1:datalen
        if isnan(data(i))
            ind_def = closestnon_NAN(data,i);
            if i == 1            
                data(i) = data(ind_def);
            else
                data(i) = (data(ind_def)+data(i-1))/2;
            end
        end
    end
    fixeddata = data;
end
