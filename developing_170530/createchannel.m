function canal = createchannel(srcFiles,channels,number_channels,j)

for i=1:number_channels   
   if  strfind((srcFiles(j).name),channels{i})>0
            canal = cell (number_channels,1);
            canal (i)= cellstr(srcFiles(j).name);
            for ii=1:number_channels
                 if ii ~= i            
                    elquebusquem = channels (i);
                    replace = channels (ii);
                    flst =  srcFiles(j).name;          
                    canal (ii)= cellstr(regexprep(flst,elquebusquem,replace));
                 end
            end
   end
end