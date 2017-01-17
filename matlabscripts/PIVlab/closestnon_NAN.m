function index = closestnon_NAN(data,sindex)
    startindex = sindex+1;
    if startindex>=length(data)
        index = sindex-1;
    else
        a = true;
        while a
            if startindex==length(data)
                index = sindex-1; 
                a=false;                
            else
                if isnan(data(startindex))
                    startindex = startindex+1;
                else
                    index = startindex;
                    a = false;                    
                end
            end
        end        
    end
end