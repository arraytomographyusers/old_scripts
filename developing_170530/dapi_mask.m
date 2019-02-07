function dapi_mask(segmentedFolder,maskFolder)

% Finds and prints names of all PNG, JPG, and TIF images in 
% that folder and all of its subfolders.
clc;    % Clear the command window.
workspace;  % Make sure the workspace panel is showing.
format longg;
format compact;
warning('off','all')

if segmentedFolder == 0
    message = sprintf('Sorry, but you have to choice a directory... Lets try again! :)');
    uiwait(warndlg(message));
	return;
end

%% Get mask names
filePattern = sprintf('%s/*.tif', maskFolder);
baseMaskNames = dir(filePattern);
numberOfMasks = length(baseMaskNames);
  

%% Apply masking to segmented images

% Process all image files in those folders.
% h=waitbar(0,'Processing images...');

% Add on TIF files.
filePattern = sprintf('%s/*.tif', segmentedFolder);
baseFileNames = dir(filePattern);
numberOfImageFiles = length(baseFileNames);
% Now we have a list of all files in this folder.   
%     waitbar(k/numberOfFolders,h,sprintf('Aligning images of %s ROI...',ROI))
if (numberOfImageFiles >= 1)
    fprintf('\n     Masking images in folder %s\n', segmentedFolder);

    for i = 1 : numberOfMasks
        
        split = strsplit(baseMaskNames(i).name,'mask');
        id_mask = split{1};
        fullMaskName = fullfile(maskFolder, baseMaskNames(i).name);
        mask = imcomplement(logical(read_stackTiff(fullMaskName)));
        % Go through selected image files
        for f = 1 : numberOfImageFiles
            if (strfind(baseFileNames(f).name,id_mask)>0)
                
                fullFileName = fullfile(segmentedFolder, baseFileNames(f).name);

                fprintf('Masking %s with %s\n', baseFileNames(f).name, baseMaskNames(i).name)
                I = logical(read_stackTiff(fullFileName));

                delete(fullFileName);

                [f,c,p]=size(I);
                outputFileName = fullFileName;
                
%                 for j=1:p
%                     Imasked(:,:,j) = I(:,:,j).*mask(:,:,j);
% %                     imwrite(uint16(Imasked),outputFileName,'WriteMode','append','Compression','none');
%                 end
                
                for j=1:p
                    Imasked = I(:,:,j).*mask(:,:,j);
                    imwrite(uint16(Imasked),outputFileName,'WriteMode','append','Compression','none');
                end
            end
        end
    end

else
		fprintf('     Folder %s has no image files in it.\n', segmentedFolder);
end

fprintf('\n     Folder %s doner!\n', segmentedFolder);
