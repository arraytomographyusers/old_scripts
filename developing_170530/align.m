% This function computes the 't' transform for the image 'ref' and applies
% this transform to the other markers of the same sequence

function [t,RegisteredRigid, RegisteredAffine] = align(fullfilename)

stack = read_stackTiff(fullfilename);

[x,y,z]=size(stack);

I2=mat2gray(stack);
meanI2=zeros(size(I2));
sI2=meanI2;
bwI2=meanI2;
join1D = false([x y]);
join2D =false(size(bwI2));

for i=1:z
%     stret = stretchlim(I2(:,:,i));
    C=-median(median(I2(:,:,i)))/1.5; %%%valor modificable (median,stretch, bins,...)
    meanI2(:,:,i)=imfilter(I2(:,:,i),fspecial('average',10),'replicate');

    sI2(:,: ,i)=meanI2(:,:,i)-I2(:,:,i)-C;
    bwI2(:,:,i)=im2bw(sI2(:,:,i),0);
    bwI2(:,:,i)=imcomplement(bwI2(:,:,i));

    %remove small dots in 2D
    CCbwI2(i).CC=bwconncomp(bwI2(:,:,i),4);
    for ii=1:CCbwI2(i).CC.NumObjects
            pixId=CCbwI2(i).CC.PixelIdxList{ii};
                if (length(pixId)>2) 
                    join1D(CCbwI2(i).CC.PixelIdxList{ii})=true;
                end
     end   
     join2D(:,:,i)=join1D;
     join1D = false([x y]);
end 

I = join2D.*I2;

optimizer = registration.optimizer.OnePlusOneEvolutionary;
metric = registration.metric.MattesMutualInformation;

%[optimizer, metric]  = imregconfig('monomodal'); % for optical microscopy you need the 'monomodal' configuration.
optimizer.InitialRadius=1e-4;
optimizer.Epsilon=1.5e-8;
optimizer.MaximumIterations = 300;

iref = round(z/2);

RegisteredRigid = zeros(size(stack));
RegisteredRigid(:,:,iref) = I(:,:,iref);
RegisteredAffine = RegisteredRigid;


tform_ref = affine2d([1 0 0; 0 1 0; 0 0 1]);
t(iref).rigid = tform_ref;

% Rigid Body
for p = iref+1:z
   moving = I(:,:,p); % the image you want to register
   fixed = I(:,:,p-1); % the image you are registering with
   
   scaleFactorDown = 1/6;
   moving = imresize(moving,scaleFactorDown);
   fixed  = imresize(fixed,scaleFactorDown);

   tform = imregtform(moving,fixed,'rigid',optimizer,metric,'DisplayOptimization',false,'PyramidLevels',3);                   
   tform.T(3,1:2) = tform.T(3,1:2) .* 1/scaleFactorDown;
   t(p).rigid = affine2d(tform.T);
end

for p = iref-1:-1:1
   moving = I(:,:,p); % the image you want to register
   fixed = I(:,:,p+1); % the image you are registering with
   
   scaleFactorDown = 1/6;
   moving = imresize(moving,scaleFactorDown);
   fixed  = imresize(fixed,scaleFactorDown);

   tform = imregtform(moving,fixed,'rigid',optimizer,metric,'DisplayOptimization',false,'PyramidLevels',3);                   
   tform.T(3,1:2) = tform.T(3,1:2) .* 1/scaleFactorDown;
   t(p).rigid = affine2d(tform.T);
end

t(iref).T = t(iref).rigid.T;

for i=iref+1:z
    t(i).T = t(i-1).T*t(i).rigid.T;
end
for i=iref-1:-1:1
    t(i).T = t(i+1).T*t(i).rigid.T;
end

for i=1:z
    moving = I(:,:,i); % the image you want to register
    tform = affine2d(t(i).T);
    RegisteredRigid(:,:,i) = imwarp(moving,tform,'OutputView',imref2d(size(I(:,:,1))));
end

% Affine
for p = 2:z
   moving = RegisteredRigid(:,:,p); % the image you want to register
   fixed = RegisteredRigid(:,:,p-1); % the image you are registering with

   scaleFactorDown = 1/6;
   moving = imresize(moving,scaleFactorDown);
   fixed  = imresize(fixed,scaleFactorDown);
   
   tform = imregtform(moving,fixed,'affine',optimizer,metric,'DisplayOptimization',false,'PyramidLevels',3);                   
   tform.T(3,1:2) = tform.T(3,1:2) .* 1/scaleFactorDown;
   t(p).affine = affine2d(tform.T);
   
end

t(1).Taf = t(1).rigid.T;
for i=2:z
    t(i).Taf = t(i-1).Taf*t(i).affine.T;
end

for i=1:z
    moving = RegisteredRigid(:,:,i); % the image you want to register
    tform = affine2d(t(i).Taf);
    RegisteredAffine(:,:,i) = imwarp(moving,tform,'OutputView',imref2d(size(I(:,:,1))));
end

% Extract final TFORM to apply it to other channels
for i=1:z
    t(i).Tdef = t(i).T*t(i).Taf;
    t(i).tformfin = affine2d(t(i).Tdef);
end

end