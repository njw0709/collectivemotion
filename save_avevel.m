clear

Files = dir('/data1/user_data/bacteria/results/June20_rawdata/');
vel_data_June20 = cell(length(Files)-2,5);
for i = 3:length(Files)
   disp(i);
   [pathstr,name,ext] = fileparts(Files(i).name);
   load(strcat('/data1/user_data/bacteria/results/June20_rawdata/',name,ext),'u_filt','v_filt','name'); 
   mag = sqrt(cell2mat(u_filt).^2+cell2mat(v_filt).^2);
   avemag = mean(mean(mag));
   avemagsq = mean(mean(mag.^2));
   dcos = cell2mat(v_filt)./mag;
   avedcos = mean(mean(dcos));
   avedcossq = mean(mean(dcos.^2));
   
   vel_data_June20{i-2,1} = name;
   vel_data_June20{i-2,2} = avemag;
   vel_data_June20{i-2,3} = avemagsq;
   vel_data_June20{i-2,4} = avedcos;
   vel_data_June20{i-2,5} = avedcossq;
   clearvars -except vel_data_June20 i Files
end