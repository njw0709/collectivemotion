function [xn,yn,un,vn] = aver_data(x,y,u,v,stepsize)
    
    
    xn = cell(floor(length(x)/stepsize),1);
    yn = cell(floor(length(y)/stepsize),1);
    un = cell(floor(length(u)/stepsize),1);
    vn = cell(floor(length(v)/stepsize),1);
    
    for i = 1:length(xn)
        for j = 1:stepsize
            xn{i,1} = x{stepsize*i-j+1,1};
            yn{i,1} = y{stepsize*i-j+1,1};
            un{i,1} = u{stepsize*i-j+1,1};
            vn{i,1} = v{stepsize*i-j+1,1};
        end
        xn{i,1} = xn{i,1}./stepsize;
        yn{i,1} = yn{i,1}./stepsize;
        un{i,1} = un{i,1}./stepsize;
        vn{i,1} = vn{i,1}./stepsize;
    end
    

end