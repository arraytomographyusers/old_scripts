function [Area_neuropil,neuropilmask] =  Neuropil_mask (name, srcPath, I)

mkdir(srcPath,'\Results\Neuropil_mask');

    [f,c,p]=size(I);

    zproj = max (I,[],3);
    zproj = zproj*100000;
% 
%     zproj_med = medfilt2(zproj,[7 7]);

    zproj_dil = imdilate(zproj, strel('disk',19));
    neuropilmask = imerode(zproj_dil, strel('disk',10));
   
    %%calcula l'area que ocupa la mascara i guarda el valor
    Area_neuropil = (sum (sum(neuropilmask))/65535)*p;

    %%canals de colors
%     zproj_closed = imcomplement(zproj_closed);
%     rgb = cat(3, (zproj_closed+ zproj), zproj,  zproj);

    %%guarda la imatge
    seq_name = name(1:(end-4));

    outputFileName = strcat(srcPath,'\Results\Neuropil_mask\',seq_name,'_neuropilMask.tif');
    imwrite(uint16(neuropilmask),outputFileName, 'WriteMode', 'append',  'Compression','none');
     
end

    


