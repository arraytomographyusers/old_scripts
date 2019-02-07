function [overlap,obj_size] = randomize(bw1,bw2,neuropilmask)
[x,y,z] = size(bw1.BW);
pix = x*y*z;
overlap = zeros(1,100);
obj_size = zeros(1,100);
% CC = bwconncomp(bw1,6);

neuropilmask = imdilate(neuropilmask,strel('disk',21));
neuropilmask = imfill(neuropilmask,'holes');

for i=1:z
    mask(:,:,i) = neuropilmask;
end

h=waitbar(0,'Randomize...');
    for i=1:100
        waitbar(i/100,h,sprintf('Randomizing for image %s...',bw1.name));
        RAND1=false(size(bw1.BW));
        reconst = zeros(size(RAND1));

         for obj=1:bw1.CC.NumObjects
             pixID_rand=bw1.CC.PixelIdxList{1,obj}+randi([-pix pix]);
             pixID_rand_mod=mod(pixID_rand,pix)+1;
             while mask(pixID_rand_mod(1)) < 1
                pixID_rand=bw1.CC.PixelIdxList{1,obj}+randi([-pix pix]);
                pixID_rand_mod=mod(pixID_rand,pix)+1;
             end
             RAND1(pixID_rand_mod)=true;
         end

        BW = bwconncomp(RAND1.*bw2.BW,6);
        overlap(i)=BW.NumObjects*100/bw1.CC.NumObjects;
        
        reconst = imreconstruct(logical(RAND1.*bw2.BW),RAND1);
        CC = bwconncomp(reconst,6);
        A = struct2array(regionprops(CC,'Area'));
        obj_size(i)= median(A);      
    end
    close(h)
end