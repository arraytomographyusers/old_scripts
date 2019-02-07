function GUI_colocalitzation()

S.fh(1) = figure('units','pixels',...
              'position',[300 300 290 170],...
              'menubar','none',...
              'name',' Colocalitzation',...
              'numbertitle','off',...
              'resize','off');      
S.tx(1) = uicontrol('units','pixels',...
                 'style','text',...
                 'unit','pix',...
                 'position',[50 115 200 40],...
                 'string','Number of channels');    
S.ed(1) = uicontrol('style','edit',...
                 'unit','pix',...
                 'position',[110 110 80 25]);            
S.pb(1) = uicontrol('style','push',...
                 'unit','pix',...
                 'position',[20 10 260 30],...
                 'string','Analyze',...
                 'callback',{@analyze,S},...
                 'enable','off');
S.pb(2) = uicontrol('style','push',...
                 'unit','pix',...
                 'position',[20 50 260 30],...
                 'string','Next >>',...
                 'callback',{@next,S},...
                 'enable','off');
S.pb(3) = uicontrol('style','push',...
                 'unit','pix',...
                 'position',[20 50 125 30],...
                 'string','<< Back',...
                 'callback',{@back,S},...
                 'visible','off');
S.pb(4) = uicontrol('style','push',...
                 'unit','pix',...
                 'position',[155 50 125 30],...
                 'string','Get Density Stats',...
                 'callback',{@densities},...
                 'visible','off');
S.pb(5) = uicontrol('style','push',...
                 'unit','pix',...
                 'position',[20 90 125 30],...
                 'string','Active Synapses',...
                 'callback',{@active_synapses,S},...
                 'visible','off');
S.fm = uimenu(S.fh,...
                 'label','Select path',...
                 'callback',{@fm_call,S},...
                 'enable','on');     
       
             S.NAME = {'No sequence selected'};

             S.enable = 0;
        
    function [] = analyze(varargin)
    % Callback for pushbutton.
     try
       number_channels = str2double(get(S.ed(1),'string')); 
       path = get(S.ed(2),'string');
       R = get(S.ch(2),'Value');
       
       try
           active_synap = {};
           L = get(S.pp(1),'Value');
           active_synap{1} = S.NAME{L};
           
           L2 = get(S.pp(2),'Value');
           active_synap{2} = S.NAME{L2};
       catch
           active_synap = {};
           disp('Active Synapses not selected')
       end
       
%%%% get channel names and min and max pixels per channel
       for i=1:number_channels    
           channels{i} = get(S.ed(i+4),'string');
                
           min_size {i} = get(S.edmin(i),'string');
           max_size {i}= get(S.edmax(i),'string');

            min_size {i} = str2double(min_size {i});
            if strcmp(max_size {i},'inf')
                max_size {i} = 999999;
            else
                max_size {i} = str2double(max_size{i});
            end
       end
           
       NeuropilChannel = get(S.edneuropil,'string');
       col = get(S.pb(1),'backg');  % Get the background color of the figure.
       pause(.05)
       set(S.pb(1),'str','RUNNING...','backg',[1 .6 .6]) 
       set(S.pb(3),{'enable'},{'off'});
       set(S.pb(4),{'enable'},{'off'});
       set(S.pb(5),{'enable'},{'off'});
       set(S.ed(1),{'enable'},{'off'});
       set(S.ed(2),{'enable'},{'off'});
       set(S.edneuropil,{'enable'},{'off'});
       set(S.ch(2),{'enable'},{'off'});
       try
            set(S.pp(1),{'enable'},{'off'});
            set(S.pp(2),{'enable'},{'off'});
       catch
       end
       
       for i=1:number_channels
           set(S.ed(i+4),{'enable'},{'off'});
           set(S.edmin(i),{'enable'},{'off'});
           set(S.edmax(i),{'enable'},{'off'});
       end
              
       pause(.01)
       overlap_v2(path, channels, active_synap, min_size, max_size, NeuropilChannel, R);

       pause(.05)
       set(S.pb(1),'str','Analyze','backg',col) 
       set(S.pb(3),{'enable'},{'on'});
       set(S.ed(1),{'enable'},{'on'});
       set(S.ed(2),{'enable'},{'on'});
       set(S.pb(4),{'enable'},{'on'});
       set(S.pb(5),{'enable'},{'on'});
       set(S.edneuropil,{'enable'},{'on'});
       set(S.ch(2),{'enable'},{'on'});
       
       for i=1:number_channels
           set(S.ed(i+4),{'enable'},{'on'});
           set(S.edmin(i),{'enable'},{'on'});
           set(S.edmax(i),{'enable'},{'on'});
       end
       try
        set(S.pp(1),{'enable'},{'on'});
        set(S.pp(2),{'enable'},{'on'});
       catch
       end
     catch   
       set(S.pb(1),'str','Analyze','backg',col) 
       set(S.pb(3),{'enable'},{'on'});
       set(S.ed(1),{'enable'},{'on'});
       set(S.ed(2),{'enable'},{'on'});
       set(S.pb(4),{'enable'},{'on'});
       set(S.pb(5),{'enable'},{'on'});
       set(S.edneuropil,{'enable'},{'on'});
       set(S.ch(2),{'enable'},{'on'});
       disp('[GUI_coloc] Unable to colocalize these channels, review the parameters.')
     end
       
  % Now reset the button features.
    end

    function [] = densities(varargin)
    % Callback for pushbutton.
     try
       path = get(S.ed(2),'string');
       number_channels = str2double(get(S.ed(1),'string')); 
