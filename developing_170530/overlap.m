%Compute overlap between markers

function overlap(number_channels,channels,srcPath,min_pix,max_pix,NeuropilChannel,R)
%% Entrem per teclat variables i fem les diferents comprovacions
tic
fprintf('\n[ INITIALIZING... ]\n'); 
 mkdir(srcPath,'\Results');
 
 
%%%%%%%%%%%% Enter number of channels %%%%%%%%%%%%%
% prompt={'Enter number of channels'};
% name = 'channels';

%     answer = inputdlg(prompt,name,[1 40]);
%     number_channels = str2num(answer{:});

            if isempty(number_channels) %|| number_channels < 2
                message = sprintf('Sorry, but number of channels must be a float greater than zero... Lets try again! :)');
                uiwait(warndlg(message));
                return;
            end

%%%%%%%%%%%% Enter names of channels %%%%%%%%%%%%%            
% for k=1:number_channels
%   Prmpt{k} = ['Channel' num2str(k) ': '];
% end
% 
%     channels = inputdlg(Prmpt);
            for k=1:number_channels
                if isempty(channels{k})
                    message = sprintf('Sorry, but you have to enter %d channels! Lets try again! :)',number_channels);
                    uiwait(warndlg(message));
                    return;
                end
            end
 
%%%%%%%%%%%% Choose the images directory %%%%%%%%%%%%%
% srcPath = uigetdir('/media/Elements/ANALISI_AT/imatges_prova/coloc/segmented_2016/crops','Select the sequence path'); %DIRECTORI  ON ESTAN LES IMATGES


            if srcPath == 0 
                message = sprintf('Sorry, but you have to choice a directory... Lets try again! :)');
                uiwait(warndlg(message));
                return;
            end

    srcFiles = strcat(srcPath,'/*.tif');  % the folder in which ur images exists
    srcFiles = dir(srcFiles);

            if isempty(srcFiles)
                message = sprintf('Ouch! it seems that there are no tiff there... Lets try again! :)');
                uiwait(warndlg(message));
                return;
            end


    [x,y] = size(srcFiles);


            if x < 1 || x < number_channels
                message = sprintf('Ouch! You wanted to compare %d channels and there is not enough images in this directory...',number_channels);
                uiwait(warndlg(message));
                return;
            end
       
%%%%%%%%% set flag isprocessed to zero %%%%%%%
for j=1:x
srcFiles(j).isprocessed = 0;
end
row=0;
loop = 1;

%% image processing
for j =1:x   
    %% seek for the channel of this image and creates the channel structure with the other markers of the same sequence   
    if srcFiles(j).isprocessed == 0
        CurrentChannel=struct.empty;
          try
            channel_name = createchannel(srcFiles,channels,number_channels,j);
            if any(strcmp(channel_name,srcFiles(j).name))
                 %%% set flag isprocessed to 1
                for ii=1:number_channels   
                  for jj=1:x 
                        if  strcmp((srcFiles(jj).name),channel_name {ii}) == 1
                            Image = read_stackTiff(strcat(srcPath,'/',srcFiles(jj).name)); % read all .tiff stack
                            BW = logical(Image);
                            
                            if strfind((srcFiles(jj).name),NeuropilChannel)>0
                                [areaneuropil,neuropilmask] = Neuropil_mask (srcFiles(jj).name, srcPath, Image);
                                srcFiles(jj).areaneuropil = areaneuropil;
                            else
                               srcFiles(jj).areaneuropil = 0;
                            end
                                                        
                            minobj = min_pix {ii};
                            maxobj = max_pix {ii};
                            [srcFiles(jj).BW,srcFiles(jj).CC] = connectivity(BW,minobj,maxobj); % read all .tiff stack
                            
                            CurrentChannel(ii).name = srcFiles(jj).name;
                            CurrentChannel(ii).BW = srcFiles(jj).BW;
                            CurrentChannel(ii).CC = srcFiles(jj).CC; 
                            
                            break;
                        end
                  end      
                end
                
                fprintf(strcat('\nChannels read! Overlapping in process...\n'));
                if length (CurrentChannel) < number_channels
                     disp(strcat(srcFiles(j).name,' will not be processed.'));
                     disp(strcat ('No more channels found with the same name'));
                else
                    %% OVERLAPPING
                    [srcFiles,row,loop] = overlapping(srcFiles,CurrentChannel,number_channels,x,R,channels,srcPath,row,loop,neuropilmask);   
                end    
            end 
         catch             
             fprintf('\nWarning: Channel %s will not be processed\n',srcFiles(j).name);
         end
    end
end        
toc
fprintf('\n[ Overlapping done ]\n\n');   
  