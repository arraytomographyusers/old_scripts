function GUI_createstack()

S.fh(1) = figure('units','pixels',...
              'position',[300 300 200 70],...
              'menubar','none',...
              'name',' Stacking',...
              'numbertitle','off',...
              'resize','off');            
S.pb(1) = uicontrol('style','push',...
                 'unit','pix',...
                 'position',[20 20 160 30],...
                 'string','Analyze',...
                 'callback',{@analyze,S},...
                 'enable','off');
S.fm = uimenu(S.fh,...
                 'label','Select path',...
                 'callback',{@fm_call,S},...
                 'enable','on');     
             
             S.enable = 0;
        
    function [] = analyze(varargin)
    % Callback for pushbutton.
     try
       path = get(S.ed(99),'string');
       number_channels = get(S.ed(98),'Value');
        
       for i=1:number_channels
           channels{i}=get(S.ed(i),'String');
       end
       
       col = get(S.pb(1),'backg');  % Get the background color of the figure.
       pause(.05)
       set(S.pb(1),'str','RUNNING...','backg',[1 .6 .6]) 
       set(S.ed(99),{'enable'},{'off'});
       
       for i=1:number_channels
           set(S.ed(i),{'enable'},{'off'});
       end
              
       pause(.04)
       createstack(path,channels);
       pause(.05)
       
       set(S.pb(1),'str','Analyze','backg',col) 
       set(S.ed(99),{'enable'},{'on'});

       for i=1:number_channels
           set(S.ed(i),{'enable'},{'on'});
       end
     catch
       disp('[GUI_stack] Unable to stack these channels, review the parameters.')
       set(S.fh(1),'position',[300 300 200 70]); 
       set(S.pb(1),'str','Analyze','backg',col) 
       set(S.pb(1),{'enable'},{'on'});  
     end
       
  % Now reset the button features.
    end

    function [] = fm_call(varargin)     
         try
            S.fh(2) = figure('units','pixels',...
                 'position',[300 200 290 60],...
                 'name','Path',...
                 'menubar','none',...
                 'numbertitle','off');
             S.tx(2) = uicontrol('units','pixels',...
                  'style','edit',...
                  'unit','pix',...
                  'position',[20 15 260 30],...
                   'string','No path selected');
            S.ed(99) = uicontrol('units','pixels',...
                  'style','edit',...
                  'unit','pix',...
                  'position',[20 15 260 30],...
                   'string','No path selected');
            S.ed(98) = uicontrol('units','pixels',...
                  'style','edit',...
                  'unit','pix',...
                  'position',[20 15 260 30],...
                   'Value',0);
               
            topLevelFolder = uigetdir('C:\Users\Usuario','Select the sequence path'); %DIRECTORI  ON ESTAN LES IMATGES
            set(S.ed(99),'string',topLevelFolder);
            
            %%%%%%%%%%%%%%%%%%%%%%%%% looking for the number of channels %%%%%%%%%%%%%%%%%%%%%
            if topLevelFolder == 0
                message = sprintf('Sorry, but you have to choice a directory... Lets try again! :)');
                uiwait(warndlg(message));
                return;
            end

            % Get list of all subfolders.
            allSubFolders = genpath(topLevelFolder);
            % Parse into a cell array.
            remain = allSubFolders;
            listOfFolderNames = {};

            while true
                [singleSubFolder, remain] = strtok(remain, ';');
                if isempty(singleSubFolder)
                    break;
                end
                listOfFolderNames = [listOfFolderNames singleSubFolder];
            end
            numberOfFolders = length(listOfFolderNames);

            for k = 1 : numberOfFolders
                % Get this folder and print it out.
                thisFolder = listOfFolderNames{k};

                % Add on TIF files.
                filePattern = sprintf('%s/*.tif', thisFolder);
                baseFileNames = dir(filePattern);
                numberOfImageFiles = length(baseFileNames);

                % Now we have a list of all files in this folder.   
                if (numberOfImageFiles >= 1)

                    % get the first image and see how many channels has it
                    fullFileName = fullfile(thisFolder, baseFileNames(1).name);
                    info = imfinfo(fullFileName);
                    for ii = 1:length(info)
                        pos = strfind(info(ii).ImageDescription,'Filter1 =');
                        pos = pos + 10;
                        name = info(ii).ImageDescription(pos:pos+2);
                        chan(ii).name = name; 
                        if isempty(pos)
                            chan(ii).name = strcat('Channel ',num2str(ii));
                        end
                    end
                    break;
                end
            end
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% end of seeking channels %%%%%%%%%%%%%%%%%%%%%%%
            numchan = length(info);
            height = (numchan-1)*44 + 110;
            
            set(S.ed(98),'Value',numchan);
            
            set(S.fh(1),{'position'},{[300 300 200 height]});
            num = numchan;
             for i=1:numchan
                 chan_name = chan(i).name;
                 pos = 40*(num)+30;
                 S.tx(i) = uicontrol('units','pixels',...
                     'style','text',...
                     'unit','pix',...
                     'position',[25 pos+5 50 15],...
                     'string',chan_name);    
                 S.ed(i) = uicontrol('style','edit',...
                     'unit','pix',...
                     'position',[80 pos 80 25],...
                     'string',chan_name);
                 num=num-1;
             end

             pos2 = 40*(num)+225;
             S.txchannels = uicontrol(S.fh(1),...
                 'units','pixels',...
                 'style','text',...
                 'unit','pix',...
                 'position',[20 pos2 170 12],...
                 'string','Introduce channel names');   
       
            set(S.pb(1),{'enable'},{'on'});
            set(S.fh(1),'CloseRequestFcn', @preCloseMain);
         catch
            disp('[GUI_stack] Unable to stack these channels, review the parameters.')
         end
    end

    function preCloseMain(varargin)
      try 
%        fprintf('Closing non-main figures!\n');
        close(S.fh(2));
      end 
%      fprintf('Closing main figure!\n');     
      delete(S.fh(1));
    end

end