%%%% get channel names and min and max pixels per channel
       for i=1:number_channels    
           channels{i} = get(S.ed(i+4),'string');
       end
       NeuropilChannel = get(S.edneuropil,'string');
       
       col = get(S.pb(1),'backg');  % Get the background color of the figure.
       pause(.01)
       set(S.pb(4),'str','RUNNING...','backg',[1 .6 .6]);
       set(S.pb(1),{'enable'},{'off'});
       set(S.pb(3),{'enable'},{'off'});
       set(S.ed(1),{'enable'},{'off'});
       set(S.ed(2),{'enable'},{'off'});
       set(S.edneuropil,{'enable'},{'off'});
       set(S.ch(2),{'enable'},{'off'});
       
       for i=1:number_channels
           set(S.ed(i+4),{'enable'},{'off'});
           set(S.edmin(i),{'enable'},{'off'});
           set(S.edmax(i),{'enable'},{'off'});
       end
              
       pause(.01)
       density(path, channels, NeuropilChannel);

       pause(.01)
       set(S.pb(4),'str','Density Stats','backg',col) 
       set(S.pb(3),{'enable'},{'on'});
       set(S.pb(1),{'enable'},{'on'});
       set(S.ed(1),{'enable'},{'on'});
       set(S.ed(2),{'enable'},{'on'});
       set(S.edneuropil,{'enable'},{'on'});
       set(S.ch(2),{'enable'},{'on'});
       for i=1:number_channels
           set(S.ed(i+4),{'enable'},{'on'});
           set(S.edmin(i),{'enable'},{'on'});
           set(S.edmax(i),{'enable'},{'on'});
       end
     catch
         
       set(S.pb(1),'str','Density Stats','backg',col) 
       set(S.pb(1),{'enable'},{'on'});
       set(S.ed(1),{'enable'},{'on'});
       set(S.ed(2),{'enable'},{'on'});
       set(S.edneuropil,{'enable'},{'on'});
       set(S.ch(2),{'enable'},{'on'});
       disp('[GUI_coloc] Unable to extract densities of these channels, review the parameters.')
     end
