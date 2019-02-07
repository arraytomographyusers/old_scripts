function [] = GUI_align()

S.fh = figure('units','pixels',...
              'position',[600 550 150 120],...
              'menubar','none',...
              'name',' Segment',...
              'numbertitle','off',...
              'resize','off'); 
       
S.tx(1) = uicontrol('units','pixels',...
                 'style','text',...
                 'unit','pix',...
                 'position',[20 80 110 25],...
                 'string','Reference channel');    
S.ed(1) = uicontrol('style','edit',...
                 'unit','pix',...
                 'position',[20 60 110 25],...
                 'string','psd');    
S.pb(1) = uicontrol('style','push',...
                 'unit','pix',...
                 'position',[20 20 110 30],...
                 'string','Align',...
                 'callback',{@analyze,S},...
                 'enable','off');
S.fm = uimenu(S.fh,...
                 'label','Select path',...
                 'callback',{@fm_call,S},...
                 'enable','on');         
                     
S.NAME = {'No sequence selected'};

           
    function [] = analyze(varargin)
    % Callback for pushbutton.
%       try
        ref = get(S.ed(1),'string');
        path = get(S.ed(3),'string');

       col = get(S.pb(1),'backg');  % Get the background color of the figure.
       pause(.05)
       set(S.ed(1),{'enable'},{'off'});
       set(S.pb(1),'str','RUNNING...','backg',[1 .6 .6]) 
       
       pause(.05)
       align_module(path,ref) 
       
       pause(.01)
       set(S.pb(1),'str','Align','backg',col)
       set(S.ed(1),{'enable'},{'on'});
       close(S.fh(2));
%       catch
%        pause(.01)
%        set(S.pb(1),'str','Analyze','backg',col)
%        set(S.ed(1),{'enable'},{'on'});
%        disp('[GUI_align] Unable to align. Please check srcPath and try again')
%       end
  % Now reset the button features.
    end
  

    function [] = fm_call(varargin)     
         try
            S.fh(2) = figure('units','pixels',...
                 'position',[470 250 300 70],...
                 'name','Select sequence to previsualize',...
                 'menubar','none',...
                 'numbertitle','off');
            S.ed(3) = uicontrol('units','pixels',...
                  'style','edit',...
                  'unit','pix',...
                  'position',[20 20 260 30],...
                   'string','No path selected');
               
            set(S.fh(1),'CloseRequestFcn', @preCloseMain);
            srcPath = uigetdir('C:\Users\Usuario','Select the sequence path'); %DIRECTORI  ON ESTAN LES IMATGES
            
            set(S.ed(3),'string',srcPath);
            set(S.pb,{'enable'},{'on'});
         catch
            disp('[GUI_align] Unable to Load.  Check Name and Try Again.')
         end
    end

    function preCloseMain(varargin)
      try 
%        fprintf('Closing non-main figures!\n');
        close(S.fh(2));
        
        handles=findall(0,'type','figure'); % find all handles opened
        close(handles);
      end 
%      fprintf('Closing main figure!\n');     
      delete(S.fh(1));
    end

end