% this function allows to align all sequences with the same name that are
% into the main folder from the sequence 'ref'

function align_module(topLevelFolder,ref)

% Start with a folder and get a list of all subfolders.
% Finds and prints names of all PNG, JPG, and TIF images in 
% that folder and all of its subfolders.
clc;    % Clear the command window.
workspace;  % Make sure the workspace panel is showing.
format longg;
format compact;
warning('off','all')

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

% Process all image files in those folders.
h=waitbar(0,'Processing images...');
mkdir(topLevelFolder,'\aligned\');

for k = 1 : numberOfFolders 
    
    % Get this folder and print it out.
    thisFolder = listOfFolderNames{k};
    fprintf('Processing folder %s\n', thisFolder);

    parts = strsplit(thisFolder, '\');
    ROI = parts{end};

    % Add on TIF files.
    filePattern = sprintf('%s/*.tif', thisFolder);
    baseFileNames = dir(filePattern);
    numberOfImageFiles = length(baseFileNames);

    % Now we have a list of all files in this folder.
    fprintf('\n     Searching for %s image and aligning... \n',ref);      
    waitbar(k/numberOfFolders,h,sprintf('Aligning images of %s ROI...',ROI))
    if (and(numberOfImageFiles >= 1,strfind(thisFolder, '\stack')>0))
        for i = 1 : numberOfImageFiles
            fullFileName = fullfile(thisFolder, baseFileNames(i).name);

            if strfind(baseFileNames(i).name,ref) > 0
                [t,RegRigPSD,RegAfPSD] = align(fullFileName);
%                 fprintf('\n     Processing image file %s\n', fullFileName);
            end
        end

        % Go through all those image files.
        for f = 1 : numberOfImageFiles
            fullFileName = fullfile(thisFolder, baseFileNames(f).name);

            image = read_stackTiff(fullFileName);
            [x,y,z]=size(image);
            %%%% INITIALIZE IMAGE_REG????

            fprintf('     Processing image file %s\n', baseFileNames(f).name);
            for i=1:z
                moving=image(:,:,i);
                tform = t(i).tformfin;
                image_reg(:,:,i) = imwarp(moving,tform,'OutputView',imref2d(size(image(:,:,1))));
                imwrite(image_reg(:,:,i),strcat(topLevelFolder,'\aligned\',baseFileNames(f).name),'WriteMode', 'append',  'Compression','none');
            end 
        end
        fprintf('\n Alignment done! \n');
    else
        fprintf('     Folder %s has no image files in it or is not named "stack". Check the folder name.\n', thisFolder);
    end
end
warning('on','all')
close(h)

    
