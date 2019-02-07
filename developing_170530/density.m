function density(srcPath,channels,NeuropilChannel)

mkdir(srcPath,'\Results');

srcFiles = strcat(srcPath,'/*.tif');  % the folder in which ur images exists
srcFiles = dir(srcFiles);
[x,y] = size(srcFiles);

fprintf('\n[ EXTRACTING STATS... ]\n');
%find positions of channels in srcFiles
disp('Assigning positions to srcFiles')

pos = 1;
for i=1:x
    for j=1:length(channels)
        if strfind(srcFiles(i).name, channels{j})>0
            position(pos) = i; %anar assignant les posicions dels srcFiles a processar en un vector
            pos=pos+1;
        end
    end
end

fprintf('Writting excel stats...\n')

for i=1:length(position)
    pos = position(i);
    I = read_stackTiff(strcat(srcPath,'/',srcFiles(pos).name));
    srcFiles(pos).BW = logical(I);
    srcFiles(pos).CC = bwconncomp(srcFiles(pos).BW, 6);
    
    if strfind((srcFiles(i).name),NeuropilChannel)>0
        [areaneuropil,neuropilmask] = Neuropil_mask (srcFiles(pos).name, srcPath, I);
        srcFiles(pos).areaneuropil = areaneuropil;
    else
       srcFiles(pos).areaneuropil = 0;
    end

    %excel export
    H = {'Sequence name', '#Objects', 'Total area (vox)', 'Neuropil area (vox)'};
    xlswrite(strcat(srcPath,'\Results\Stats.xls'),H,'Hoja1',strcat('A1'));

    %stats
    [m,n,p] = size(srcFiles(pos).BW);
    num_vox = m*n*p;

    S = {srcFiles(pos).name (srcFiles(pos).CC.NumObjects) num_vox (srcFiles(pos).areaneuropil)};
    xlswrite(strcat(srcPath,'\Results\Stats.xls'),S,'Hoja1',strcat('A',num2str(i+1)));
    fprintf('     Sequence %s processed\n',srcFiles(pos).name)
end

fprintf('\n[ ANALYSES DONE ] \n')