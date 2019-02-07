function mask=segment_epi(I)

[f,c,p]=size(I);

Imat = mat2gray(I);
meanImat=zeros(size(Imat));
sImat=meanImat;
bwImat=meanImat;
% join1D = false([f c]);
join2D =false(size(bwImat));

for i=1:p
    C=-median(median(Imat(:,:,i)))/12; %%%valor modificable (median,stretch, bins,...)
    meanImat(:,:,i)=imfilter(Imat(:,:,i),fspecial('average',25),'replicate');

    sImat(:,:,i)=meanImat(:,:,i)-Imat(:,:,i)-C;
    bwImat(:,:,i)=im2bw(sImat(:,:,i),0);
    bwImat(:,:,i)=imcomplement(bwImat(:,:,i));    
   
end

[join2D, CC] = connectivity(bwImat,15,9999999999);
join2D_dil = imdilate(join2D, strel('disk',5));
%join2D_fill = imfill(join2D_dil,'holes');

mask = imcomplement(join2D_dil);

%% Save and print results

% for i=1:p
%        outputFileName = strcat(srcPath,'\masks\',id,'_mask.tif');
%        imwrite(uint16(mask(:,:,i)),outputFileName, 'WriteMode', 'append',  'Compression','none');
% end