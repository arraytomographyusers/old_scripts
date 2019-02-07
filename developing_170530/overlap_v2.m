function overlap_v2(srcPath, channels, active_synap,min_pix,max_pix, NeuropilChannel, R)
tic
fprintf('\n[ INITIALIZING... ]\n'); 
mkdir(srcPath,'\Results');

srcFiles = strcat(srcPath,'/*.tif');  % the folder in which ur images exists
srcFiles = dir(srcFiles);
[x,y] = size(srcFiles);

%find positions of channels in srcFiles
disp('Assigning positions to srcFiles and reading images...')

%waitbar?
pos = 1;
for i=1:x
    for j=1:length(channels)
        if strfind(srcFiles(i).name, channels{j})>0
            I = read_stackTiff(strcat(srcPath,'/',srcFiles(i).name));
            BW = logical(I);
            
            if strfind((srcFiles(i).name),NeuropilChannel)>0
                [areaneuropil,neuropilmask] = Neuropil_mask (srcFiles(i).name, srcPath, I);
                srcFiles(i).areaneuropil = areaneuropil;
            else
               srcFiles(i).areaneuropil = 0;
            end

            minobj = min_pix {j};
            maxobj = max_pix {j};
            [srcFiles(i).BW,srcFiles(i).CC] = connectivity(BW,minobj,maxobj);
            srcFiles(i).id = extractID(srcFiles(i).name,channels); %implementar funció que extregui id de cada seq (utilitzar '_' com a separador)
            srcFiles(i).channel = channels{j};
            position(pos) = i; %anar assignant les posicions dels srcFiles a processar en un vector
            pos=pos+1;
        end
    end
end

%Unique identifier of sequences
C = cellfun(@char,{srcFiles.id},'unif',0);
C = C(~cellfun('isempty',C));
[uid,idx] = unique(C);

%One struct for each sequence
sequence=struct.empty;
for j=1:length(uid)
    pos = 1;
    for i=1:x
        if strfind(srcFiles(i).id, uid{j}) > 0
            cc = uid{j};
            sequence(j).cc(pos) = srcFiles(i);
            pos = pos+1;
        end
    end
end

fprintf(strcat('\n[ CHANNELS READ ]\n[ OVERLAPPING IN PROCESS... ]\n'));
fprintf('Overlapping channels in folder %s\n', srcPath)
channels = sort(channels);

row=0;
loop = 1;
for i=1:length(uid)
    
    CurrentChannel = sequence(i).cc;
    [row,loop]=overlapping_v2(srcPath, CurrentChannel, R, channels, neuropilmask, active_synap, loop, row);
%     fprintf('\n     Sequence %s processed\n',CurrentChannel.name)
    fprintf('\n');
end
toc

fprintf('\n[ OVERLAPPING DONE! ]\n'); 