%        
  % Now reset the button features.
    end

    function [] = active_synapses(varargin)  
        try
            number_channels = str2double(get(S.ed(1),'string'));
            if number_channels>1
               for i=1:number_channels    
                   channels{i} = get(S.ed(i+4),'string');
               end
               S.NAME = channels;
               
                S.fh(3) = figure('units','pixels',...
                     'position',[620 450 160 100],...
                     'name','Select channels to ActSyn',...
                     'menubar','none',...
                     'numbertitle','off');
                S.tx1 = uicontrol('units','pixels',...
                      'style','text',...
                      'unit','pix',...
                      'position',[10 80 130 15],...
                       'string','Select channels to ActSyn'); 

                S.pp(1) = uicontrol(S.fh(3),...
                    'style','popupmenu',...
                    'unit','pixels',...
                    'position',[15 10 130 30],...
                    'string',S.NAME);
                set(S.pb,{'enable'},{'on'});
                
                S.pp(2) = uicontrol(S.fh(3),...
                    'style','popupmenu',...
                    'unit','pixels',...
                    'position',[15 45 130 30],...
                    'string',S.NAME);
                set(S.pb,{'enable'},{'on'});
            else
                disp('[GUI coloc] Active synapses at least 2 channels')
            end
         catch
            disp('[GUI coloc] Error active synapses')
        end
    end
    function [] = next(varargin)
        
        numchan = str2double(get(S.ed(1),'string'));
        height = (numchan-1)*44 + 210;
        try
            set(S.fh(1),{'position'},{[300 300 290 height]});
            set(S.tx(1),{'visible'},{'off'});
            set(S.ed(1),{'visible'},{'off'});
            num = numchan;
             for i=5:numchan+4
                 chan_name = strcat('Ch:    ', num2str(i-4));
                 pos = 40*(num)+110;
                 S.tx(i) = uicontrol('units','pixels',...
                     'style','text',...
                     'unit','pix',...
                     'position',[15 pos+5 50 15],...
                     'string',chan_name);    
                  S.ed(i) = uicontrol('style','edit',...
                     'unit','pix',...
                     'position',[60 pos 80 25]);
                  S.edmin(i-4) = uicontrol(S.fh(1),...
                  'style','edit',...
                 'unit','pix',...
                 'position',[170 pos 50 25],...
                 'string','3');    
                  S.edmax(i-4) = uicontrol(S.fh(1),...
                  'style','edit',...
                 'unit','pix',...
                 'position',[230 pos 50 25],...
                 'string','inf'); 
                 num=num-1;
             end

             S.ch(2) = uicontrol('style','checkbox',...
                     'unit','pix',...
                     'position',[25 120 160 30],...
                     'Value',1,...
                     'string','Use randomize');
             
             num = numchan;
              pos2 = 40*(num)+140;
                 S.txchannels = uicontrol(S.fh(1),...
                 'units','pixels',...
                 'style','text',...
                 'unit','pix',...
                 'position',[10 pos2+10 170 12],...
                 'string','Introduce channel names');  
                 S.txpix = uicontrol(S.fh(1),...
                 'units','pixels',...
                 'style','text',...
                 'unit','pix',...
                 'position',[170 pos2+18 70 12],...
                 'string','Filter by size');  
                S.txmin = uicontrol(S.fh(1),...
                 'units','pixels',...
                 'style','text',...
                 'unit','pix',...
                 'position',[170 pos2 40 12],...
                 'string','From...');    
                S.txmax = uicontrol(S.fh(1),...
                'units','pixels',...
                 'style','text',...
                 'unit','pix',...
                 'position',[220 pos2 40 12],...
                 'string','To...'); 
             
                S.txneuropil = uicontrol(S.fh(1),...
                'units','pixels',...
                 'style','text',...
                 'unit','pix',...
                 'position',[115 130 200 12],...
                 'string','neuropil area with'); 
               S.edneuropil = uicontrol(S.fh(1),...
                  'style','edit',...
                 'unit','pix',...
                 'position',[170 95 100 25],...
                 'string','syph'); 

            set(S.pb(2),{'visible'},{'off'});
            set(S.pb(3),{'visible'},{'on'});   
            set(S.pb(4),{'visible'},{'on'});
            set(S.pb(5),{'visible'},{'on'});
            set(S.pb(1),{'enable'},{'on'});
        catch
            disp('Unable to set channels. Check number of channels and try again');
        end     
    end

    function [] = back(varargin)
       
        try
             numchan = str2double(get(S.ed(1),'string'));
             set(S.tx(1),{'visible'},{'on'});
             set(S.ed(1),{'visible'},{'on'});
             set(S.pb(2),{'visible'},{'on'});
             
             set(S.fh(1),{'position'},{[300 300 290 160]});
             set(S.txneuropil,{'visible'},{'off'});
             set(S.edneuropil,{'visible'},{'off'});
             set(S.pb(3),{'visible'},{'off'});  
             set(S.pb(4),{'visible'},{'off'});
             set(S.pb(5),{'visible'},{'off'});
             set(S.ch(2),{'visible'},{'off'});  
             set(S.txchannels,{'visible'},{'off'});
             
             for i=5:numchan+4
                  set(S.tx(i),{'visible'},{'off'});
                  set(S.ed(i),{'visible'},{'off'});
                  set(S.edmin(i-4),{'visible'},{'off'});
                  set(S.edmax(i-4),{'visible'},{'off'});  
             end
             
            set(S.txpix,{'visible'},{'off'});
            set(S.txmin,{'visible'},{'off'});
            set(S.txmax,{'visible'},{'off'});
        catch
            disp('Unable to set channels. Check number of channels and try again');
        end     
    end

    function [] = fm_call(varargin)     
         try
            S.fh(2) = figure('units','pixels',...
                 'position',[300 200 290 60],...
                 'name','Select sequence to previsualize',...
                 'menubar','none',...
                 'numbertitle','off');
             S.tx(2) = uicontrol('units','pixels',...
                  'style','edit',...
                  'unit','pix',...
                  'position',[20 15 260 30],...
                   'string','No path selected');
            S.ed(2) = uicontrol('units','pixels',...
                  'style','edit',...
                  'unit','pix',...
                  'position',[20 15 260 30],...
                   'string','No path selected');
            srcPath = uigetdir('C:\Users\Usuario','Select the sequence path'); %DIRECTORI  ON ESTAN LES IMATGES
            
            set(S.ed(2),'string',srcPath);
            set(S.pb(2),{'enable'},{'on'});
            set(S.fh(1),'CloseRequestFcn', @preCloseMain);
         catch
            disp('Unable to Load.  Check Name and Try Again.')
         end
    end

    function preCloseMain(varargin)
      try 
%        fprintf('Closing non-main figures!\n');
        close(S.fh(2));
        close(S.fh(3));
      end 
%      fprintf('Closing main figure!\n');     
      delete(S.fh(1));
    end

end